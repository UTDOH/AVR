package gov.utah.health.avr2.spring.security;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.GrantedAuthority;
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
	
	/**
	 * The JNDI database connection 
	 */
	private DataSource trisanoDataSource;
	
	/**
	 * The SQL Query to get the jurisdictions from Trisano
	 */
	private String jurisdictionsByUserQuery = BLANK;
	
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
		boolean isSiteMinderLogin = false;
		String userName = BLANK;
		String password = BLANK;
		
		logger.info("attemptAuthentication() start..");
		
		if (!isEmptyString(siteMinderPasswordHeaderKey) && !isEmptyString(siteMinderUsernameHeaderKey)) {
//			userName = request.getHeader(siteMinderUsernameHeaderKey);
//			password = request.getHeader(siteMinderPasswordHeaderKey);trisanoJNDIConnectionName
			 
			userName = request.getParameter(siteMinderUsernameHeaderKey);
			password = request.getParameter(siteMinderPasswordHeaderKey);
			
			logger.info("SiteMinder HTTPServletRequest header values: [username=(" + userName + "), password=(" + password + ")");
		}
		
		// Check username / password values and use form parameters instead
		if (isEmptyString(userName) || isEmptyString(password)) {
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
		} else {
			isSiteMinderLogin = true;
		}
		
		if (isEmptyString(userName)) {
			userName = BLANK;
		}
		
		if (isEmptyString(password)) {
			password = BLANK;
		}
		
		UsernamePasswordAuthenticationToken authToken 
			= new UsernamePasswordAuthenticationToken(userName, password);
		
		if (isSiteMinderLogin) {
			List<GrantedAuthority> authorities = getUserJurisdictions(userName);
			if (authorities != null) {
				for (GrantedAuthority auth : authorities) {
					logger.info("GrantedAuthority -> " + auth.getAuthority());
				}
			}
		}
		
		setDetails(request, authToken);
		
		request.getSession().setAttribute(SPRING_SECURITY_LAST_USERNAME_KEY, userName);
		
		
		logger.info("attemptAuthentication() end..");
		
		// Authenticate
		Authentication auth = this.getAuthenticationManager().authenticate(authToken);
		
		return auth;
	}
	
	/**
	 * Get the <code>GrantedAuthority</code> objects for each trisano jurisdiction of the logged in user
	 * 
	 * @param uid
	 * 			The Trisano user UID to lookup
	 * @return
	 * 			The List of <code>GrantedAuthority</code> objects, one for each jurisdiction
	 */
	private List<GrantedAuthority> getUserJurisdictions(String uid) {
		List<GrantedAuthority> grantedAuthorities = new ArrayList<GrantedAuthority>();
		Connection c = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int iUID = new Integer(uid);
		
		try {
			c = trisanoDataSource.getConnection();
			ps = c.prepareStatement(jurisdictionsByUserQuery);
			ps.setInt(1, iUID);
			
			rs = ps.executeQuery();
			GrantedAuthority grantedAuthority = null;
			while(rs.next()) {
				final String authority = rs.getString(1);
				grantedAuthority = new GrantedAuthority() {
					
					@Override
					public int compareTo(Object arg0) {
						return 0;
					}
					
					@Override
					public String getAuthority() {
						return authority;
					}
				};
				
				grantedAuthorities.add(grantedAuthority);
			}
			
			
		} catch (SQLException e) {
			logger.severe("Error building Trisano user roles: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				rs.close();
			} catch (Exception e1) {e1.printStackTrace();}
			
			try {
				ps.close();
			} catch (Exception e1) {e1.printStackTrace();}
			
			try {
				c.close();
			} catch (Exception e1) {e1.printStackTrace();}
		}
		
		return grantedAuthorities;
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

	public DataSource getTrisanoDataSource() {
		return trisanoDataSource;
	}

	public void setTrisanoDataSource(DataSource trisanoDataSource) {
		this.trisanoDataSource = trisanoDataSource;
	}

	public String getJurisdictionsByUserQuery() {
		return jurisdictionsByUserQuery;
	}

	public void setJurisdictionsByUserQuery(String jurisdictionsByUserQuery) {
		this.jurisdictionsByUserQuery = jurisdictionsByUserQuery;
	}
}
