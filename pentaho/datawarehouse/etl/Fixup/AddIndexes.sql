set search_path='warehouse';

alter table fact_event rename column dw_event_type to dw_event_type_id;

CREATE INDEX idx_fe_event_type
  ON warehouse.fact_event
  USING btree
  (dw_event_type_id);

CREATE INDEX idx_fe_src_deleted_at
  ON warehouse.fact_event
  USING btree
  (src_deleted_at);

CREATE INDEX idx_event_type
  ON warehouse.dim_event_type
  USING btree
  (dw_event_type_id);
