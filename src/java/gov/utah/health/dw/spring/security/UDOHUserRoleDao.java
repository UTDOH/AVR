package gov.utah.health.dw.spring.security;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.jcr.NamespaceException;
import javax.sql.DataSource;

import org.pentaho.platform.api.engine.security.userroledao.IPentahoRole;
import org.pentaho.platform.api.engine.security.userroledao.IPentahoUser;
import org.pentaho.platform.api.engine.security.userroledao.IUserRoleDao;
import org.pentaho.platform.api.engine.security.userroledao.UncategorizedUserRoleDaoException;
import org.pentaho.platform.api.mt.ITenant;
import org.pentaho.platform.api.mt.ITenantedPrincipleNameResolver;
import org.pentaho.platform.api.repository2.unified.IRepositoryDefaultAclHandler;
import org.pentaho.platform.repository2.unified.IRepositoryFileAclDao;
import org.pentaho.platform.repository2.unified.IRepositoryFileDao;
import org.pentaho.platform.repository2.unified.jcr.ILockHelper;
import org.pentaho.platform.repository2.unified.jcr.IPathConversionHelper;
import org.pentaho.platform.security.userroledao.jackrabbit.JcrUserRoleDao;
import org.springframework.extensions.jcr.JcrTemplate;
import org.springframework.security.core.userdetails.UserCache;

public class UDOHUserRoleDao extends JcrUserRoleDao implements IUserRoleDao {
	
	private static final Logger logger = Logger.getLogger(UDOHUserRoleDao.class.getName());
	
	private static final String BLANK = "";
	
	/**
	 * The JNDI database connection 
	 */
	private DataSource trisanoDataSource;
	
	private String jurisdictionsByUserQuery = BLANK;
	
	private String sensitiveRoleCountQuery = BLANK;
	
	
	public  UDOHUserRoleDao(JcrTemplate adminJcrTemplate, ITenantedPrincipleNameResolver userNameUtils,
			       ITenantedPrincipleNameResolver roleNameUtils, String authenticatedRoleName, String tenantAdminRoleName,
			       String repositoryAdminUsername, IRepositoryFileAclDao repositoryFileAclDao, IRepositoryFileDao repositoryFileDao, IPathConversionHelper pathConversionHelper,
			       ILockHelper  lockHelper, IRepositoryDefaultAclHandler  defaultAclHandler, final List<String> systemRoles, final List<String> extraRoles, UserCache userCache,
			       DataSource trisanoDataSource) throws NamespaceException {
		
		super(adminJcrTemplate, userNameUtils, roleNameUtils, authenticatedRoleName, tenantAdminRoleName, repositoryAdminUsername, repositoryFileAclDao, repositoryFileDao, pathConversionHelper, lockHelper, defaultAclHandler, systemRoles, extraRoles, userCache);
		this.trisanoDataSource = trisanoDataSource;
	}
	
	@Override
	public List<IPentahoRole> getUserRoles(ITenant tenant, String username)
			throws UncategorizedUserRoleDaoException {
		System.out.println(">>>>>>>>>>>Entering getUserRoles() - username: " + username);
		
		// TODO Auto-generated method stub
		List<IPentahoRole> pentahoRoles = super.getUserRoles(tenant, username);
		if (tenant != null) {
			System.out.println("username: " + username + ", tenant.id=" + tenant.getId() + ", tenant.name=" + tenant.getName());
		}
		String parsedUserName = username;
		int usernameIndex = 0;
		if (username != null) {
			usernameIndex = username.indexOf("-");
			if (usernameIndex != -1) {
				parsedUserName = username.substring(0, username.indexOf("-"));
			} 
		}
		
		List<IPentahoRole> avrRoles = convertRolesToIPentahoRoles(tenant, getUDOHTrisanoRoles(parsedUserName));
		pentahoRoles.addAll(avrRoles);
		debugRoles(username, pentahoRoles);
		
		return pentahoRoles;
	}
	
	private void debugRoles(String username, List<IPentahoRole> roles) {
		System.out.println("Showing roles for username: " + username);
		if (roles != null) {
			for (IPentahoRole role : roles) {
				System.out.println("ROLE: " + role.getName());
				
			}
		}
	}
	
//	@Override
//	public IPentahoRole getRole(ITenant arg0, String arg1)
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getRole(ITenant, String)");
//		return super.getRole(arg0, arg1);
//	}
//	
//	@Override
//	public List<IPentahoUser> getRoleMembers(ITenant arg0, String arg1)
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getRoleMembers(ITenant arg0, String arg1)");
//		return super.getRoleMembers(arg0, arg1);
//	}
//	
//	@Override
//	public List<IPentahoUser> getRoleMembers(Session arg0, ITenant arg1,
//			String arg2) throws RepositoryException {
//		System.out.println("ENTERING getRoleMembers(Session arg0, ITenant arg1, String arg2)");
//		return super.getRoleMembers(arg0, arg1, arg2);
//	}
//	
//	@Override
//	public List<IPentahoRole> getRoles(Session arg0, ITenant arg1, boolean arg2)
//			throws RepositoryException {
//		System.out.println("ENTERING getRoles(Session arg0, ITenant arg1, boolean arg2)");
//		return super.getRoles(arg0, arg1, arg2);
//	}
//	
//	@Override
//	public List<IPentahoRole> getRoles(Session session)
//			throws RepositoryException {
//		System.out.println("ENTERING getRoles(Session session)");
//		return super.getRoles(session);
//	}
//	
//	@Override
//	public IPentahoRole getRole(Session session, ITenant tenant, String name)
//			throws RepositoryException {
//		System.out.println("ENTERING getRole(Session session, ITenant tenant, String name)");
//		return super.getRole(session, tenant, name);
//	}
//	
//	@Override
//	public List<IPentahoRole> getUserRoles(Session arg0, ITenant arg1,
//			String arg2) throws RepositoryException {
//		System.out.println("ENTERING getUserRoles(Session arg0, ITenant arg1, String arg2)");
//		return super.getUserRoles(arg0, arg1, arg2);
//	}
//	
//	@Override
//	public List<IPentahoRole> getRoles(ITenant arg0, boolean arg1)
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getRoles(ITenant arg0, boolean arg1)");
//		return super.getRoles(arg0, arg1);
//	}
//	
//	@Override
//	public List<IPentahoRole> getRoles()
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getRoles()");
//		return super.getRoles();
//	}
//	
//	@Override
//	public List<IPentahoRole> getRoles(Session session, ITenant tenant)
//			throws RepositoryException, NamespaceException {
//		System.out.println("ENTERING getRoles(Session session, ITenant tenant)");
//		return super.getRoles(session, tenant);
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers()
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getUsers()");
//		return super.getUsers();
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers(ITenant tenant)
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getUsers(ITenant tenant)");
//		return super.getUsers(tenant);
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers(ITenant arg0, boolean arg1)
//			throws UncategorizedUserRoleDaoException {
//		System.out.println("ENTERING getUsers(ITenant arg0, boolean arg1)");
//		return super.getUsers(arg0, arg1);
//	}
//	
//	@Override
//	public IPentahoUser getUser(Session session, ITenant tenant, String name)
//			throws RepositoryException {
//		System.out.println("ENTERING getUser(Session session, ITenant tenant, String name)");
//		return super.getUser(session, tenant, name);
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers(Session arg0, ITenant arg1, boolean arg2)
//			throws RepositoryException {
//		System.out.println("ENTERING getUsers(Session arg0, ITenant arg1, boolean arg2)");
//		return super.getUsers(arg0, arg1, arg2);
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers(Session session)
//			throws RepositoryException {
//		System.out.println("getUsers(Session session)");
//		return super.getUsers(session);
//	}
//	
//	@Override
//	public List<IPentahoUser> getUsers(Session session, ITenant tenant)
//			throws RepositoryException {
//		System.out.println("ENTERING getUsers(Session session, ITenant tenant)");
//		return super.getUsers(session, tenant);
//	}
	
	public List<IPentahoRole> convertRolesToIPentahoRoles(final ITenant tenant, List<String> roles) {
		List<IPentahoRole> pentahoRoles = new ArrayList<IPentahoRole>();
		
		if (roles != null) {
			IPentahoRole pentahoRole = null;
			for(final String role : roles) {
				pentahoRole = new IPentahoRole() {
					private static final long serialVersionUID = 1L;
					private String roleName = role;
					public String getDescription() {
						return roleName;
					}
					
					public void setDescription(String roleName) {
						this.roleName = roleName;
					}
					
					public ITenant getTenant() {
						return tenant;
					}
					
					public String getName() {
						// TODO Auto-generated method stub
						return role;
					}
				};
				
				pentahoRoles.add(pentahoRole);
			}
		}
		
		return pentahoRoles;
	}
	
	/**
	 * Get the <code>GrantedAuthority</code> objects for each trisano jurisdiction of the logged in user
	 * 
	 * @param uid
	 * 			The Trisano user UID to lookup
	 * @return
	 * 			The List of <code>GrantedAuthority</code> objects, one for each jurisdiction
	 */
	public List<String> getUDOHTrisanoRoles(String uid) {
		List<String> udohJurisdictionRoles = new ArrayList<String>();
		Connection c = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean loadUserRoles = true;
		
		if (loadUserRoles) {
			try {
				c = trisanoDataSource.getConnection();
				ps = c.prepareStatement(jurisdictionsByUserQuery);
				ps.setString(1, uid);
				
				rs = ps.executeQuery();
				while(rs.next()) {
					final String authority = rs.getString(1);
					udohJurisdictionRoles.add("JURISDICTION-" + authority);
				}
				
				ps.close();
				
				ps = c.prepareStatement(sensitiveRoleCountQuery);
				ps.setString(1, uid);
				rs = ps.executeQuery();
				
				if(rs.next()) {
					int secureDiseaseRoleCount = rs.getInt(1);
					if (secureDiseaseRoleCount > 0) {
						udohJurisdictionRoles.add("DISEASE-SECURE");
					} else {
						udohJurisdictionRoles.add("DISEASE-NONSECURE");
					}
				}
				
			} catch (SQLException e) {
				System.err.println("Error building Trisano user roles: " + e.getMessage());
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
		}
		
		return udohJurisdictionRoles;
	}
	
	@Override
	public List<IPentahoRole> getRoles(ITenant tenant)
			throws UncategorizedUserRoleDaoException {
		if (tenant != null) {
			System.out.println("ENTERING: getRoles(), tenant.name=" + tenant.getName() + ", tenant.id=" + tenant.getId());
		} else {
			System.out.println("ENTERING: getRoles() - null tenant");
		}
		return super.getRoles(tenant);
	}
	
	@Override
	public IPentahoUser getUser(ITenant tenant, String arg1)
			throws UncategorizedUserRoleDaoException {
		if (tenant != null) {
			System.out.println("ENTERING getUser() - tenant.name=" + tenant.getName() + ", tenant.id=" + tenant.getId());
		} else {
			System.out.println("ENTERING getUser() - null tenant");
		}
		return super.getUser(tenant, arg1);
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

	public String getSensitiveRoleCountQuery() {
		return sensitiveRoleCountQuery;
	}

	public void setSensitiveRoleCountQuery(String sensitiveRoleCountQuery) {
		this.sensitiveRoleCountQuery = sensitiveRoleCountQuery;
	}
}
