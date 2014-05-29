package gov.utah.health.avr2.spring.security;

import java.util.logging.Logger;

import org.pentaho.platform.api.engine.IPentahoSession;
import org.pentaho.platform.engine.core.system.PentahoSessionHolder;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.Ordered;
import org.springframework.security.Authentication;
import org.springframework.security.event.authentication.AbstractAuthenticationEvent;
import org.springframework.security.event.authentication.AuthenticationSuccessEvent;
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
			logger.info("received " + event.getClass().getSimpleName()); //$NON-NLS-1$
			logger.info("synchronizing current IPentahoSession with SecurityContext"); //$NON-NLS-1$
			try {
				Authentication authentication = ((AbstractAuthenticationEvent) event)
						.getAuthentication();
				IPentahoSession pentahoSession = PentahoSessionHolder
						.getSession();
				Assert.notNull(pentahoSession,
						"PentahoSessionHolder doesn't have a session");
				pentahoSession.setAuthenticated(authentication.getName());
			} catch (Exception e) {
				logger.warning(e.getLocalizedMessage());

			}
		}
	}
}
