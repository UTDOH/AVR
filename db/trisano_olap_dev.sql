create sequence warehouse.dim_language_seq;
CREATE TABLE warehouse.dim_language
(
  dw_language_id integer default nextval('warehouse.dim_language_seq')
, src_language_id INTEGER
, code_name VARCHAR(500)
, the_code VARCHAR(500)
, code_description VARCHAR(500)
, src_created_at  date
, src_modified_at  date
);
alter table warehouse.dim_language add primary key (dw_language_id);

create sequence warehouse.dim_ethnicity_seq;
CREATE TABLE warehouse.dim_ethnicity
(
  dw_ethnicity_id integer not null default nextval('warehouse.dim_ethnicity_seq')
, src_ethnicity_id INTEGER
, code_name VARCHAR(500)
, the_code VARCHAR(500)
, code_description VARCHAR(500)
, src_created_at  date
, src_modified_at  date
)
;
alter table warehouse.dim_ethnicity add primary key (dw_ethnicity_id);


create sequence warehouse.dim_jurisdiction_seq;
CREATE TABLE warehouse.dim_jurisdiction
(
  dw_jurisdiction_id integer not null default nextval('warehouse.dim_jurisdiction_seq')
, src_places_id INTEGER
, src_entity_id INTEGER
, "name" VARCHAR(500)
, short_name varchar(500)
, is_primary BOOLEAN
, src_created_at  date
, src_modified_at  date
)
;

alter table warehouse.dim_jurisdiction add primary key (dw_jurisdiction_id);


create sequence warehouse.dim_person_seq;
CREATE TABLE warehouse.dim_person
(
  dw_person_id integer not null default nextval('warehouse.dim_person_seq')
, src_people_id INTEGER 
, src_entity_id INTEGER
, birth_gender_id INTEGER
, first_name VARCHAR(500)
, middle_name VARCHAR(500)
, last_name VARCHAR(500)
, birth_date date
, date_of_death date
, primary_language_id INTEGER
, ethnicity_id INTEGER
, dw_language_id INTEGER
, dw_ethnicity_id INTEGER
);
alter table warehouse.dim_person add primary key (dw_person_id);


create sequence warehouse.dim_junk_lab_test_seq;
CREATE TABLE warehouse.dim_junk_lab_test
(
  dw_junk_lab_test_id int not null default nextval('warehouse.dim_junk_lab_test_seq')
, lab_test_result_code VARCHAR(20)
, lab_test_result_description VARCHAR(100)
, lab_test_status_code VARCHAR(20)
, lab_test_status_description VARCHAR(100)
)
;
alter table warehouse.dim_junk_lab_test add primary key (dw_junk_lab_test_id);

