package gov.utah.health.dw.spring.security;

import java.util.Enumeration;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * OpenAM Plugin for Spring Security in UDOH Pentaho
 * 
 * 
 * @author Trevor MacDuff
 */
public class UDOHSSOAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

	private static final Logger logger = Logger.getLogger(UDOHSSOAuthenticationFilter.class.getName());

	private static final String BLANK = "";

	/**
	 * The site minder Key to lookup the password from the HTTP request header
	 */
	private String openAMPasswordHeaderKey = BLANK;

	/**
	 * The site minder key to lookup the username from the HTTP request header
	 */
	private String openAMUsernameHeaderKey = BLANK;

	/**
	 * The password form parameter key
	 */
	private String formPasswordParamKey = BLANK;

	/**
	 * The username form parameter key
	 */
	private String formUsernameParamKey = BLANK;

	/**
	 * The set of URLs where auth will be ignored - typically these are web assets that are on the login screen
	 */
	private Set<String> noAuthURLs;

	/**
	 * Dev mode will allow this integration to be tested by appending the Pentaho Login URL with query parameters
	 * of the username (@see openAMUsernameHeaderKey) and password (@see openAMPasswordHeaderKey).  *This is not 
	 * appropriate to set this to true in production deployments as usernames and passwords will be logged in cleartext*
	 */
	private boolean devMode;

	/**
	 * Default Constructor
	 */
	public UDOHSSOAuthenticationFilter() {
		super();
	}

	/**
	 * Utility to determine if a string is empty (null or zero length)
	 * 
	 * @param targetString The string to determine emptiness from
	 * @return True = string is null or zero length, false otherwise
	 */
	private boolean isEmptyString(String targetString) {
		boolean isEmpty = true;

		if (targetString != null && targetString.length() > 0) {
			isEmpty = false;
		}

		return isEmpty;
	}

	/**
	 * Service method to attempt authentication
	 * 
	 * @param The <code>HttpServletRequest</code>
	 * @param The <code>HttpServletResponse</code>
	 * 
	 * @throws AuthenticationException - Thrown when 
	 */
	@Override
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
			throws AuthenticationException {
		String userName = BLANK;
		String password = BLANK;

		UsernamePasswordAuthenticationToken authToken = null;
		Authentication auth = null;
		boolean isOpenAMAuth = false;

		logger.finest("attemptAuthentication() start..");

		if (!isEmptyString(openAMPasswordHeaderKey) && !isEmptyString(openAMUsernameHeaderKey)) {
			isOpenAMAuth = true;
			if (!devMode) {
				logger.finest("Using request header to gather OpenAM user from key [username:" + openAMUsernameHeaderKey
						+ "], [password:" + openAMPasswordHeaderKey + "]");
				userName = request.getHeader(openAMUsernameHeaderKey);
				password = request.getHeader(openAMPasswordHeaderKey);
			} else {
				logger.finest("Using request parameters to gather OpenAM user from key [username:"
						+ openAMUsernameHeaderKey + "], [password:" + openAMPasswordHeaderKey + "]");
				userName = request.getParameter(openAMUsernameHeaderKey);
				password = request.getParameter(openAMPasswordHeaderKey);
			}

			logger.finest("OpenAM Credentials: [username=(" + userName + "), password=(" + password + ")");
		}

		logger.finest("isOpenAMLogin = " + isOpenAMAuth);

		if (isOpenAMAuth) {
			authToken = new UsernamePasswordAuthenticationToken(userName, password);
			setDetails(request, authToken);
			try {
				auth = this.getAuthenticationManager().authenticate(authToken);
			} catch (AuthenticationException ae) {
				logger.finest("OpenAM authentication not successful.. trying form based login");
			}

			logger.finest("OpenAM login successful? " + (auth != null ? auth.isAuthenticated() : "false-auth is null"));
		}

		logger.finest("After OpenAM Authentication Check: auth=" + auth);

		// Check username / password values and use form parameters instead
		if (auth == null || !auth.isAuthenticated()) {
			logger.finest("OpenAM authenication not found on HTTPRequest headers, Searching form parameters instead");

			// Username
			if (!isEmptyString(formUsernameParamKey)) {
				userName = request.getParameter(formUsernameParamKey);
			} else {
				logger.finest("searching request parameter [j_username]=" + request.getParameter("j_username"));
				userName = request.getParameter("j_username");
			}

			// Password
			if (!isEmptyString(formPasswordParamKey)) {
				password = request.getParameter(formPasswordParamKey);
			} else {
				logger.finest("searching request parameter [j_password]=" + request.getParameter("j_password"));

				password = request.getParameter("j_password");
			}

//			StringBuilder keyValues = new StringBuilder();
//			for(Object key : request.getParameterMap().entrySet()) {
//				keyValues.append(key.toString()).append("=").append("[" + request.getParameter(key.toString()) + "]").append("\n");
//			}
//			logger.finest("Parameter Map:\n" + keyValues.toString());

			authToken = new UsernamePasswordAuthenticationToken(userName, password);
			setDetails(request, authToken);

			// Authenticate
			logger.finest("Authenticating...");
			auth = this.getAuthenticationManager().authenticate(authToken);
			logger.finest("Authentication=" + auth);
//			request.getSession().setAttribute(SPRING_SECURITY_LAST_USERNAME_KEY, userName);
			request.getSession().setAttribute("j_username", userName);
			logger.finest("After form based authentication - auth=" + auth + ", isAuthenticated="
					+ (auth != null ? auth.isAuthenticated() : "false"));
		}

		setDetails(request, authToken);
		logger.finest("attemptAuthentication() end..");

		return auth;
	}

	/**
	 * Overridden to check authentication against URLs other than /Login
	 */
	protected boolean requiresAuthentication(HttpServletRequest request, HttpServletResponse response) {
		boolean requiresAuthentication = super.requiresAuthentication(request, response);

		SecurityContext securityCtx = SecurityContextHolder.getContext();

		String uri = request.getRequestURI();
		int pathIndex = uri.indexOf(";");

		if (pathIndex > 0) {
			uri = uri.substring(0, pathIndex);
		}

		boolean authenticated = false;

		if (securityCtx != null) {
			Authentication authToken = securityCtx.getAuthentication();

			if (authToken != null && authToken instanceof UsernamePasswordAuthenticationToken) {
				UsernamePasswordAuthenticationToken userPassToken = (UsernamePasswordAuthenticationToken) authToken;

				authenticated = userPassToken.isAuthenticated();
			}
		}

		if (!authenticated && !noAuthURLs.contains(uri)) {
			logger.finest("noAuthURLS does not contain (" + uri + ")");
			requiresAuthentication = true;
		}

		logger.finest("requiresAuthentication() [uri: " + request.getRequestURI() + " = " + requiresAuthentication
				+ "], authenticated=" + authenticated);

		String logHeaderValues = BLANK;
		logHeaderValues = request.getParameter("logHeaderValues");
		if (logHeaderValues != null && "true".equalsIgnoreCase(logHeaderValues)) {
			logger.finest("Log Header Values");
			Enumeration<String> headerEnum = request.getHeaderNames();
			StringBuffer headerKVP = new StringBuffer();
			while (headerEnum.hasMoreElements()) {
				String name = headerEnum.nextElement();
				String value = request.getHeader(name);
				headerKVP.append("key=(").append(name).append("), value=(").append(value).append(")");
				if (headerEnum.hasMoreElements()) {
					headerKVP.append("\n");
				}
			}

			logger.finest("Header Key Value Pairs: \n" + headerKVP.toString());
		}

		return requiresAuthentication;
	}

	public String getOenAMPasswordHeaderKey() {
		return openAMPasswordHeaderKey;
	}

	public void setOpenAMPasswordHeaderKey(String openAMPasswordHeaderKey) {
		this.openAMPasswordHeaderKey = openAMPasswordHeaderKey;
	}

	public String getOpenAMUsernameHeaderKey() {
		return openAMUsernameHeaderKey;
	}

	public void setOpenAMUsernameHeaderKey(String openAMUsernameHeaderKey) {
		this.openAMUsernameHeaderKey = openAMUsernameHeaderKey;
	}

	public String getFormPasswordParamKey() {
		return formPasswordParamKey;
	}

	public void setFormPasswordParamKey(String formPasswordParamKey) {
		this.formPasswordParamKey = formPasswordParamKey;
	}

	public String getFormUsernameParamKey() {
		return formUsernameParamKey;
	}

	public void setFormUsernameParamKey(String formUsernameParamKey) {
		this.formUsernameParamKey = formUsernameParamKey;
	}

	public boolean isDevMode() {
		return devMode;
	}

	public void setDevMode(boolean devMode) {
		this.devMode = devMode;
	}

	public Set<String> getNoAuthURLs() {
		return noAuthURLs;
	}

	public void setNoAuthURLs(Set<String> noAuthURLs) {
		logger.finest(">>>>>>>>>>>>>>>> received noAuthURLs object [class=" + noAuthURLs.getClass().getName() + "]");
		logger.finest("noAuthURLs instance of java.util.Set<String>? " + (noAuthURLs instanceof java.util.Set));

		logger.finest("No Auth URLs:");
		for (String url : noAuthURLs) {
			logger.finest("[" + url + "]");
		}
		logger.finest("end logging no auth urls");
		this.noAuthURLs = noAuthURLs;
	}
}
