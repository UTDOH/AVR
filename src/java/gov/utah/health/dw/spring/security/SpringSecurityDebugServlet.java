package gov.utah.health.dw.spring.security;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

public class SpringSecurityDebugServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(UDOHSSOAuthenticationFilter.class.getName());
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		UserDetails userDetails =
			 (UserDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	
		System.out.println("USERNAME: " + userDetails.getUsername());
		for (GrantedAuthority authority : userDetails.getAuthorities()) {
			System.out.println("Granted Authority: " + authority.getAuthority());
		}
		
		return;
	}
}
