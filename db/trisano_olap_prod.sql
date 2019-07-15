CREATE SCHEMA syndromic_olap;

CREATE TABLE syndromic_olap.dim_date ( 
	dw_date_id           integer  NOT NULL,
	dw_date_num_id       integer  ,
	hashcode             integer  ,
	src_date_val         date  ,
	date_short           char(12)  ,
	date_medium          char(16)  ,
	date_long            varchar(24)  ,
	date_full            varchar(32)  ,
	day_in_week          integer  ,
	day_in_month         integer  ,
	day_in_year          integer  ,
	is_first_day_in_month smallint  ,
	is_first_day_in_week smallint  ,
	is_last_day_in_month smallint  ,
	is_last_day_in_week  smallint  ,
	day_name             varchar(12)  ,
	day_abbreviation     char(3)  ,
	week_in_year         integer  ,
	week_in_month        integer  ,
	week_in_year_iso     integer  ,
	week_start_date      date  ,
	is_weekend           smallint  ,
	is_weekday           smallint  ,
	month_number         integer  ,
	month_name_val       varchar(12)  ,
	month_abbreviation   char(3)  ,
	month_abbreviation_year2 char(6)  ,
	year2                integer  ,
	year4                integer  ,
	year2_iso            integer  ,
	year4_iso            integer  ,
	quarter_number       integer  ,
	quarter_name         char(2)  ,
	quarter_year         char(7)  ,
	month_year           char(7)  ,
	week_year            char(7)  ,
	week_year_iso        char(7)  ,
	year_week_int        integer  ,
	current_week_cy      smallint  ,
	current_month_cy     smallint  ,
	last_week_cy         smallint  ,
	last_month_cy        smallint  ,
	current_week_ly      smallint  ,
	current_month_ly     smallint  ,
	last_week_ly         smallint  ,
	last_month_ly        smallint  ,
	ytd_cy_day           smallint  ,
	ytd_cy_week          smallint  ,
	ytd_cy_month         smallint  ,
	ytd_ly_day           smallint  ,
	ytd_ly_week          smallint  ,
	ytd_ly_month         smallint  ,
	current_year         smallint  ,
	last_year            smallint  ,
	day_sequence         integer  ,
	week_sequence        integer  ,
	month_sequence       integer  ,
	year_of_weekend_date integer  ,
	etl_load_date        timestamp  ,
	mmwr_week            integer DEFAULT 0 NOT NULL,
	mmwr_year            integer DEFAULT 0 NOT NULL,
	CONSTRAINT pk_dim_date UNIQUE ( dw_date_num_id ) ,
	CONSTRAINT pk_dim_date_0 PRIMARY KEY ( dw_date_id )
 );

CREATE INDEX idx_dw_dim_date_lookup_new ON syndromic_olap.dim_date ( hashcode );

COMMENT ON COLUMN syndromic_olap.dim_date.dw_date_id IS 'TK of the date dimension in the format YYYYMMDD';

COMMENT ON COLUMN syndromic_olap.dim_date.dw_date_num_id IS 'Alternate TK of the date dimension in the format YYYYMMDD';

COMMENT ON COLUMN syndromic_olap.dim_date.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN syndromic_olap.dim_date.src_date_val IS 'Source date value';

COMMENT ON COLUMN syndromic_olap.dim_date.date_short IS 'Short date';

COMMENT ON COLUMN syndromic_olap.dim_date.date_medium IS 'Medium date';

CREATE TABLE syndromic_olap.dim_mft ( 
	dw_mft_id            integer  NOT NULL,
	hashcode             integer  ,
	facility_uid         varchar(255)  ,
	connector            varchar(255)  ,
	application_name     varchar(255)  ,
	facility_name        varchar(255)  ,
	facility_id          varchar(255)  ,
	udoh_status          varchar(255)  ,
	hco                  varchar(255)  ,
	biosense_status      varchar(255)  ,
	latitude             numeric(11,7)  ,
	longitude            numeric(11,7)  ,
	c_biofacility_id     varchar(255)  ,
	etl_update_date      timestamp  ,
	mft_status           varchar(255)  ,
	CONSTRAINT pk_dim_mft PRIMARY KEY ( dw_mft_id )
 );

CREATE INDEX idx_dim_mft_facility_uid ON syndromic_olap.dim_mft ( facility_uid );

CREATE INDEX idx_dim_mft_hashcode ON syndromic_olap.dim_mft ( hashcode );

COMMENT ON TABLE syndromic_olap.dim_mft IS 'Medical facility dimension

TODO:
Get address from lookup table in syndromic schema - Eunice to provide';

COMMENT ON COLUMN syndromic_olap.dim_mft.mft_status IS 'onboarding, active, inactive, etc.. current state - qa_ss_processed_message includes this as well, but in the qa table, it is the state when the message was processed';

CREATE TABLE syndromic_olap.dim_patient_location ( 
	dw_patient_location_id integer  ,
	hashcode             integer  ,
	patient_zip          varchar(255)  ,
	patient_county       varchar(255)  ,
	patient_latitude     numeric(11,7)  ,
	patient_longitude    numeric(11,7)  ,
	CONSTRAINT pk_dim_patient_location UNIQUE ( dw_patient_location_id ) 
 );

COMMENT ON TABLE syndromic_olap.dim_patient_location IS 'TODO: move health district into this dimension - check on how to link these';

CREATE TABLE syndromic_olap.dim_rt_facility_visit_type ( 
	dw_rt_facility_visit_type_id integer  NOT NULL,
	hashcode             integer  ,
	concept_code         varchar(255)  ,
	concept_name         varchar(255)  ,
	preferred_concept_name varchar(255)  ,
	preferred_alternate_code varchar(255)  ,
	code_system_oid      varchar(255)  ,
	code_system_name     varchar(255)  ,
	code_system_code     varchar(255)  ,
	code_system_version  varchar(255)  ,
	hl7_table_0396_code  varchar(255)  ,
	value_set_version    varchar(255)  ,
	dw_version_effective_date_num_id integer  ,
	dw_version_expiration_date_num_id integer  ,
	status               varchar(255)  ,
	value_set_oid        varchar(255)  ,
	etl_update_date      timestamp  ,
	CONSTRAINT pk_dim_rt_age_unit_syndromic_surveillance_3 PRIMARY KEY ( dw_rt_facility_visit_type_id )
 );

COMMENT ON COLUMN syndromic_olap.dim_rt_facility_visit_type.dw_version_effective_date_num_id IS 'e.g. 20190430';

COMMENT ON COLUMN syndromic_olap.dim_rt_facility_visit_type.dw_version_expiration_date_num_id IS 'e.g. 20190430';

CREATE TABLE syndromic_olap.dim_time ( 
	dw_time_id           integer  ,
	hashcode             integer  ,
	time_val             char(5)  ,
	hour_of_day          integer  ,
	minute_of_hour       integer  ,
	CONSTRAINT pk_dim_time UNIQUE ( dw_time_id ) 
 );

COMMENT ON COLUMN syndromic_olap.dim_time.time_val IS 'HH:MM';

CREATE TABLE syndromic_olap.dim_trigger_event ( 
	dw_trigger_event_id  integer  ,
	hashcode             integer  ,
	src_trigger_event    varchar(255)  ,
	CONSTRAINT pk_dim_trigger_event UNIQUE ( dw_trigger_event_id ) 
 );

COMMENT ON TABLE syndromic_olap.dim_trigger_event IS 'derived dimension
based on ss_processed_message.trigger_event';

CREATE TABLE syndromic_olap.qa_ss_processed_message ( 
	src_id               integer  NOT NULL,
	src_ss_batched_messages_id integer  ,
	src_created_at       timestamp  ,
	mft_status           varchar(255)  ,
	dw_trigger_event_id  integer  ,
	admit_reason_description varchar(255)  ,
	dw_treating_mft_id   integer  ,
	dw_sending_mft_id    integer  ,
	src_admit_date_time  timestamp  ,
	dw_admit_date_num_id integer  ,
	dw_admit_time_id     integer  ,
	src_discharge_date_time timestamp  ,
	src_observation_date_time timestamp  ,
	src_death_date_time  timestamp  ,
	src_recorded_date_time timestamp  ,
	src_message_date_time timestamp  ,
	first_patient_id_present bool  ,
	visit_id             varchar(255)  ,
	patient_account_number varchar(255)  ,
	medical_record_number_present bool  ,
	administrative_sex   varchar(255)  ,
	dw_patient_location_id integer  ,
	src_procedure_date_time timestamp  ,
	dw_procedure_date_num_id integer  ,
	dw_procedure_time_id integer  ,
	triage_notes_present bool  ,
	age_reported         varchar(255)  ,
	age_reported_num     integer  ,
	medication_list      varchar(255)  ,
	dw_rt_facility_visit_type_id integer  ,
	src_ss_batched_messages_created_at timestamp  ,
	dw_ss_batched_messages_created_at_date_num_id integer  ,
	dw_ss_batched_message_created_at_time_id integer  ,
	dw_mft_id            integer  ,
	tf1_age_reported_v   integer  ,
	tf1_admit_reason_c   integer  ,
	tf_administrative_sex_v integer  ,
	biosense_status      varchar(255)  ,
	chief_complaints_text varchar(1024)  ,
	tf1_chiefcomplaint_v integer  ,
	tf1_first_patient_id_present_c integer  ,
	tf1_visit_id_c       integer  ,
	tf1_medical_record_number_present integer  ,
	tf1_futuredate_v     integer  ,
	tf1_trigger_event_v  integer  ,
	tf1_message_type_v   integer  ,
	tf2_admit_date_time_c date  ,
	tf1_discharge_date_time_c integer  ,
	tf1_admit_date_time_c integer  ,
	tf1_patient_death_date_time_c integer  ,
	tf1_recorded_date_time_c integer  ,
	tf1_message_date_time_c integer  ,
	tf1_procedure_date_time_c integer  ,
	CONSTRAINT idx_fact_ss_processed_message_32 UNIQUE ( src_id ) 
 );

CREATE INDEX idx_fact_ss_processed_message_1 ON syndromic_olap.qa_ss_processed_message ( dw_trigger_event_id );

CREATE INDEX idx_fact_ss_processed_message_3 ON syndromic_olap.qa_ss_processed_message ( dw_treating_mft_id );

CREATE INDEX idx_fact_ss_processed_message_4 ON syndromic_olap.qa_ss_processed_message ( dw_sending_mft_id );

CREATE INDEX idx_fact_ss_processed_message_10 ON syndromic_olap.qa_ss_processed_message ( dw_procedure_date_num_id );

CREATE INDEX idx_fact_ss_processed_message_16 ON syndromic_olap.qa_ss_processed_message ( dw_rt_facility_visit_type_id );

CREATE INDEX idx_fact_ss_processed_message_17 ON syndromic_olap.qa_ss_processed_message ( dw_ss_batched_messages_created_at_date_num_id );

CREATE INDEX idx_fact_ss_processed_message_19 ON syndromic_olap.qa_ss_processed_message ( dw_mft_id );

CREATE INDEX idx_fact_ss_processed_message_20 ON syndromic_olap.qa_ss_processed_message ( dw_patient_location_id );

CREATE INDEX idx_fact_ss_processed_message_28 ON syndromic_olap.qa_ss_processed_message ( dw_procedure_time_id );

CREATE INDEX idx_fact_ss_processed_message_29 ON syndromic_olap.qa_ss_processed_message ( dw_ss_batched_message_created_at_time_id );

CREATE INDEX idx_fact_ss_processed_message ON syndromic_olap.qa_ss_processed_message ( dw_admit_date_num_id );

CREATE INDEX idx_fact_ss_processed_message_0 ON syndromic_olap.qa_ss_processed_message ( dw_admit_time_id );

COMMENT ON TABLE syndromic_olap.qa_ss_processed_message IS 'TODO
X all dw_date_num_id fields need a dw_time_id
X gap analysis of any missing fields
X move patient_county and patienti_zip and lat/lon to a new dimension (dim_patient_location)

6/11/2019 - use src_ss_batched_messages_created_at as the partition key';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.src_created_at IS 'in the source table this field is likely a timstamp WITH timezone';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.mft_status IS 'onboarding, active, inactive, etc.. this remains static (point in time history)';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.age_reported_num IS 'if age_reported is numeric, that numeric value is set in this field';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.dw_mft_id IS 'ss_processed_message.facility_uid';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.tf1_age_reported_v IS 'is age_reported not null and one of rt_age_unit_syndromic_surveillance';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.tf1_admit_reason_c IS 'is admit_reason_description not null';

COMMENT ON COLUMN syndromic_olap.qa_ss_processed_message.tf_administrative_sex_v IS 'is administrative_sex not null and one of syndromic.rt_gender_syndromic_surveillance';

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_1 FOREIGN KEY ( dw_trigger_event_id ) REFERENCES syndromic_olap.dim_trigger_event( dw_trigger_event_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_3 FOREIGN KEY ( dw_treating_mft_id ) REFERENCES syndromic_olap.dim_mft( dw_mft_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_4 FOREIGN KEY ( dw_sending_mft_id ) REFERENCES syndromic_olap.dim_mft( dw_mft_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_16 FOREIGN KEY ( dw_rt_facility_visit_type_id ) REFERENCES syndromic_olap.dim_rt_facility_visit_type( dw_rt_facility_visit_type_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_17 FOREIGN KEY ( dw_ss_batched_messages_created_at_date_num_id ) REFERENCES syndromic_olap.dim_date( dw_date_num_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_19 FOREIGN KEY ( dw_mft_id ) REFERENCES syndromic_olap.dim_mft( dw_mft_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_20 FOREIGN KEY ( dw_patient_location_id ) REFERENCES syndromic_olap.dim_patient_location( dw_patient_location_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_29 FOREIGN KEY ( dw_ss_batched_message_created_at_time_id ) REFERENCES syndromic_olap.dim_time( dw_time_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message FOREIGN KEY ( dw_admit_date_num_id ) REFERENCES syndromic_olap.dim_date( dw_date_id );

ALTER TABLE syndromic_olap.qa_ss_processed_message ADD CONSTRAINT fk_fact_ss_processed_message_0 FOREIGN KEY ( dw_admit_time_id ) REFERENCES syndromic_olap.dim_time( dw_time_id );

