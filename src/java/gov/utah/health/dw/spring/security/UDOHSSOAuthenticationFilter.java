package gov.utah.health.dw.spring.security;

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
 * SiteMinder Plugin for Spring Security in AVR2
 * 
 * 
 * @author Trevor MacDuff
 */
public class UDOHSSOAuthenticationFilter extends
		UsernamePasswordAuthenticationFilter {
	
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
	
	private Set<String> noAuthURLs;
	
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
	 * @param targetString
	 * 			The string to determine emptiness from
	 * @return
	 * 		True = string is null or zero length, false otherwise
	 */
	private boolean isEmptyString(String targetString)
	{
		boolean isEmpty = true;
		
		if (targetString != null && targetString.length() > 0) {
			isEmpty = false;
		}
			
			
		return isEmpty;
	}
	
	
	@Override
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
			throws AuthenticationException {
		String userName = BLANK;
		String password = BLANK;
		UsernamePasswordAuthenticationToken authToken = null;
		Authentication auth = null;
		boolean isSiteMinderLogin = false;
		
		logger.info("attemptAuthentication() start..");
		
		if (!isEmptyString(openAMPasswordHeaderKey) && !isEmptyString(openAMUsernameHeaderKey)) {
			isSiteMinderLogin = true;
			if (!devMode) {
				userName = request.getHeader(openAMUsernameHeaderKey);
				password = request.getHeader(openAMPasswordHeaderKey);
			} else {
				userName = request.getParameter(openAMUsernameHeaderKey);
				password = request.getParameter(openAMPasswordHeaderKey);
			}
			
			logger.info("SiteMinder HTTPServletRequest header values: [username=(" + userName + "), password=(" + password + ")");
		}
		
		logger.info("isSiteMinderLogin = " + isSiteMinderLogin);
		
		if (isSiteMinderLogin) {
			authToken = new UsernamePasswordAuthenticationToken(userName, password);
			setDetails(request, authToken);
			try {
				auth = this.getAuthenticationManager().authenticate(authToken);
			} catch (AuthenticationException ae) {
				logger.info("SiteMinder authentication not successful.. trying form based login");
			}
			
			logger.info("SiteMinder login successful? " + (auth != null ? auth.isAuthenticated() : "false-auth is null"));
		}
		
		logger.info("After SiteMinder Authentication Check: auth=" + auth);
		
		// Check username / password values and use form parameters instead
		if (auth == null || !auth.isAuthenticated()) {
			logger.info("SiteMinder authenication not found on HTTPRequest headers, Searching form parameters instead");
			
			// Username
			if(!isEmptyString(formUsernameParamKey)) {
				userName = request.getParameter(formUsernameParamKey);
			} else {
				logger.info("searching request parameter [j_username]=" + request.getParameter("j_username"));
				userName = request.getParameter("j_username");
			}
			
			// Password
			if(!isEmptyString(formPasswordParamKey)) {
				password = request.getParameter(formPasswordParamKey);
			} else {
				logger.info("searching request parameter [j_password]=" + request.getParameter("j_password"));

				password = request.getParameter("j_password");
			}
			
//			StringBuilder keyValues = new StringBuilder();
//			for(Object key : request.getParameterMap().entrySet()) {
//				keyValues.append(key.toString()).append("=").append("[" + request.getParameter(key.toString()) + "]").append("\n");
//			}
//			logger.info("Parameter Map:\n" + keyValues.toString());
			
			
			authToken = new UsernamePasswordAuthenticationToken(userName, password);
			setDetails(request, authToken);
			
			// Authenticate
			logger.info("Authenticating...");
			auth = this.getAuthenticationManager().authenticate(authToken);
			logger.info("Authentication=" + auth);
//			request.getSession().setAttribute(SPRING_SECURITY_LAST_USERNAME_KEY, userName);
			request.getSession().setAttribute("j_username", userName);
			logger.info("After form based authentication - auth=" + auth + ", isAuthenticated=" + (auth != null ? auth.isAuthenticated() : "false"));
		}
		
		setDetails(request, authToken);
		logger.info("attemptAuthentication() end..");
		
		return auth;
	}
	
	
	
	/**
	 * Overridden to check authentication against URLs other than /Login
	 */
	protected boolean requiresAuthentication(HttpServletRequest request,
			HttpServletResponse response) {
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
			logger.info("noAuthURLS does not contain (" + uri  + ")");
			requiresAuthentication = true;
		}
		
		logger.info("requiresAuthentication() [uri: " + request.getRequestURI() + " = " + requiresAuthentication + "], authenticated=" + authenticated);
        
		return requiresAuthentication;
	}
	
/*
	@Override
	protected boolean requiresAuthentication(HttpServletRequest request,
			HttpServletResponse response) {
		
		boolean authenticated = false;
		String uri = request.getRequestURI();
		int pathIndex = uri.indexOf(";");
		
		if (pathIndex > 0) {
			uri = uri.substring(0, pathIndex);
		}
		
		SecurityContext securityCtx = SecurityContextHolder.getContext();
		
		if (securityCtx != null) {
			Authentication authToken = securityCtx.getAuthentication();
			
			if (authToken != null && authToken instanceof UsernamePasswordAuthenticationToken) {
				UsernamePasswordAuthenticationToken userPassToken = (UsernamePasswordAuthenticationToken) authToken;
				
				authenticated = userPassToken.isAuthenticated();
			}
		}
		
//		boolean attemptAuthentication = (uri.endsWith(request.getContextPath() + getFilterProcessesUrl()))
//        	|| ((getDefaultTargetUrl() != null) && uri.endsWith(getDefaultTargetUrl()) && !authenticated);
		
		boolean attemptAuthentication = true;
		
		if (noAuthURLs.contains(uri) || uri.matches(".*js") || uri.matches(".*css") || uri.matches(".*ttf")
				|| uri.matches(".*woff") || uri.matches(".*svg") || uri.matches(".*png")) {
			attemptAuthentication = false;
		} else if (!authenticated) {
			attemptAuthentication = true;
		}
		
		//|| !authenticated;
		
//		logger.info("noAuthURLs.contains(uri): " + noAuthURLs.contains(uri));
//		logger.info("authenticated: " + authenticated);
		
		logger.info("URI (" + uri + ") - requires authentication? " + attemptAuthentication);
	
		
		
		return attemptAuthentication;
	}
*/

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
		logger.info(">>>>>>>>>>>>>>>> received noAuthURLs object [class=" + noAuthURLs.getClass().getName() + "]");
		logger.info("noAuthURLs instance of java.util.Set<String>? " + (noAuthURLs instanceof java.util.Set));
		
		logger.info("No Auth URLs:");
		for (String url : noAuthURLs) {
			logger.info("[" + url + "]");
		}
		logger.info("end logging no auth urls");
		this.noAuthURLs = noAuthURLs;
	}
}
