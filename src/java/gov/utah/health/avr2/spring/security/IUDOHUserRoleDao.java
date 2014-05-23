package gov.utah.health.avr2.spring.security;

import java.util.List;

public interface IUDOHUserRoleDao {
	public List<String> getUserJurisdictionsAsRoles(String uid);
}
