package gov.utah.health.dw.spring.security;

import java.util.List;
import java.util.logging.Logger;

import org.pentaho.platform.api.engine.security.userroledao.IUserRoleDao;
import org.pentaho.platform.api.mt.ITenant;
import org.pentaho.platform.api.mt.ITenantedPrincipleNameResolver;
import org.pentaho.platform.security.userroledao.service.UserRoleDaoUserRoleListService;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;


/**
 * @author developer
 *
 */
public abstract class UDOHUserRoleDaoUserRoleListService extends
		UserRoleDaoUserRoleListService {

	private static final Logger logger = Logger.getLogger(UDOHUserRoleDaoUserRoleListService.class.getName());
	
	private IUDOHUserRoleDao udohUserRoleDao;
	
	/**
	 * 
	 */
	public UDOHUserRoleDaoUserRoleListService() {
		super();
	}

	/**
	 * 
	 * @param userRoleDao
	 * @param userDetailsService
	 * @param usernamePrincipalResolver
	 * @param systemRoles
	 * @param extraRoles
	 * @param adminRole
	 */
	public UDOHUserRoleDaoUserRoleListService( IUserRoleDao userRoleDao, UserDetailsService userDetailsService,
		      ITenantedPrincipleNameResolver usernamePrincipalResolver, List<String> systemRoles, List<String> extraRoles,
		      final String adminRole, IUDOHUserRoleDao udohUserRoleDao) {
		super(userRoleDao, userDetailsService, usernamePrincipalResolver, systemRoles, extraRoles, adminRole);
		
		this.udohUserRoleDao = udohUserRoleDao;
	}
	
	@Override
	public List<String> getRolesForUser( ITenant tenant, String username ) throws UsernameNotFoundException, DataAccessException {
		List<String> roles = super.getRolesForUser(tenant, username);
		
		// TODO: Append Roles
		logger.info("Searching UDOH Roles for User: " + username);
		List<String> udohRoles = udohUserRoleDao.getUserJurisdictionsAsRoles(username);
		
		if (udohRoles != null && udohRoles.size() > 0) {
			logger.info("Found UDOH Roles: (count=" + udohRoles.size());
			udohRoles.addAll(udohRoles);
		}
		
		return roles;
	}
	
	@Override
	public List<String> getAllRoles(ITenant tenant) {
		logger.info("ENTERING getAllRoles(ITenant tenant) - tenant.name:" + tenant.getName() + ", tenant.id:" + tenant.getId());
		return super.getAllRoles(tenant);
	}
	
	@Override
	public List<String> getAllUsers() {
		logger.info("ENTERING getAllRoles(ITenant tenant)");
		return super.getAllUsers();
	}
}
