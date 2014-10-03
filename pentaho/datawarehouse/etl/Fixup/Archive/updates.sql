set search_path = 'warehouse';

alter table fact_event add column dw_state_case_status_id integer;


CREATE INDEX idx_fe_dw_state_case_status_id
  ON warehouse.fact_event
  USING btree
  (dw_state_case_status_id);

CREATE INDEX idx_flt_day_care
  ON warehouse.fact_lab_test
  USING btree
  (day_care);

CREATE INDEX idx_flt_dw_collection_date_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_collection_date_id);

CREATE INDEX idx_flt_dw_disease_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_disease_id);

CREATE INDEX idx_flt_dw_fact_lab_test_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_fact_lab_test_id);

CREATE INDEX idx_flt_dw_junk_lab_test_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_junk_lab_test_id);

CREATE INDEX idx_flt_dw_lab_test_date_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_lab_test_date_id);

CREATE INDEX idx_flt_dw_organism_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_organism_id);

CREATE INDEX idx_flt_dw_person_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_person_id);

CREATE INDEX idx_flt_dw_primary_address_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_primary_address_id);

CREATE INDEX idx_flt_dw_secondary_address_id
  ON warehouse.fact_lab_test
  USING btree
  (dw_secondary_address_id);

CREATE INDEX idx_flt_food_handler
  ON warehouse.fact_lab_test
  USING btree
  (food_handler);

CREATE INDEX idx_flt_group_living
  ON warehouse.fact_lab_test
  USING btree
  (group_living);

CREATE INDEX idx_flt_health_care_worker
  ON warehouse.fact_lab_test
  USING btree
  (health_care_worker);

CREATE INDEX idx_flt_pregnancy_due_date
  ON warehouse.fact_lab_test
  USING btree
  (pregnancy_due_date);

CREATE INDEX idx_flt_risk_factors
  ON warehouse.fact_lab_test
  USING btree
  (risk_factors COLLATE pg_catalog."default");

