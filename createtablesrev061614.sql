-- Table: coop_org_unit

-- DROP TABLE coop_org_unit;

CREATE TABLE coop_org_unit
(
  ou_code character varying(12) NOT NULL,
  ou_name character varying(50) NOT NULL,
  managed_by character varying(12),
  date_created date,
  date_dissolved date,
  CONSTRAINT coop_org_unit_pk PRIMARY KEY (ou_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_org_unit
  OWNER TO postgres;


-- Table: coop_applicant

-- DROP TABLE coop_applicant;

CREATE TABLE coop_applicant
(
  applicant_no serial NOT NULL,
  last_name character varying(20) NOT NULL,
  first_name character varying(25) NOT NULL,
  middle_name character varying(20),
  gender character(1) NOT NULL,
  birthdate date NOT NULL,
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50) NOT NULL,
  region character varying(50),
  province character varying(50),
  contact_number character varying(12),
  email character varying(30),
  ou_code character varying(12),
  nationality character varying(8) NOT NULL,
  occupation character varying(20) NOT NULL,
  application_date date NOT NULL,
  application_stat character(1) NOT NULL,
  board_action boolean,
  board_reso_no character varying(7),
  action_date date,
  applicant_stat_rem text,
  resident_since date,
  civil_status character(1),
  education character(1),
  CONSTRAINT coop_applicant_pk PRIMARY KEY (applicant_no),
  CONSTRAINT coop_applicant_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_applicant
  OWNER TO postgres;

-- Table: coop_member

-- DROP TABLE coop_member;

CREATE TABLE coop_member
(
  mem_no character varying(10) NOT NULL,
  mem_id_no character varying(10) NOT NULL,
  last_name character varying(20) NOT NULL,
  first_name character varying(25) NOT NULL,
  middle_name character varying(20),
  nickname character varying(15),
  gender character(1) NOT NULL,
  birthdate date NOT NULL,
  birthplace character varying(20),
  residence_type character(1) NOT NULL,
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50) NOT NULL,
  region character varying(50),
  province character varying(50),
  civil_status character(1) NOT NULL,
  contact_number character varying(12),
  email character varying(30),
  height real,
  weight real,
  sc_acctno character varying(8) NOT NULL,
  mem_date date NOT NULL,
  mem_status character(1) NOT NULL,
  status_date date,
  mem_stat_rem text,
  ou_code character varying(12),
  tax_id_no character varying(11),
  nationality character varying(8),
  zip_code character varying(4),
  occupation character varying(20) NOT NULL,
  religion character varying(14),
  p_prefix character varying(8),
  suffix character varying(5),
  person_status boolean,
  blood character varying(2),
  notify_name character varying(45),
  notify_address character varying(60),
  notify_phone character varying(11),
  notify_relation character varying(15),
  owned_business boolean NOT NULL,
  CONSTRAINT coop_member_pk PRIMARY KEY (mem_no),
  CONSTRAINT coop_member_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_member
  OWNER TO postgres;

-- Table: coop_report_type

-- DROP TABLE coop_report_type;

CREATE TABLE coop_report_type
(
  report_type_code serial NOT NULL,
  report_type character varying(25) NOT NULL,
  report_desc text NOT NULL,
  CONSTRAINT coop_report_type_pk PRIMARY KEY (report_type_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_report_type
  OWNER TO postgres;


-- Table: coop_report

-- DROP TABLE coop_report;

CREATE TABLE coop_report
(
  report_num serial NOT NULL,
  report_type_code integer,
  report_dtl text,
  ou_code character varying(12),
  report_date_from date,
  report_date_to date,
  report_date_encoded date NOT NULL,
  mem_no character varying(10),
  CONSTRAINT coop_report_pk PRIMARY KEY (report_num),
  CONSTRAINT coop_report_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_report_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_report_report_type_code_fkey FOREIGN KEY (report_type_code)
      REFERENCES coop_report_type (report_type_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_report
  OWNER TO postgres;


-- Table: coop_prospect

-- DROP TABLE coop_prospect;

CREATE TABLE coop_prospect
(
  prospect_no serial NOT NULL,
  last_name character varying(20) NOT NULL,
  first_name character varying(25) NOT NULL,
  middle_name character varying(20),
  gender character(1) NOT NULL,
  birthdate date,
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50) NOT NULL,
  contact_number character varying(12),
  ou_code character varying(12),
  length_of_stay boolean NOT NULL,
  nationality character varying(8) NOT NULL,
  occupation character varying(20),
  pros_date date NOT NULL,
  pros_stat character(1),
  pros_stat_rem text,
  approved boolean,
  endorsed boolean,
  recommended boolean,
  for_evaluation boolean,
  CONSTRAINT coop_prospect_pk PRIMARY KEY (prospect_no),
  CONSTRAINT coop_prospect_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_prospect
  OWNER TO postgres;


-- Table: coop_activity_type

-- DROP TABLE coop_activity_type;

CREATE TABLE coop_activity_type
(
  act_type_code serial NOT NULL,
  act_type character varying(25) NOT NULL,
  act_desc text NOT NULL,
  CONSTRAINT coop_activity_type_pk PRIMARY KEY (act_type_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_activity_type
  OWNER TO postgres;


-- Table: coop_member_applicant

-- DROP TABLE coop_member_applicant;

CREATE TABLE coop_member_applicant
(
  mem_no character varying(10) NOT NULL,
  applicant_no integer NOT NULL,
  CONSTRAINT coop_member_applicant_pkey PRIMARY KEY (mem_no, applicant_no),
  CONSTRAINT coop_member_applicant_applicant_no_fkey FOREIGN KEY (applicant_no)
      REFERENCES coop_applicant (applicant_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_member_applicant_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_member_applicant
  OWNER TO postgres;


-- Table: coop_activity

-- DROP TABLE coop_activity;

CREATE TABLE coop_activity
(
  act_num serial NOT NULL,
  act_type_code integer,
  act_name character varying(30) NOT NULL,
  act_obj character varying(30) NOT NULL,
  act_date_from date NOT NULL,
  act_date_to date,
  act_details text,
  act_location character varying(30),
  CONSTRAINT coop_activity_pk PRIMARY KEY (act_num),
  CONSTRAINT coop_activity_act_type_code_fkey FOREIGN KEY (act_type_code)
      REFERENCES coop_activity_type (act_type_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_activity
  OWNER TO postgres;

 			
-- Table: coop_officer

-- DROP TABLE coop_officer;

CREATE TABLE coop_officer
(
  mem_no character varying(10),
  coop_position character varying(10) NOT NULL,
  ou_code character varying(12) NOT NULL,
  term_start date NOT NULL,
  term_end date,
  CONSTRAINT coop_officer_pkey PRIMARY KEY (coop_position, ou_code, term_start),
  CONSTRAINT coop_officer_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_officer_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_officer
  OWNER TO postgres;


-- Table: coop_org_plan

-- DROP TABLE coop_org_plan;

CREATE TABLE coop_org_plan
(
  ou_plan_no serial NOT NULL,
  report_num integer,
  ou_code character varying(12),
  CONSTRAINT coop_org_plan_pk PRIMARY KEY (ou_plan_no),
  CONSTRAINT coop_org_plan_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_org_plan_report_num_fkey FOREIGN KEY (report_num)
      REFERENCES coop_report (report_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_org_plan
  OWNER TO postgres;


-- Table: coop_pros_report

-- DROP TABLE coop_pros_report;

CREATE TABLE coop_pros_report
(
  report_num integer,
  prospect_no integer,
  pros_rep_num serial NOT NULL,
  CONSTRAINT coop_pros_report_pk PRIMARY KEY (pros_rep_num),
  CONSTRAINT coop_pros_report_prospect_no_fkey FOREIGN KEY (prospect_no)
      REFERENCES coop_prospect (prospect_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pros_report_report_num_fkey FOREIGN KEY (report_num)
      REFERENCES coop_report (report_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_report
  OWNER TO postgres;


-- Table: coop_pros_repver

-- DROP TABLE coop_pros_repver;

CREATE TABLE coop_pros_repver
(
  rep_ver_logno serial NOT NULL,
  pros_rep_num integer,
  ver_date date NOT NULL,
  report_dtl text,
  user_num character varying(10) NOT NULL,
  CONSTRAINT coop_pros_repver_pk PRIMARY KEY (rep_ver_logno),
  CONSTRAINT coop_pros_repver_pros_rep_num_fkey FOREIGN KEY (pros_rep_num)
      REFERENCES coop_pros_report (pros_rep_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_repver
  OWNER TO postgres;


-- Table: coop_rep_act

-- DROP TABLE coop_rep_act;

CREATE TABLE coop_rep_act
(
  rep_act_num serial NOT NULL,
  report_num integer,
  act_num integer,
  CONSTRAINT coop_rep_act_pk PRIMARY KEY (rep_act_num),
  CONSTRAINT coop_rep_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_rep_act_report_num_fkey FOREIGN KEY (report_num)
      REFERENCES coop_report (report_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_rep_act
  OWNER TO postgres;


-- Table: coop_pers_sector

-- DROP TABLE coop_pers_sector;

CREATE TABLE coop_pers_sector
(
  pers_sec_code serial NOT NULL,
  pers_sec_name character varying(20) NOT NULL,
  CONSTRAINT coop_pers_sector_pk PRIMARY KEY (pers_sec_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pers_sector
  OWNER TO postgres;

-- Table: coop_personality

-- DROP TABLE coop_personality;

CREATE TABLE coop_personality
(
  personality_num serial NOT NULL,
  pers_sec_code integer,
  last_name character varying(20) NOT NULL,
  first_name character varying(25) NOT NULL,
  middle_name character varying(20) NOT NULL,
  nickname character varying(15),
  gender character(1) NOT NULL,
  birthdate date,
  birthplace character varying(20),
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50),
  region character varying(50),
  province character varying(50),
  zip_code character varying(4),
  civil_status character(1),
  contact_number character varying(12),
  email character varying(30),
  nationality character varying(8),
  occupation character varying(20),
  religion character varying(14),
  p_prefix character varying(8),
  suffix character varying(5),
  person_status boolean,
  CONSTRAINT coop_personality_pk PRIMARY KEY (personality_num),
  CONSTRAINT coop_personality_pers_sec_code_fkey FOREIGN KEY (pers_sec_code)
      REFERENCES coop_pers_sector (pers_sec_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_personality
  OWNER TO postgres;

-- Table: coop_skill

-- DROP TABLE coop_skill;

CREATE TABLE coop_skill
(
  sk_prof_code serial NOT NULL,
  sk_prof character varying(15),
  CONSTRAINT coop_skill_pk PRIMARY KEY (sk_prof_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_skill
  OWNER TO postgres;

-- Table: coop_pme_subject

-- DROP TABLE coop_pme_subject;

CREATE TABLE coop_pme_subject
(
  subject_code serial NOT NULL,
  subject_title character varying(50) NOT NULL,
  subject_obj character varying(50) NOT NULL,
  subj_outline text,
  subj_stat boolean NOT NULL,
  CONSTRAINT coop_pme_subject_pk PRIMARY KEY (subject_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pme_subject
  OWNER TO postgres;

-- Table: coop_app_subj_rating

-- DROP TABLE coop_app_subj_rating;

CREATE TABLE coop_app_subj_rating
(
  applicant_no integer,
  subject_code integer,
  app_subj_rating_num serial NOT NULL,
  effort_grade integer NOT NULL,
  understanding_grade integer NOT NULL,
  del_method character(1) NOT NULL,
  remarks text,
  eval_date date NOT NULL,
  CONSTRAINT coop_app_subj_rating_pk PRIMARY KEY (app_subj_rating_num),
  CONSTRAINT coop_app_subj_rating_applicant_no_fkey FOREIGN KEY (applicant_no)
      REFERENCES coop_applicant (applicant_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_app_subj_rating_subject_code_fkey FOREIGN KEY (subject_code)
      REFERENCES coop_pme_subject (subject_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_app_subj_rating
  OWNER TO postgres;


-- Table: coop_educ_material

-- DROP TABLE coop_educ_material;

CREATE TABLE coop_educ_material
(
  inv_no serial NOT NULL,
  type character varying(15) NOT NULL,
  title character varying(50) NOT NULL,
  copy_no character varying(2) NOT NULL,
  borrower character varying(10),
  mat_stat boolean,
  CONSTRAINT coop_educ_material_pk PRIMARY KEY (inv_no)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_educ_material
  OWNER TO postgres;


-- Table: coop_app_material

-- DROP TABLE coop_app_material;

CREATE TABLE coop_app_material
(
  app_mat_num serial NOT NULL,
  applicant_no integer,
  inv_no integer,
  date_borrowed date,
  date_returned date,
  CONSTRAINT coop_app_material_pk PRIMARY KEY (app_mat_num),
  CONSTRAINT coop_app_material_applicant_no_fkey FOREIGN KEY (applicant_no)
      REFERENCES coop_applicant (applicant_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_app_material_inv_no_fkey FOREIGN KEY (inv_no)
      REFERENCES coop_educ_material (inv_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_app_material
  OWNER TO postgres;


-- Table: coop_addl_address

-- DROP TABLE coop_addl_address;

CREATE TABLE coop_addl_address
(
  addl_address_num serial NOT NULL,
  mem_no character varying(10),
  address_type character varying(10),
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50) NOT NULL,
  region character varying(50),
  province character varying(50),
  zipcode character varying(4),
  CONSTRAINT coop_addl_address_pk PRIMARY KEY (addl_address_num),
  CONSTRAINT coop_addl_address_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_addl_address
  OWNER TO postgres;

-- Table: coop_addl_contact_info

-- DROP TABLE coop_addl_contact_info;

CREATE TABLE coop_addl_contact_info
(
  contact_info_num serial NOT NULL,
  mem_no character varying(10),
  contact_type character(1) NOT NULL,
  contact_detail character varying(25) NOT NULL,
  CONSTRAINT coop_addl_contact_info_pk PRIMARY KEY (contact_info_num),
  CONSTRAINT coop_addl_contact_info_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_addl_contact_info
  OWNER TO postgres;


-- Table: coop_app_sched

-- DROP TABLE coop_app_sched;

CREATE TABLE coop_app_sched
(
  app_skedno serial NOT NULL,
  applicant_no integer,
  act_type_code integer,
  sked_status character(1),
  scheduled_time time without time zone NOT NULL,
  scheduled_date date NOT NULL,
  CONSTRAINT coop_app_sched_pk PRIMARY KEY (app_skedno),
  CONSTRAINT coop_app_sched_act_type_code_fkey FOREIGN KEY (act_type_code)
      REFERENCES coop_activity_type (act_type_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_app_sched_applicant_no_fkey FOREIGN KEY (applicant_no)
      REFERENCES coop_applicant (applicant_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_app_sched
  OWNER TO postgres;



-- Table: coop_awards

-- DROP TABLE coop_awards;

CREATE TABLE coop_awards
(
  acc_awd_num serial NOT NULL,
  mem_no character varying(10),
  award_title character varying(35),
  award_details text,
  acc_awd_date date,
  CONSTRAINT coop_awards_pk PRIMARY KEY (acc_awd_num),
  CONSTRAINT coop_awards_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_awards
  OWNER TO postgres;


-- Table: coop_biz_info

-- DROP TABLE coop_biz_info;

CREATE TABLE coop_biz_info
(
  mem_no character varying(10),
  biz_info_num integer NOT NULL,
  biz_type character varying(20) NOT NULL,
  biz_inc_range character varying(25),
  biz_nature character varying(20),
  biz_name character varying(20) NOT NULL,
  date_established date,
  CONSTRAINT coop_biz_info_pk PRIMARY KEY (biz_info_num),
  CONSTRAINT coop_biz_info_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_biz_info
  OWNER TO postgres;


-- Table: coop_educ_info

-- DROP TABLE coop_educ_info;

CREATE TABLE coop_educ_info
(
  educ_info_num serial NOT NULL,
  mem_no character varying(10),
  school_name character varying(35),
  school_level character varying(15),
  course character varying(15),
  graduated boolean,
  year_last_attended date,
  CONSTRAINT coop_educ_info_pk PRIMARY KEY (educ_info_num),
  CONSTRAINT coop_educ_info_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_educ_info
  OWNER TO postgres;


-- Table: coop_empl_dtl

-- DROP TABLE coop_empl_dtl;

CREATE TABLE coop_empl_dtl
(
  mem_no character varying(10),
  employment_num serial NOT NULL,
  employment_stat character varying(15),
  rank_pos character varying(15),
  comp_bracket character varying(25),
  employment_date date NOT NULL,
  workplace_email_add character varying(35),
  emplr_biz_name character varying(35) NOT NULL,
  emplr_contact_no character varying(12),
  CONSTRAINT coop_empl_dtl_pk PRIMARY KEY (employment_num),
  CONSTRAINT coop_empl_dtl_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_empl_dtl
  OWNER TO postgres;

-- Table: coop_mem_act

-- DROP TABLE coop_mem_act;

CREATE TABLE coop_mem_act
(
  mem_act_num serial NOT NULL,
  act_num integer,
  mem_no character varying(10),
  CONSTRAINT coop_mem_act_pk PRIMARY KEY (mem_act_num),
  CONSTRAINT coop_mem_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_mem_act_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_mem_act
  OWNER TO postgres;


-- Table: coop_ext_org

-- DROP TABLE coop_ext_org;

CREATE TABLE coop_ext_org
(
  ext_org_name character varying(40) NOT NULL,
  ext_org_nature character varying(40),
  street character varying(60),
  barangay character varying(50),
  city_mun character varying(50),
  region character varying(50),
  province character varying(50),
  ext_org_no serial NOT NULL,
  ext_org_code character varying(4),
  CONSTRAINT coop_ext_org_pkey PRIMARY KEY (ext_org_no)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_ext_org
  OWNER TO postgres;

-- Table: coop_ext_org_act

-- DROP TABLE coop_ext_org_act;

CREATE TABLE coop_ext_org_act
(
  ext_org_act_num serial NOT NULL,
  ext_org_no integer,
  act_num integer,
  CONSTRAINT coop_ext_org_act_pk PRIMARY KEY (ext_org_act_num),
  CONSTRAINT coop_ext_org_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_ext_org_act_ext_org_no_fkey FOREIGN KEY (ext_org_no)
      REFERENCES coop_ext_org (ext_org_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_ext_org_act
  OWNER TO postgres;


-- Table: coop_ou_act

-- DROP TABLE coop_ou_act;

CREATE TABLE coop_ou_act
(
  ou_act_num serial NOT NULL,
  ou_code character varying(12),
  act_num integer,
  CONSTRAINT coop_ou_act_pk PRIMARY KEY (ou_act_num),
  CONSTRAINT coop_ou_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_ou_act_ou_code_fkey FOREIGN KEY (ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_ou_act
  OWNER TO postgres;


-- Table: coop_pers_act

-- DROP TABLE coop_pers_act;

CREATE TABLE coop_pers_act
(
  pers_act_num serial NOT NULL,
  personality_num integer,
  act_num integer,
  CONSTRAINT coop_pers_act_pk PRIMARY KEY (pers_act_num),
  CONSTRAINT coop_pers_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pers_act_personality_num_fkey FOREIGN KEY (personality_num)
      REFERENCES coop_personality (personality_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pers_act
  OWNER TO postgres;


-- Table: coop_pers_ext_org

-- DROP TABLE coop_pers_ext_org;

CREATE TABLE coop_pers_ext_org
(
  pers_ext_org_num serial NOT NULL,
  ext_org_no integer,
  personality_num integer,
  rank_pos character varying(15),
  CONSTRAINT coop_pers_ext_org_pk PRIMARY KEY (pers_ext_org_num),
  CONSTRAINT coop_pers_ext_org_ext_org_no_fkey FOREIGN KEY (ext_org_no)
      REFERENCES coop_ext_org (ext_org_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pers_ext_org_personality_num_fkey FOREIGN KEY (personality_num)
      REFERENCES coop_personality (personality_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pers_ext_org
  OWNER TO postgres;


-- Table: coop_mem_skill

-- DROP TABLE coop_mem_skill;

CREATE TABLE coop_mem_skill
(
  mem_no character varying(10),
  sk_prof_code integer NOT NULL,
  mem_skill_num serial NOT NULL,
  CONSTRAINT coop_mem_skill_pkey PRIMARY KEY (mem_skill_num),
  CONSTRAINT coop_mem_skill_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_mem_skill_sk_prof_code_fkey FOREIGN KEY (sk_prof_code)
      REFERENCES coop_skill (sk_prof_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_mem_skill
  OWNER TO postgres;


-- Table: coop_pros_act

-- DROP TABLE coop_pros_act;

CREATE TABLE coop_pros_act
(
  pros_act_num serial NOT NULL,
  act_num integer,
  prospect_no integer,
  CONSTRAINT coop_pros_act_pk PRIMARY KEY (pros_act_num),
  CONSTRAINT coop_pros_act_act_num_fkey FOREIGN KEY (act_num)
      REFERENCES coop_activity (act_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pros_act_prospect_no_fkey FOREIGN KEY (prospect_no)
      REFERENCES coop_prospect (prospect_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_act
  OWNER TO postgres;
			

-- Table: coop_pros_log

-- DROP TABLE coop_pros_log;

CREATE TABLE coop_pros_log
(
  ch_logno serial NOT NULL,
  prospect_no integer,
  change_log_date date,
  field_change character varying(40),
  old_value character varying(40),
  new_value character varying(40),
  user_id character varying(10),
  CONSTRAINT coop_pros_log_pk PRIMARY KEY (ch_logno),
  CONSTRAINT coop_pros_log_prospect_no_fkey FOREIGN KEY (prospect_no)
      REFERENCES coop_prospect (prospect_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_log
  OWNER TO postgres;

-- Table: coop_kin

-- DROP TABLE coop_kin;

CREATE TABLE coop_kin
(
  relative_num serial NOT NULL,
  last_name character varying(20) NOT NULL,
  first_name character varying(25) NOT NULL,
  middle_name character varying(20),
  birthdate date,
  mem_no character varying(10),
  CONSTRAINT coop_kin_pk PRIMARY KEY (relative_num),
  CONSTRAINT coop_kin_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_kin
  OWNER TO postgres;


-- Table: coop_kinship

-- DROP TABLE coop_kinship;

CREATE TABLE coop_kinship
(
  kinship_no serial NOT NULL,
  related_as character varying(10) NOT NULL,
  mem_no character varying(10),
  relative_num integer,
  CONSTRAINT coop_kinship_pk PRIMARY KEY (kinship_no),
  CONSTRAINT coop_kinship_mem_no_fkey FOREIGN KEY (mem_no)
      REFERENCES coop_member (mem_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_kinship_relative_num FOREIGN KEY (relative_num)
      REFERENCES coop_kin (relative_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_kinship
  OWNER TO postgres;


-- Table: coop_report_circ

-- DROP TABLE coop_report_circ;

CREATE TABLE coop_report_circ
(
  report_num integer,
  report_circ_num serial NOT NULL,
  to_ou_code character varying(12),
  CONSTRAINT coop_report_circ_pk PRIMARY KEY (report_circ_num),
  CONSTRAINT coop_report_circ_report_num_fkey FOREIGN KEY (report_num)
      REFERENCES coop_report (report_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_report_circ_to_ou_code_fkey FOREIGN KEY (to_ou_code)
      REFERENCES coop_org_unit (ou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_report_circ
  OWNER TO postgres;


-- Table: coop_pros_criteria

-- DROP TABLE coop_pros_criteria;

CREATE TABLE coop_pros_criteria
(
  criteria_set_no serial NOT NULL,
  criteria_set_date date NOT NULL,
  CONSTRAINT coop_pros_criteria_pk PRIMARY KEY (criteria_set_no)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_criteria
  OWNER TO postgres;


-- Table: coop_pros_criteria_main

-- DROP TABLE coop_pros_criteria_main;

CREATE TABLE coop_pros_criteria_main
(
  criteria_set_no integer NOT NULL,
  criteria_no integer NOT NULL,
  criteria_dtl text,
  criteria_main_num serial NOT NULL,
  sub_criteria boolean,
  CONSTRAINT coop_pros_criteria_main_pk PRIMARY KEY (criteria_main_num),
  CONSTRAINT coop_pros_criteria_main_criteria_set_no_fkey FOREIGN KEY (criteria_set_no)
      REFERENCES coop_pros_criteria (criteria_set_no) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_criteria_main
  OWNER TO postgres;

-- Table: coop_pros_criteria_sub

-- DROP TABLE coop_pros_criteria_sub;

CREATE TABLE coop_pros_criteria_sub
(
  criteria_main_num integer,
  sub_criteria_no integer,
  sub_criteria_dtl text,
  sub_criteria_num serial NOT NULL,
  CONSTRAINT coop_pros_criteria_sub_pk PRIMARY KEY (sub_criteria_num),
  CONSTRAINT coop_pros_criteria_sub_criteria_main_num_fkey FOREIGN KEY (criteria_main_num)
      REFERENCES coop_pros_criteria_main (criteria_main_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_criteria_sub
  OWNER TO postgres;

-- Table: coop_pros_rating_main

-- DROP TABLE coop_pros_rating_main;

CREATE TABLE coop_pros_rating_main
(
  pros_rep_num integer,
  criteria_main_num integer,
  criteria_rating integer,
  pros_rating_main_num serial NOT NULL,
  CONSTRAINT coop_pros_rating_main_pk PRIMARY KEY (pros_rating_main_num),
  CONSTRAINT coop_pros_rating_main_criteria_main_num_fkey FOREIGN KEY (criteria_main_num)
      REFERENCES coop_pros_criteria_main (criteria_main_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pros_rating_main_pros_rep_num_fkey FOREIGN KEY (pros_rep_num)
      REFERENCES coop_pros_report (pros_rep_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_rating_main
  OWNER TO postgres;


-- Table: coop_pros_rating_sub

-- DROP TABLE coop_pros_rating_sub;

CREATE TABLE coop_pros_rating_sub
(
  pros_rep_num integer,
  sub_criteria_num integer,
  criteria_rating integer,
  pros_rating_sub_num serial NOT NULL,
  CONSTRAINT coop_pros_rating_sub_pk PRIMARY KEY (pros_rating_sub_num),
  CONSTRAINT coop_pros_rating_sub_pros_rep_num_fkey FOREIGN KEY (pros_rep_num)
      REFERENCES coop_pros_report (pros_rep_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_pros_rating_sub_sub_criteria_num_fkey FOREIGN KEY (sub_criteria_num)
      REFERENCES coop_pros_criteria_sub (sub_criteria_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_pros_rating_sub
  OWNER TO postgres;
