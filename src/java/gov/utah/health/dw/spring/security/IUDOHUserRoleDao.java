package gov.utah.health.dw.spring.security;

import java.util.List;

public interface IUDOHUserRoleDao {
	public List<String> getUserJurisdictionsAsRoles(String uid);
}
