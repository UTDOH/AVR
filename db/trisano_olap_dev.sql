CREATE SCHEMA warehouse;

CREATE SEQUENCE warehouse.dim_diagnostic_facilites_dim_diagnostic_facilities_seq START WITH 1;

CREATE SEQUENCE warehouse.dim_junk_lab_test_seq START WITH 1;

CREATE SEQUENCE warehouse.dim_organism_dw_organism_id_seq START WITH 1;

CREATE SEQUENCE warehouse.dim_organism_seq START WITH 1;

CREATE SEQUENCE warehouse.dw_dim_location_dw_dim_location_id_seq START WITH 1;

CREATE SEQUENCE warehouse.fact_lab_test_seq START WITH 1;

CREATE TABLE warehouse.deprecated_fact_disease_event ( 
	dw_disease_id        integer  ,
	dw_location_id       integer  ,
	dw_diagnosed_date_id integer  ,
	dw_onset_date_id     integer  ,
	dw_jurisdiction_id   integer  ,
	src_event_id         integer  
 );

COMMENT ON COLUMN warehouse.deprecated_fact_disease_event.dw_jurisdiction_id IS 'TK of the dim_jurisdction of this disease event.';

COMMENT ON COLUMN warehouse.deprecated_fact_disease_event.src_event_id IS 'The OLTP src_event_id (also links to fact_event.src_event_id)';

CREATE TABLE warehouse.dim_address ( 
	dw_address_id        bigint  NOT NULL,
	hashcode             bigint  ,
	src_address_id       integer  ,
	location_id          integer  ,
	county_id            integer  ,
	county               varchar(100)  ,
	state_id             integer  ,
	state                varchar(100)  ,
	street_number        varchar(10)  ,
	street_name          varchar(250)  ,
	unit_number          varchar(10)  ,
	postal_code          varchar(10)  ,
	created_at           timestamp  ,
	updated_at           timestamp  ,
	city                 varchar(255)  ,
	entity_id            integer  ,
	entity_location_type_id integer  ,
	event_id             integer  ,
	longitude            numeric(15,6)  ,
	latitude             numeric(15,6)  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_addresses PRIMARY KEY ( dw_address_id )
 );

CREATE INDEX idx_dim_addresses_lookup ON warehouse.dim_address ( src_address_id );

CREATE INDEX idx_dim_address_lookup2 ON warehouse.dim_address ( hashcode );

COMMENT ON COLUMN warehouse.dim_address.dw_address_id IS 'Technical key of the address dimension';

COMMENT ON COLUMN warehouse.dim_address.hashcode IS 'The type I hashcode value';

COMMENT ON COLUMN warehouse.dim_address.src_address_id IS 'Source address id (OLTP)';

COMMENT ON COLUMN warehouse.dim_address.etl_load_date IS 'The timestamp of when this dimension record was last updated.';

CREATE TABLE warehouse.dim_date ( 
	dw_date_id           integer  NOT NULL,
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
	CONSTRAINT pk_dw_dim_date PRIMARY KEY ( dw_date_id )
 );

CREATE INDEX idx_dw_dim_date_lookup ON warehouse.dim_date ( hashcode );

COMMENT ON TABLE warehouse.dim_date IS 'Date dimension';

COMMENT ON COLUMN warehouse.dim_date.dw_date_id IS 'Technical key of the date dimension';

COMMENT ON COLUMN warehouse.dim_date.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_date.src_date_val IS 'Source date value';

COMMENT ON COLUMN warehouse.dim_date.date_short IS 'Short date';

COMMENT ON COLUMN warehouse.dim_date.date_medium IS 'Medium date';

COMMENT ON COLUMN warehouse.dim_date.date_long IS 'Long form date';

COMMENT ON COLUMN warehouse.dim_date.date_full IS 'Full form date';

COMMENT ON COLUMN warehouse.dim_date.day_in_week IS 'day of the week';

COMMENT ON COLUMN warehouse.dim_date.day_in_month IS 'Day number within the month';

COMMENT ON COLUMN warehouse.dim_date.day_in_year IS 'Day number within the year';

COMMENT ON COLUMN warehouse.dim_date.is_first_day_in_month IS 'Flag indicating whether the date is the first day in the month';

COMMENT ON COLUMN warehouse.dim_date.is_first_day_in_week IS 'Flag indicating whether the date is the first day in the week.';

COMMENT ON COLUMN warehouse.dim_date.is_last_day_in_month IS 'Flag indicating whether the date is the last day in the month.';

COMMENT ON COLUMN warehouse.dim_date.is_last_day_in_week IS 'Flag indicating whether the date is the last day of the week';

COMMENT ON COLUMN warehouse.dim_date.day_name IS 'textual name of the day of week';

COMMENT ON COLUMN warehouse.dim_date.day_abbreviation IS 'Abbreviated day of week';

COMMENT ON COLUMN warehouse.dim_date.week_in_year IS 'Numeric week of the year';

COMMENT ON COLUMN warehouse.dim_date.week_in_month IS 'Week number within the month.';

COMMENT ON COLUMN warehouse.dim_date.week_in_year_iso IS 'ISO standard week in year';

COMMENT ON COLUMN warehouse.dim_date.week_start_date IS 'The date representing the first day of the week.';

COMMENT ON COLUMN warehouse.dim_date.is_weekend IS 'Flag indicating wheter or not the day Is a Saturday or Sunday?';

COMMENT ON COLUMN warehouse.dim_date.is_weekday IS 'Flag indicating whether or not the date is a weekday';

COMMENT ON COLUMN warehouse.dim_date.month_number IS 'Month number (1..12)';

COMMENT ON COLUMN warehouse.dim_date.month_name_val IS 'Name of the month';

COMMENT ON COLUMN warehouse.dim_date.month_abbreviation IS 'Abbreviated month name';

COMMENT ON COLUMN warehouse.dim_date.month_abbreviation_year2 IS 'Month abbreviation with digit year';

COMMENT ON COLUMN warehouse.dim_date.year2 IS 'Two digit year';

COMMENT ON COLUMN warehouse.dim_date.year4 IS 'Four digit year';

COMMENT ON COLUMN warehouse.dim_date.year2_iso IS 'ISO two digit year';

COMMENT ON COLUMN warehouse.dim_date.year4_iso IS 'ISO four digit year';

COMMENT ON COLUMN warehouse.dim_date.quarter_number IS 'Numeric representation of the quarter (1..4)';

COMMENT ON COLUMN warehouse.dim_date.quarter_name IS 'Name of the quarter (Q1..Q4)';

COMMENT ON COLUMN warehouse.dim_date.quarter_year IS 'Quarter name + year';

COMMENT ON COLUMN warehouse.dim_date.month_year IS 'Month number - year4';

COMMENT ON COLUMN warehouse.dim_date.week_year IS 'Week number - year4';

COMMENT ON COLUMN warehouse.dim_date.week_year_iso IS 'week number - year4 ISO standard';

COMMENT ON COLUMN warehouse.dim_date.year_week_int IS 'Year4 and week number as numeric value for sorting and comparison';

COMMENT ON COLUMN warehouse.dim_date.current_week_cy IS 'Is this the current week of the current year';

COMMENT ON COLUMN warehouse.dim_date.current_month_cy IS 'Is this the current month of the current year';

COMMENT ON COLUMN warehouse.dim_date.last_week_cy IS 'Is this the previous week of the current year';

COMMENT ON COLUMN warehouse.dim_date.last_month_cy IS 'Flag indicating whether this date in the previous month of the current year';

COMMENT ON COLUMN warehouse.dim_date.current_week_ly IS 'Is this date in the previous year, but the same week as the current week?';

COMMENT ON COLUMN warehouse.dim_date.current_month_ly IS 'Is this date in the previous year, but the same month of the current year?';

COMMENT ON COLUMN warehouse.dim_date.last_week_ly IS 'Is this date in the previous week the year prior?';

COMMENT ON COLUMN warehouse.dim_date.last_month_ly IS 'Is this date in the previous month the year prior';

COMMENT ON COLUMN warehouse.dim_date.ytd_cy_day IS 'Is the day portion of the date in the current year?';

COMMENT ON COLUMN warehouse.dim_date.ytd_cy_week IS 'Is the week portion of the date in the current year?';

COMMENT ON COLUMN warehouse.dim_date.ytd_cy_month IS 'Is the month of the date in the current year?';

COMMENT ON COLUMN warehouse.dim_date.ytd_ly_day IS 'Is this day part of the year to date last year (for current year / previous YTD comparison calculations)';

COMMENT ON COLUMN warehouse.dim_date.ytd_ly_week IS 'Is the date in the week last year which spilled into this year?';

COMMENT ON COLUMN warehouse.dim_date.ytd_ly_month IS 'Is this month part of the year to date last year (for current year / previous YTD comparison calculations)';

COMMENT ON COLUMN warehouse.dim_date.current_year IS 'Is the date in the current year?';

COMMENT ON COLUMN warehouse.dim_date.last_year IS 'Is the date in the previous year?';

COMMENT ON COLUMN warehouse.dim_date.day_sequence IS 'How many days back is this day from the current day?';

COMMENT ON COLUMN warehouse.dim_date.week_sequence IS 'How many weeks back from the current week is the week this date is in?';

COMMENT ON COLUMN warehouse.dim_date.month_sequence IS 'How many monts back from the current month is the month this date is in?';

COMMENT ON COLUMN warehouse.dim_date.year_of_weekend_date IS 'What year does the last day of the week fall in?';

COMMENT ON COLUMN warehouse.dim_date.etl_load_date IS 'The date this dimension record was loaded into the data warehouse.';

CREATE TABLE warehouse.dim_diagnostic_facility ( 
	dw_diagnostic_facility_id bigserial  NOT NULL,
	hashcode             integer  ,
	src_event_id         integer  ,
	src_entity_id        integer  ,
	diagnostic_facility  varchar(255)  ,
	ptype                text  ,
	county_id            integer  ,
	county               varchar(100)  ,
	state_id             integer  ,
	state                varchar(100)  ,
	street_name          varchar(250)  ,
	unit_number          varchar(10)  ,
	postal_code          varchar(10)  ,
	a_created_at         timestamp  ,
	a_updated_at         timestamp  ,
	city                 varchar(255)  ,
	longitude            numeric(15,6)  ,
	latitude             numeric(15,6)  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_diagnostic_facility PRIMARY KEY ( dw_diagnostic_facility_id )
 );

CREATE INDEX idx_dim_diagnostic_facility_lookup ON warehouse.dim_diagnostic_facility ( hashcode );

COMMENT ON COLUMN warehouse.dim_diagnostic_facility.dw_diagnostic_facility_id IS 'Diagnostic facility technical key';

COMMENT ON COLUMN warehouse.dim_diagnostic_facility.src_event_id IS 'OLTP source event id';

COMMENT ON COLUMN warehouse.dim_diagnostic_facility.src_entity_id IS 'OLTP source entity ID';

COMMENT ON COLUMN warehouse.dim_diagnostic_facility.diagnostic_facility IS 'Name of the diagnostic facility';

COMMENT ON COLUMN warehouse.dim_diagnostic_facility.etl_load_date IS 'The timestamp of when this diagnostic facility dim record was last updated.';

CREATE TABLE warehouse.dim_disease ( 
	dw_disease_id        integer  NOT NULL,
	hashcode             bigint  ,
	src_disease_id       integer  ,
	disease_name         varchar(100)  ,
	contact_lead_in      text  ,
	place_lead_in        text  ,
	treatment_lead_in    text  ,
	active               bool  ,
	cdc_code             varchar(255)  ,
	sensitive            bool  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dw_dim_disease PRIMARY KEY ( dw_disease_id )
 );

CREATE INDEX idx_dw_dim_disease_lookup ON warehouse.dim_disease ( hashcode );

COMMENT ON TABLE warehouse.dim_disease IS 'Disease dimension';

COMMENT ON COLUMN warehouse.dim_disease.dw_disease_id IS 'Technical key of the disease dimension.';

COMMENT ON COLUMN warehouse.dim_disease.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_disease.src_disease_id IS 'Source OLTP disease_id';

COMMENT ON COLUMN warehouse.dim_disease.disease_name IS 'Name of the disease';

COMMENT ON COLUMN warehouse.dim_disease.contact_lead_in IS 'Contact lead in value';

COMMENT ON COLUMN warehouse.dim_disease.place_lead_in IS 'Place Lead In value';

COMMENT ON COLUMN warehouse.dim_disease.treatment_lead_in IS 'Treatment lead in value';

COMMENT ON COLUMN warehouse.dim_disease.active IS 'active flag';

COMMENT ON COLUMN warehouse.dim_disease.cdc_code IS 'CDC code value';

COMMENT ON COLUMN warehouse.dim_disease.sensitive IS 'Is this disease termed a sensitive disease';

COMMENT ON COLUMN warehouse.dim_disease.etl_load_date IS 'last etl load date of this disease record.';

CREATE TABLE warehouse.dim_ethnicity ( 
	dw_ethnicity_id      integer  NOT NULL,
	hashcode             integer  ,
	src_ethnicity_id     integer  ,
	code_name            varchar(50)  ,
	the_code             varchar(20)  ,
	code_description     varchar(100)  ,
	src_created_at       timestamp  ,
	src_modified_at      timestamp  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dw_dim_ethnicity PRIMARY KEY ( dw_ethnicity_id )
 );

CREATE INDEX idx_dw_dim_ethnicity_lookup ON warehouse.dim_ethnicity ( hashcode );

COMMENT ON COLUMN warehouse.dim_ethnicity.dw_ethnicity_id IS 'The data warehouse technical key for ethnicity';

COMMENT ON COLUMN warehouse.dim_ethnicity.hashcode IS 'The type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_ethnicity.src_ethnicity_id IS 'the OTLP ethnicity ID (external_code)';

COMMENT ON COLUMN warehouse.dim_ethnicity.code_name IS 'The code name of the ethnicity';

COMMENT ON COLUMN warehouse.dim_ethnicity.the_code IS 'The code value';

COMMENT ON COLUMN warehouse.dim_ethnicity.code_description IS 'The code description';

COMMENT ON COLUMN warehouse.dim_ethnicity.src_created_at IS 'Source created timestamp';

COMMENT ON COLUMN warehouse.dim_ethnicity.src_modified_at IS 'Source modified time';

COMMENT ON COLUMN warehouse.dim_ethnicity.etl_load_date IS 'last etl load date of this ethnicity record.';

CREATE TABLE warehouse.dim_external_code ( 
	dw_external_code_id  integer  ,
	hashcode             integer  ,
	src_external_code_id integer  ,
	code_description     varchar(100)  ,
	etl_load_date        timestamp  
 );

COMMENT ON COLUMN warehouse.dim_external_code.dw_external_code_id IS 'The dim_external_code TK';

COMMENT ON COLUMN warehouse.dim_external_code.hashcode IS 'The dim_external_code hashcode';

COMMENT ON COLUMN warehouse.dim_external_code.src_external_code_id IS 'The OLTP external code ID';

COMMENT ON COLUMN warehouse.dim_external_code.code_description IS 'The external code description';

COMMENT ON COLUMN warehouse.dim_external_code.etl_load_date IS 'The date / time this dim_external_code record was loaded';

CREATE TABLE warehouse.dim_investigator ( 
	dw_investigator_id   integer  NOT NULL,
	hashcode             integer  ,
	src_investigator_id  integer  ,
	investigator_name    text  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_investigator PRIMARY KEY ( dw_investigator_id )
 );

CREATE INDEX idx_dim_investigator ON warehouse.dim_investigator ( hashcode );

COMMENT ON TABLE warehouse.dim_investigator IS 'The investigator dimension';

COMMENT ON COLUMN warehouse.dim_investigator.dw_investigator_id IS 'The OLAP TK of the investigator dimension';

COMMENT ON COLUMN warehouse.dim_investigator.hashcode IS 'The hashcode of the investigator dimension';

COMMENT ON COLUMN warehouse.dim_investigator.src_investigator_id IS 'The OLTP id of the investigator person';

COMMENT ON COLUMN warehouse.dim_investigator.investigator_name IS 'The name of the investigator';

COMMENT ON COLUMN warehouse.dim_investigator.etl_load_date IS 'The timestamp of when this investigator dim record was last updated.';

CREATE TABLE warehouse.dim_junk_lab_test ( 
	dw_junk_lab_test_id  serial  NOT NULL,
	lab_test_result_code varchar(255)  ,
	lab_test_result_description varchar(255)  ,
	lab_test_status_code varchar(255)  ,
	lab_test_status_description varchar(255)  ,
	src_lab_test_result_id integer  ,
	src_lab_test_status_id integer  ,
	src_lab_test_type_id integer  ,
	test_name            varchar(255)  ,
	CONSTRAINT dim_junk_lab_test_pkey PRIMARY KEY ( dw_junk_lab_test_id )
 );

CREATE TABLE warehouse.dim_junk_status_type ( 
	dw_junk_status_type_id integer  NOT NULL,
	hashcode             integer  ,
	event_type           varchar(255)  ,
	contact_disposition_description varchar(100)  ,
	contact_type_description varchar(100)  ,
	src_state_case_status_id integer  ,
	state_case_status    varchar(50)  ,
	CONSTRAINT pk_dim_junk_status_type PRIMARY KEY ( dw_junk_status_type_id )
 );

CREATE INDEX idx_dim_junk_status_type ON warehouse.dim_junk_status_type ( hashcode );

COMMENT ON TABLE warehouse.dim_junk_status_type IS 'Junk dimension of status codes and types';

COMMENT ON COLUMN warehouse.dim_junk_status_type.dw_junk_status_type_id IS 'TK of the junk status type dmension';

COMMENT ON COLUMN warehouse.dim_junk_status_type.hashcode IS 'Type 1 dimension hashcode';

COMMENT ON COLUMN warehouse.dim_junk_status_type.event_type IS 'The event type value';

COMMENT ON COLUMN warehouse.dim_junk_status_type.contact_disposition_description IS 'The contact disposition text';

COMMENT ON COLUMN warehouse.dim_junk_status_type.contact_type_description IS 'The description of the contact type.';

COMMENT ON COLUMN warehouse.dim_junk_status_type.src_state_case_status_id IS 'The OLTP state case status id';

COMMENT ON COLUMN warehouse.dim_junk_status_type.state_case_status IS 'The text description of the state case status';

CREATE TABLE warehouse.dim_jurisdiction ( 
	dw_jurisdiction_id   integer  NOT NULL,
	hashcode             bigint  ,
	src_places_id        integer  ,
	src_entity_id        integer  ,
	name                 varchar(255)  ,
	short_name           varchar(255)  ,
	is_primary           bool  ,
	src_created_at       timestamp  ,
	src_modified_at      timestamp  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_jurisdiction PRIMARY KEY ( dw_jurisdiction_id )
 );

CREATE INDEX idx_dw_dim_jurisdiction_lookup ON warehouse.dim_jurisdiction ( hashcode );

COMMENT ON TABLE warehouse.dim_jurisdiction IS 'Jurisdiction dimension';

COMMENT ON COLUMN warehouse.dim_jurisdiction.dw_jurisdiction_id IS 'Technical key of the jurisdiction dimension.';

COMMENT ON COLUMN warehouse.dim_jurisdiction.hashcode IS 'Type I dimension hash code';

COMMENT ON COLUMN warehouse.dim_jurisdiction.src_places_id IS 'OLTP trisano.places.places_id';

COMMENT ON COLUMN warehouse.dim_jurisdiction.src_entity_id IS 'OLTP - trisano.entities.entity_id';

COMMENT ON COLUMN warehouse.dim_jurisdiction.name IS 'Name of the jurisdiction';

COMMENT ON COLUMN warehouse.dim_jurisdiction.short_name IS 'Shortened name of the jurisdiction.';

COMMENT ON COLUMN warehouse.dim_jurisdiction.is_primary IS 'flag indicating whether or not this is a primary jurisdiction';

COMMENT ON COLUMN warehouse.dim_jurisdiction.src_created_at IS 'Source created time';

COMMENT ON COLUMN warehouse.dim_jurisdiction.src_modified_at IS 'Source modified timestamp';

COMMENT ON COLUMN warehouse.dim_jurisdiction.etl_load_date IS 'The load date of this jurisdiction record.';

CREATE TABLE warehouse.dim_language ( 
	dw_language_id       integer  NOT NULL,
	hashcode             integer  ,
	src_language_id      integer  ,
	code_name            varchar(50)  ,
	the_code             varchar(20)  ,
	code_description     varchar(100)  ,
	src_created_at       timestamp  ,
	src_modified_at      timestamp  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_language PRIMARY KEY ( dw_language_id )
 );

CREATE INDEX idx_dw_dim_language_lookup ON warehouse.dim_language ( hashcode );

COMMENT ON COLUMN warehouse.dim_language.dw_language_id IS 'The data warehouse technical key for language';

COMMENT ON COLUMN warehouse.dim_language.hashcode IS 'The type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_language.src_language_id IS 'the OTLP language ID (external_code)';

COMMENT ON COLUMN warehouse.dim_language.code_name IS 'The code name of the ethnicity';

COMMENT ON COLUMN warehouse.dim_language.the_code IS 'The code value';

COMMENT ON COLUMN warehouse.dim_language.code_description IS 'The code description';

COMMENT ON COLUMN warehouse.dim_language.src_created_at IS 'Source created timestamp';

COMMENT ON COLUMN warehouse.dim_language.src_modified_at IS 'Source modified time';

COMMENT ON COLUMN warehouse.dim_language.etl_load_date IS 'The date / time the language dimension record was created.';

CREATE TABLE warehouse.dim_location ( 
	dw_location_id       integer  NOT NULL,
	hashcode             integer  ,
	src_location_id      integer  ,
	county_id            integer  ,
	county               varchar(100)  ,
	state_id             integer  ,
	state                varchar(100)  ,
	street_number        varchar(10)  ,
	street_name          varchar(250)  ,
	unit_number          varchar(10)  ,
	postal_code          varchar(10)  ,
	created_at           timestamp  ,
	updated_at           timestamp  ,
	city                 varchar(255)  ,
	entity_id            integer  ,
	entity_location_type_id integer  ,
	event_id             integer  ,
	longitude            numeric(15,6)  ,
	latitude             numeric(15,6)  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_location PRIMARY KEY ( dw_location_id )
 );

CREATE INDEX idx_dim_location_lookup ON warehouse.dim_location ( hashcode );

COMMENT ON COLUMN warehouse.dim_location.dw_location_id IS 'Location technical key';

COMMENT ON COLUMN warehouse.dim_location.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_location.src_location_id IS 'OLTP source location ID';

COMMENT ON COLUMN warehouse.dim_location.county_id IS 'The ID of the county';

CREATE TABLE warehouse.dim_organism ( 
	dw_organism_id       serial  NOT NULL,
	hashcode             bigint  ,
	src_organism_id      integer  ,
	organism_name        varchar(255)  ,
	snomed_name          varchar(255)  ,
	snomed_code          varchar(255)  ,
	snomed_id            varchar(255)  ,
	src_created_at       timestamp  ,
	src_updated_at       timestamp  ,
	etl_load_date        timestamp  ,
	CONSTRAINT dim_organism_pkey PRIMARY KEY ( dw_organism_id )
 );

CREATE INDEX idx_dim_organism_lookup ON warehouse.dim_organism ( hashcode );

COMMENT ON COLUMN warehouse.dim_organism.dw_organism_id IS 'OLAP TK of the dim organism entity.';

COMMENT ON COLUMN warehouse.dim_organism.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_organism.src_organism_id IS 'The OLTP organisms.id value.';

COMMENT ON COLUMN warehouse.dim_organism.organism_name IS 'The name of the organism.';

COMMENT ON COLUMN warehouse.dim_organism.snomed_name IS 'The source snomed name';

COMMENT ON COLUMN warehouse.dim_organism.snomed_code IS 'The src snomed code';

COMMENT ON COLUMN warehouse.dim_organism.snomed_id IS 'The source snomed id.';

COMMENT ON COLUMN warehouse.dim_organism.src_created_at IS 'The source created_at time.';

COMMENT ON COLUMN warehouse.dim_organism.src_updated_at IS 'The source updated at timestamp';

COMMENT ON COLUMN warehouse.dim_organism.etl_load_date IS 'The timestamp of when this organism dim record was last updated.';

CREATE TABLE warehouse.dim_outbreak ( 
	dw_outbreak_id       integer  NOT NULL,
	hashcode             integer  ,
	src_outbreak_id      integer  ,
	outbreak_name        varchar(200)  ,
	outbreak_number      varchar(200)  ,
	src_parent_outbreak_id integer  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_outbreak PRIMARY KEY ( dw_outbreak_id )
 );

CREATE INDEX idx_dim_outbreak ON warehouse.dim_outbreak ( hashcode );

COMMENT ON TABLE warehouse.dim_outbreak IS 'The outbreak dimension';

COMMENT ON COLUMN warehouse.dim_outbreak.dw_outbreak_id IS 'TK of the dim_outbreak';

COMMENT ON COLUMN warehouse.dim_outbreak.hashcode IS 'The hashcode of the outbreak dimension';

COMMENT ON COLUMN warehouse.dim_outbreak.src_outbreak_id IS 'The OLTP id of the outbreak this outbreak dimension is associated with';

COMMENT ON COLUMN warehouse.dim_outbreak.outbreak_name IS 'The name given to this outbreak';

COMMENT ON COLUMN warehouse.dim_outbreak.outbreak_number IS 'The OLTP outbreak.number';

COMMENT ON COLUMN warehouse.dim_outbreak.src_parent_outbreak_id IS 'The parent outbreak id';

COMMENT ON COLUMN warehouse.dim_outbreak.etl_load_date IS 'The date / time this outbreak dim record was loaded,';

CREATE TABLE warehouse.dim_person ( 
	dw_person_id         integer  NOT NULL,
	hashcode             bigint  ,
	src_people_id        integer  ,
	src_entity_id        integer  ,
	birth_gender_id      integer  ,
	first_name           varchar(25)  ,
	middle_name          varchar(25)  ,
	last_name            varchar(25)  ,
	birth_date           date  ,
	date_of_death        date  ,
	dw_language_id       integer  ,
	dw_ethnicity_id      integer  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dw_dim_disease_0 PRIMARY KEY ( dw_person_id )
 );

CREATE INDEX idx_dw_dim_person_lookup ON warehouse.dim_person ( hashcode );

COMMENT ON TABLE warehouse.dim_person IS 'Person dimension';

COMMENT ON COLUMN warehouse.dim_person.dw_person_id IS 'Technical key of the person dimension.';

COMMENT ON COLUMN warehouse.dim_person.hashcode IS 'Type I dimension hashcode';

COMMENT ON COLUMN warehouse.dim_person.src_people_id IS 'The source people_id of the person record';

COMMENT ON COLUMN warehouse.dim_person.src_entity_id IS 'The source entity ID of the person';

COMMENT ON COLUMN warehouse.dim_person.birth_gender_id IS 'The gender of the person';

COMMENT ON COLUMN warehouse.dim_person.first_name IS 'Person first name';

COMMENT ON COLUMN warehouse.dim_person.middle_name IS 'person middle name';

COMMENT ON COLUMN warehouse.dim_person.last_name IS 'Person last name';

COMMENT ON COLUMN warehouse.dim_person.birth_date IS 'Person birth date';

COMMENT ON COLUMN warehouse.dim_person.date_of_death IS 'Date of death date';

COMMENT ON COLUMN warehouse.dim_person.dw_language_id IS 'The language id of this user (dw_dim_language.dw_language_id)';

COMMENT ON COLUMN warehouse.dim_person.dw_ethnicity_id IS 'The ethnicity of this person (dw_dim_ethnicity.dw_ethnicity_id)';

COMMENT ON COLUMN warehouse.dim_person.etl_load_date IS 'date time of when this dim_person record was loaded';

CREATE TABLE warehouse.dim_time ( 
	dw_time_id           integer  NOT NULL,
	hashcode             integer  ,
	hour_of_day_24h      float8  ,
	minute_of_hour_24h   float8  ,
	second_of_minute_24h float8  ,
	time_key             float8  ,
	gmt_hour_of_day      numeric(18,2)  ,
	gmt_minute_of_hour   text  ,
	gmt_second_of_minute text  ,
	hour_of_day_12h      text  ,
	minute_of_hour_12h   text  ,
	second_of_minute_12h text  ,
	business_hours_flg   numeric(18,2)  ,
	core_business_hours_flg numeric(18,2)  ,
	call_center_hours_flg numeric(18,2)  ,
	oltp_report_hours_flg numeric(18,2)  ,
	am_pm_meridiem       text  ,
	time_of_day_name     text  ,
	time_of_day_name_detail text  ,
	time_text_long_24    text  ,
	time_text_short_24   text  ,
	time_text_long_12    text  ,
	time_text_short_12   text  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_time PRIMARY KEY ( dw_time_id )
 );

CREATE INDEX idx_dim_time_lookup ON warehouse.dim_time ( hashcode );

CREATE TABLE warehouse.dim_workflow ( 
	dw_workflow_id       integer  NOT NULL,
	hashcode             integer  ,
	workflow_description varchar(255)  ,
	etl_load_date        timestamp  ,
	CONSTRAINT pk_dim_workflow PRIMARY KEY ( dw_workflow_id )
 );

COMMENT ON COLUMN warehouse.dim_workflow.dw_workflow_id IS 'The OLAP TK workflow ID';

COMMENT ON COLUMN warehouse.dim_workflow.hashcode IS 'The dim_workflow hashcode';

COMMENT ON COLUMN warehouse.dim_workflow.workflow_description IS 'The workflow text';

COMMENT ON COLUMN warehouse.dim_workflow.etl_load_date IS 'The ETL load date of the workflow dimension record.';

CREATE TABLE warehouse.fact_event ( 
	src_event_id         integer  ,
	src_created_at       timestamp  ,
	src_updated_at       timestamp  ,
	dw_event_onset_date_id integer  ,
	event_name           varchar(100)  ,
	dw_outbreak_id       integer  ,
	dw_investigation_completed_by_state_date_id integer  ,
	dw_first_reported_ph_date_id integer  ,
	dw_investigation_stated_date_id integer  ,
	dw_first_reported_to_clinician_date_id integer  ,
	dw_lhd_case_status_id integer  ,
	age_at_onset         integer  ,
	dw_investigator_id   integer  ,
	src_parent_event_id  integer  ,
	dw_workflow_id       integer  ,
	dw_jurisdiction_id   integer  ,
	dw_junk_status_type_id integer  ,
	dw_disease_id        integer  ,
	dw_location_id       integer  ,
	dw_diagnosed_date_id integer  
 );

COMMENT ON TABLE warehouse.fact_event IS 'Contact and Morbidity Events';

COMMENT ON COLUMN warehouse.fact_event.src_event_id IS 'The OLTP event_id value';

COMMENT ON COLUMN warehouse.fact_event.src_created_at IS 'The date / time the event was created';

COMMENT ON COLUMN warehouse.fact_event.src_updated_at IS 'The date / time the event was last modified';

COMMENT ON COLUMN warehouse.fact_event.dw_event_onset_date_id IS 'date the event onset occurred (dim_date.dw_date_id)';

COMMENT ON COLUMN warehouse.fact_event.event_name IS 'The name given to the event';

COMMENT ON COLUMN warehouse.fact_event.dw_outbreak_id IS 'The outbreak dmension value';

COMMENT ON COLUMN warehouse.fact_event.dw_investigation_completed_by_state_date_id IS 'The date the investigation was completed';

COMMENT ON COLUMN warehouse.fact_event.dw_first_reported_ph_date_id IS 'The dim_date this event was first reported to a physician';

COMMENT ON COLUMN warehouse.fact_event.dw_investigation_stated_date_id IS 'The dim_date the investigation was started on this event.';

COMMENT ON COLUMN warehouse.fact_event.dw_first_reported_to_clinician_date_id IS 'The dim_date this event was first reported to a clincian';

COMMENT ON COLUMN warehouse.fact_event.dw_lhd_case_status_id IS 'The LHD dim_case_status id';

COMMENT ON COLUMN warehouse.fact_event.age_at_onset IS 'The patient`s age at the onset of the event';

COMMENT ON COLUMN warehouse.fact_event.dw_investigator_id IS 'The dim_investigator id';

COMMENT ON COLUMN warehouse.fact_event.src_parent_event_id IS 'The id of this event`s parent (source OLTP event_id)';

COMMENT ON COLUMN warehouse.fact_event.dw_workflow_id IS 'The dim_workflow ID';

COMMENT ON COLUMN warehouse.fact_event.dw_jurisdiction_id IS 'The ID of the dim_jurisdiction';

COMMENT ON COLUMN warehouse.fact_event.dw_junk_status_type_id IS 'FK to dim_junk_status_type junk dimension table.';

COMMENT ON COLUMN warehouse.fact_event.dw_disease_id IS 'TK of the disease of this fact';

COMMENT ON COLUMN warehouse.fact_event.dw_location_id IS 'The TK for for dim_location';

COMMENT ON COLUMN warehouse.fact_event.dw_diagnosed_date_id IS 'The TK of the dim_date describing when the patient was diagnosed';

CREATE TABLE warehouse.fact_lab_test ( 
	src_lab_test_id      integer  NOT NULL,
	dw_fact_lab_test_id  serial  NOT NULL,
	dw_collection_date_id integer  ,
	dw_junk_lab_test_id  integer  ,
	dw_lab_test_date_id  integer  ,
	dw_organism_id       integer  ,
	health_care_worker   bool  ,
	group_living         bool  ,
	day_care             bool  ,
	pregnant             bool  ,
	pregnancy_due_date   date  ,
	risk_factors         varchar(255)  ,
	food_handler         bool  ,
	dw_person_id         integer  ,
	dw_disease_id        integer  ,
	dw_primary_address_id integer  ,
	dw_secondary_address_id integer  ,
	primary_record_number varchar(20)  ,
	secondary_record_number varchar(20)  ,
	test_type_id         integer  ,
	test_result_id       integer  ,
	result_value         varchar(255)  ,
	src_created_at       timestamp  ,
	src_updated_at       timestamp  ,
	CONSTRAINT pk_fact_lab_test PRIMARY KEY ( src_lab_test_id )
 );

COMMENT ON COLUMN warehouse.fact_lab_test.src_lab_test_id IS 'The source (OLTP) id to lab_tests';

COMMENT ON COLUMN warehouse.fact_lab_test.pregnant IS 'Flag indicating whether or not the patient is pregnant.';

COMMENT ON COLUMN warehouse.fact_lab_test.dw_primary_address_id IS 'Primary dim_address';

COMMENT ON COLUMN warehouse.fact_lab_test.dw_secondary_address_id IS 'Secondary dim_address';

COMMENT ON COLUMN warehouse.fact_lab_test.primary_record_number IS 'The primary entity record number';

COMMENT ON COLUMN warehouse.fact_lab_test.secondary_record_number IS 'The secondary entity record number';

COMMENT ON COLUMN warehouse.fact_lab_test.test_type_id IS 'lab_result.test_type_id value';

COMMENT ON COLUMN warehouse.fact_lab_test.test_result_id IS 'lab_result.test_resut_id value';

COMMENT ON COLUMN warehouse.fact_lab_test.result_value IS 'lab_result.result_value value';

COMMENT ON COLUMN warehouse.fact_lab_test.src_created_at IS 'The source lab_tests.created_at value';

COMMENT ON COLUMN warehouse.fact_lab_test.src_updated_at IS 'The source (OLTP) labl_tests.updated_at value';

CREATE VIEW warehouse.vw_table_row_counts AS ((((((((SELECT 'dim_date'::text AS tbl, count(1) AS rowct FROM warehouse.dim_date UNION SELECT 'dim_time'::text AS tbl, count(1) AS rowct FROM warehouse.dim_time) UNION SELECT 'dim_disease'::text AS tbl, count(1) AS rowct FROM warehouse.dim_disease) UNION SELECT 'dim_outbreak'::text AS tbl, count(1) AS rowct FROM warehouse.dim_outbreak) UNION SELECT 'dim_jurisdction'::text AS tbl, count(1) AS rowct FROM warehouse.dim_jurisdiction) UNION SELECT 'dim_location'::text AS tbl, count(1) AS rowct FROM warehouse.dim_location) UNION SELECT 'dim_language'::text AS tbl, count(1) AS rowct FROM warehouse.dim_language) UNION SELECT 'dim_ethnicity'::text AS tbl, count(1) AS rowct FROM warehouse.dim_ethnicity) UNION SELECT 'dim_person'::text AS tbl, count(1) AS rowct FROM warehouse.dim_person) UNION SELECT 'fact_disease_event'::text AS tbl, count(1) AS rowct FROM warehouse.fact_disease_event;;


alter table warehouse.dim_date add column mmwr_week int not null default 0;

alter table warehouse.dim_date add column mmwr_year int not null default 0;

alter table warehouse.dim_address owner to pentaho;
alter table warehouse.dim_date owner to pentaho;
alter table warehouse.dim_diagnostic_facility owner to pentaho;
alter table warehouse.dim_disease owner to pentaho;
alter table warehouse.dim_ethnicity owner to pentaho;
alter table warehouse.dim_external_code owner to pentaho;
alter table warehouse.dim_investigator owner to pentaho;
alter table warehouse.dim_junk_lab_test owner to pentaho;
alter table warehouse.dim_junk_status_type owner to pentaho;
alter table warehouse.dim_jurisdiction owner to pentaho;
alter table warehouse.dim_language owner to pentaho;
alter table warehouse.dim_location owner to pentaho;
alter table warehouse.dim_outbreak owner to pentaho;
alter table warehouse.dim_person owner to pentaho;
alter table warehouse.dim_time owner to pentaho;
alter table warehouse.dim_workflow owner to pentaho;
alter table warehouse.fact_disease_event owner to pentaho;
alter table warehouse.fact_event owner to pentaho;
alter schema warehouse owner to pentaho;


-- Table: warehouse_util.dw_util_data_validation_status

DROP TABLE warehouse_util.dw_util_data_validation_status;

CREATE TABLE warehouse_util.dw_util_data_validation_status
(
  status boolean, -- Flag indicating the true / false status of the data validationş
  validation_test character varying(18),
  description character varying(250)
)
WITH (
  OIDS=FALSE
);

COMMENT ON COLUMN warehouse_util.dw_util_data_validation_status.status IS 'Flag indicating the true / false status of the data validationş';


-- Index: warehouse_util.index_status

-- DROP INDEX warehouse_util.index_status;

CREATE INDEX index_status
  ON warehouse_util.dw_util_data_validation_status
  USING btree
  (status);


alter table warehouse_util.dw_util_data_validation_status owner to pentaho;
alter schema warehouse_util owner to pentaho;


