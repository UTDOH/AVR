package gov.utah.health.avr2.spring.security;

import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.context.HttpSessionContextIntegrationFilter;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.webapp.AuthenticationProcessingFilter;




/**
 * SiteMinder Plugin for Spring Security in AVR2
 * 
 * 
 * @author Trevor MacDuff
 */
public class SiteMinderSpringAuthenticationProcessingFilter extends
		AuthenticationProcessingFilter {
	
	private static final Logger logger = Logger.getLogger(SiteMinderSpringAuthenticationProcessingFilter.class.getName());

	private static final String BLANK = "";
	
	/**
	 * The site minder Key to lookup the password from the HTTP request header
	 */
	private String siteMinderPasswordHeaderKey = BLANK;
	
	/**
	 * The site minder key to lookup the username from the HTTP request header
	 */
	private String siteMinderUsernameHeaderKey = BLANK;
	
	/**
	 * The password form parameter key
	 */
	private String formPasswordParamKey = BLANK;	
	
	/**
	 * The username form parameter key
	 */
	private String formUsernameParamKey = BLANK;
	
	private boolean devMode;
	
	/**
	 * Default Constructor
	 */
	public SiteMinderSpringAuthenticationProcessingFilter() {
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
	public Authentication attemptAuthentication(HttpServletRequest request)
			throws AuthenticationException {
		String userName = BLANK;
		String password = BLANK;
		UsernamePasswordAuthenticationToken authToken = null;
		Authentication auth = null;
		boolean isSiteMinderLogin = false;
		
		logger.info("attemptAuthentication() start..");
		
		if (!isEmptyString(siteMinderPasswordHeaderKey) && !isEmptyString(siteMinderUsernameHeaderKey)) {
			isSiteMinderLogin = true;
			if (!devMode) {
				userName = request.getHeader(siteMinderUsernameHeaderKey);
				password = request.getHeader(siteMinderPasswordHeaderKey);
			} else {
				userName = request.getParameter(siteMinderUsernameHeaderKey);
				password = request.getParameter(siteMinderPasswordHeaderKey);
			}
			
			logger.info("SiteMinder HTTPServletRequest header values: [username=(" + userName + "), password=(" + password + ")");
		}
		
		logger.info("isSiteMinderLogin = " + isSiteMinderLogin);
		
		if (isSiteMinderLogin) {
			authToken = new UsernamePasswordAuthenticationToken(userName, password);
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
				userName = request.getParameter(SPRING_SECURITY_FORM_USERNAME_KEY);
			}
			
			// Password
			if(!isEmptyString(formPasswordParamKey)) {
				password = request.getParameter(formPasswordParamKey);
			} else {
				password = request.getParameter(SPRING_SECURITY_FORM_PASSWORD_KEY);
			}
			
			authToken = new UsernamePasswordAuthenticationToken(userName, password);
			
			// Authenticate
			auth = this.getAuthenticationManager().authenticate(authToken);
			request.getSession().setAttribute(SPRING_SECURITY_LAST_USERNAME_KEY, userName);
			logger.info("After form based authentication - auth=" + auth + ", isAuthenticated=" + (auth != null ? auth.isAuthenticated() : "false"));
		}
		
		setDetails(request, authToken);
		logger.info("attemptAuthentication() end..");
		
		return auth;
	}
	


	/**
	 * Overridden to check authentication against URLs other than /Login
	 */
	@Override
	protected boolean requiresAuthentication(HttpServletRequest request,
			HttpServletResponse response) {
		
		boolean authenticated = false;
		String uri = request.getRequestURI();
		int pathIndex = uri.indexOf(";");
		
		if (pathIndex > 0) {
			uri = uri.substring(0, pathIndex);
		}
		
		SecurityContext securityCtx = (SecurityContext) request.getSession().getAttribute(
				HttpSessionContextIntegrationFilter.SPRING_SECURITY_CONTEXT_KEY);
		
		if (securityCtx != null) {
			Authentication authToken = securityCtx.getAuthentication();
			
			if (authToken != null && authToken instanceof UsernamePasswordAuthenticationToken) {
				UsernamePasswordAuthenticationToken userPassToken = (UsernamePasswordAuthenticationToken) authToken;
				
				authenticated = userPassToken.isAuthenticated();
			}
		}
		
		boolean attemptAuthentication = (uri.endsWith(request.getContextPath() + getFilterProcessesUrl()))
        	|| ((getDefaultTargetUrl() != null) && uri.endsWith(getDefaultTargetUrl()) && !authenticated);
		
		
		logger.fine("URI (" + uri + ") - requires authentication? " + attemptAuthentication);
		
		return attemptAuthentication;
	}

	public String getSiteMinderPasswordHeaderKey() {
		return siteMinderPasswordHeaderKey;
	}

	public void setSiteMinderPasswordHeaderKey(String siteMinderPasswordHeaderKey) {
		this.siteMinderPasswordHeaderKey = siteMinderPasswordHeaderKey;
	}

	public String getSiteMinderUsernameHeaderKey() {
		return siteMinderUsernameHeaderKey;
	}

	public void setSiteMinderUsernameHeaderKey(String siteMinderUsernameHeaderKey) {
		this.siteMinderUsernameHeaderKey = siteMinderUsernameHeaderKey;
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
}
