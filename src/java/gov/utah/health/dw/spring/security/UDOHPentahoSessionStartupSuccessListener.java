package gov.utah.health.dw.spring.security;

import java.util.logging.Logger;

import org.pentaho.platform.api.engine.IPentahoSession;
import org.pentaho.platform.engine.core.system.PentahoSessionHolder;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.Ordered;
import org.springframework.security.authentication.event.AbstractAuthenticationEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.util.Assert;

public class UDOHPentahoSessionStartupSuccessListener implements
		ApplicationListener, Ordered {

	private static final Logger logger = Logger
			.getLogger(UDOHPentahoSessionStartupSuccessListener.class.getName());

	public int getOrder() {
		return 200;
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event instanceof AuthenticationSuccessEvent) {
		    System.out.println("received " + event.getClass().getSimpleName()); //$NON-NLS-1$
		    System.out.println("synchronizing current IPentahoSession with SecurityContext"); //$NON-NLS-1$
			try {
				Authentication authentication = ((AbstractAuthenticationEvent) event)
						.getAuthentication();
				IPentahoSession pentahoSession = PentahoSessionHolder
						.getSession();
				Assert.notNull(pentahoSession,
						"PentahoSessionHolder doesn't have a session");
				pentahoSession.setAuthenticated(authentication.getName());
			} catch (Exception e) {
				System.err.println(e.getLocalizedMessage());

			}
		}
	}
}
