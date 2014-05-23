package gov.utah.health.avr2.spring.security;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.GrantedAuthority;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.userdetails.UserDetails;

public class SpringSecurityDebugServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(SiteMinderSpringAuthenticationProcessingFilter.class.getName());
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		UserDetails userDetails =
			 (UserDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	
		logger.info("USERNAME: " + userDetails.getUsername());
		for (GrantedAuthority authority : userDetails.getAuthorities()) {
			logger.info("Granted Authority: " + authority.getAuthority());
		}
		
		return;
	}
}
