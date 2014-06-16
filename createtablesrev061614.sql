CREATE TABLE coop_org_unit 
(
ou_recno				serial,
ou_code 				varchar(20) NOT NULL, 
ou_name 				varchar(50) NOT NULL, 
managed_by				varchar(6),
ou_date_start				date,
ou_date_end				date,
CONSTRAINT coop_org_unit_pk PRIMARY KEY(ou_recno)
);

CREATE TABLE coop_applicant 
(
applicant_no 				serial NOT NULL, 
last_name 				varchar(20) NOT NULL, 
first_name 				varchar(25) NOT NULL, 
middle_name 				varchar(20), 
gender 					char(1) NOT NULL, 
birthdate 				date NOT NULL, 
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50) NOT NULL, 
region					varchar(50), 
province 				varchar(50), 
contact_number 				varchar(12), 
email					varchar(30), 
ou_recno 				integer REFERENCES coop_org_unit (ou_recno), 
nationality 				varchar(8) NOT NULL, 
occupation 				varchar(20) NOT NULL, 
application_date 			date NOT NULL, 
application_stat			char(1) NOT NULL, 
board_action 				boolean, 
board_reso_no		 		varchar(7), 
action_date				date, 
applicant_stat_rem			text, 
resident_since 				date,
CONSTRAINT coop_applicant_pk PRIMARY KEY(applicant_no)
);

CREATE TABLE coop_member 
(
mem_no	 				varchar(10) NOT NULL, 
mem_id_no 				varchar(10) NOT NULL, 
last_name 				varchar(20) NOT NULL, 
first_name 				varchar(25) NOT NULL, 
middle_name 				varchar(20), 
nickname				varchar(15), 
gender 					char(1) NOT NULL, 
birthdate 				date NOT NULL, 
birthplace 				varchar(20), 
residence_type				char(1) NOT NULL,
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50) NOT NULL, 
region					varchar(50), 
province 				varchar(50), 
civil_status 				char(1) NOT NULL, 
contact_number 				varchar(12), 
email					varchar(30), 
height 					real, 
weight 					real, 
sc_acctno				varchar(8) NOT NULL, 
mem_date 				date NOT NULL, 
mem_status 				char(1) NOT NULL, 
status_date				date, 
mem_stat_rem				text,
ou_recno				integer REFERENCES coop_org_unit (ou_recno),
tax_id_no 				varchar(11), 
nationality 				varchar(8), 
zip_code 				varchar(4), 
occupation 				varchar(20) NOT NULL, 
religion 				varchar(14), 
p_prefix				varchar(8), 
suffix 					varchar(5), 
person_status				boolean,
blood					varchar(2),
notify_name				varchar(45),
notify_address				varchar(60),
notify_phone				varchar(11),
notify_relation				varchar(15),
owned_business				boolean NOT NULL,
CONSTRAINT coop_member_pk PRIMARY KEY(mem_no)
);

CREATE TABLE coop_report_type 
(
report_type_code			varchar(5) NOT NULL,
report_type		 		varchar(25) NOT NULL,
report_desc				text NOT NULL,
CONSTRAINT coop_report_type_pk PRIMARY KEY(report_type_code)
);

CREATE TABLE coop_report 
(
report_num 				varchar(5),
report_type_code			varchar(5) REFERENCES coop_report_type (report_type_code), 
report_dtl 				text, 
ou_recno			 	integer REFERENCES coop_org_unit (ou_recno),  
report_date_from	 		date, 
report_date_to	 			date,
report_date_encoded			date NOT NULL,
mem_no					varchar(10) REFERENCES coop_member (mem_no),
CONSTRAINT coop_report_pk PRIMARY KEY(report_num)
);

CREATE TABLE coop_prospect 
( 
prospect_no 				serial, 
last_name 				varchar(20) NOT NULL, 
first_name 				varchar(25) NOT NULL, 
middle_name 				varchar(20), 
gender 					char(1) NOT NULL, 
birthdate 				date, 
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50) NOT NULL, 
contact_number 				varchar(12),
ou_recno 				integer REFERENCES coop_org_unit (ou_recno), 
length_of_stay 				boolean NOT NULL, 
nationality 				varchar(8) NOT NULL, 
occupation 				varchar(20), 
pros_date				date NOT NULL, 
pros_stat				char(1),
pros_stat_rem				text,
approved				boolean,
endorsed				boolean,
recommended	 			boolean, 
for_evaluation 				boolean,
CONSTRAINT coop_prospect_pk PRIMARY KEY(prospect_no)
);


CREATE TABLE coop_activity_type
(
act_type_code				varchar(4) NOT NULL, 
act_type				varchar(25) NOT NULL, 
act_desc				text NOT NULL,
CONSTRAINT coop_activity_type_pk PRIMARY KEY(act_type_code)
);

CREATE TABLE coop_activity
(
act_recno 				serial,
act_type_code 				varchar(4) REFERENCES coop_activity_type (act_type_code), 
act_name				varchar(30) NOT NULL,
act_obj					varchar(30) NOT NULL,
act_date_from 				date NOT NULL, 
act_date_to 				date,
act_details 				text, 
act_location				varchar(30),
CONSTRAINT coop_activity_pk PRIMARY KEY(act_recno)
);
 			
CREATE TABLE coop_officer
(
mem_no	 				varchar(10) NOT NULL,
coop_position				varchar(10) NOT NULL,
ou_recno				integer REFERENCES coop_org_unit (ou_recno),
term_start				date NOT NULL,
term_end				date,
CONSTRAINT coop_officer_pk PRIMARY KEY(mem_no)
);

CREATE TABLE coop_org_plan
(
ou_plan_no				varchar(4) NOT NULL,
report_num				varchar(5) REFERENCES coop_report (report_num),
ou_recno				integer REFERENCES coop_org_unit (ou_recno),
plan_start				date NOT NULL,
plan_end				date,
plan_dtl				text,		
CONSTRAINT coop_org_plan_pk PRIMARY KEY(ou_plan_no)
);

CREATE TABLE coop_pros_report 
(
report_num 				varchar(5) REFERENCES coop_report (report_num),
prospect_no 				integer REFERENCES coop_prospect (prospect_no),
pros_rep_recno				serial NOT NULL,
CONSTRAINT coop_pros_report_pk PRIMARY KEY(pros_rep_recno)
);

CREATE TABLE coop_pros_repver
(
rep_ver_logno				varchar(4) NOT NULL, 
pros_rep_recno				integer REFERENCES coop_pros_report (pros_rep_recno),
ver_date				date NOT NULL,
report_dtl				text,
user_id					varchar(8) NOT NULL,
CONSTRAINT coop_pros_repver_pk PRIMARY KEY(rep_ver_logno)
);

CREATE TABLE coop_rep_act
(
rep_act_recno				serial,
report_num				varchar(5) REFERENCES coop_report (report_num),
act_recno				integer REFERENCES coop_activity (act_recno),
CONSTRAINT coop_rep_act_pk PRIMARY KEY(rep_act_recno)
);

CREATE TABLE coop_pers_sector
(
pers_sec_code				serial, 
pers_sec_name	 			varchar(20) NOT NULL,
CONSTRAINT coop_pers_sector_pk PRIMARY KEY(pers_sec_code) 
);

CREATE TABLE coop_personality 
(
personality_recno	 		serial, 
pers_sec_code 				integer REFERENCES coop_pers_sector (pers_sec_code),
last_name 				varchar(20) NOT NULL, 
first_name 				varchar(25) NOT NULL, 
middle_name 				varchar(20) NOT NULL, 
nickname				varchar(15), 
gender 					char(1) NOT NULL, 
birthdate 				date, 
birthplace 				varchar(20), 
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50), 
region					varchar(50), 
province 				varchar(50), 
zip_code 				varchar(4), 
civil_status 				char(1), 
contact_number 				varchar(12), 
email					varchar(30), 
nationality 				varchar(8), 
occupation 				varchar(20), 
religion 				varchar(14), 
p_prefix				varchar(8), 
suffix 					varchar(5), 
person_status				boolean,
CONSTRAINT coop_personality_pk PRIMARY KEY(personality_recno) 
);

CREATE TABLE coop_skill
(
sk_prof_code	 			varchar(4) NOT NULL, 
sk_prof		 			varchar(15),
CONSTRAINT coop_skill_pk PRIMARY KEY(sk_prof_code)
);

CREATE TABLE coop_pme_subject
(
subject_code				varchar(4) NOT NULL,
subject_title				varchar(50) NOT NULL,
subject_obj				varchar(50) NOT NULL,
subj_outline				text,
subj_stat				boolean NOT NULL,
CONSTRAINT coop_pme_subject_pk PRIMARY KEY(subject_code)
);

CREATE TABLE coop_app_subj_rating
(
applicant_no				integer REFERENCES coop_applicant (applicant_no),
subject_code				varchar(4) REFERENCES coop_pme_subject (subject_code),
app_subj_rating_recno			serial,
effort_rate				integer NOT NULL,
understanding_rate			integer NOT NULL,
del_method				char(1) NOT NULL,
remarks					text,
eval_date				date NOT NULL,
CONSTRAINT coop_app_subj_rating_pk PRIMARY KEY(app_subj_rating_recno)
);

CREATE TABLE coop_educ_material
(
inv_no					varchar(4) NOT NULL,
type					varchar(15) NOT NULL,
title					varchar(50) NOT NULL,
copy_no					varchar(2) NOT NULL,
borrower				varchar(10),
mat_stat				boolean,
CONSTRAINT coop_educ_material_pk PRIMARY KEY(inv_no)
);

CREATE TABLE coop_app_material
(
app_mat_recno				serial,
applicant_no				integer REFERENCES coop_applicant (applicant_no),
inv_no					varchar(4) REFERENCES coop_educ_material(inv_no),
date_borrowed				date,
date_returned				date,
CONSTRAINT coop_app_material_pk PRIMARY KEY(app_mat_recno)
);

CREATE TABLE coop_addl_address 
(
address_recno				varchar(3), 
mem_no 				varchar(10) REFERENCES coop_member (mem_no), 
address_type 				varchar(10), 
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50) NOT NULL, 
region		 			varchar(50),
province				varchar(50), 
zipcode 				varchar(4),
CONSTRAINT coop_addl_address_pk PRIMARY KEY(address_recno)
);

CREATE TABLE coop_addl_contact_info
(
contact_info_recno			varchar(2),
mem_no					varchar(10) REFERENCES coop_member (mem_no),
contact_type				char(1) NOT NULL,
contact_detail				varchar(25) NOT NULL,
CONSTRAINT coop_addl_contact_info_pk PRIMARY KEY(contact_info_recno)
);	
 

CREATE TABLE coop_app_sched
(
app_skedno				varchar(3),
applicant_no				integer REFERENCES coop_applicant (applicant_no),
act_type_code				varchar(25) REFERENCES coop_activity_type (act_type_code),
sked_status				char(1),
scheduled_time				time NOT NULL,
scheduled_date				date NOT NULL,
CONSTRAINT coop_app_sched_pk PRIMARY KEY(app_skedno)
);


CREATE TABLE coop_awards 
(
acc_awd_recno				varchar(3),
mem_no 					varchar(10) REFERENCES coop_member (mem_no), 
award_title				varchar(35), 
award_details				text,
acc_awd_date 				date,
CONSTRAINT coop_awards_pk PRIMARY KEY(acc_awd_recno)
);

CREATE TABLE coop_biz_info 
(
mem_no 					varchar(10) REFERENCES coop_member (mem_no), 
biz_info_recno				varchar(2),
biz_type	 			varchar(20) NOT NULL, 
biz_inc_range				varchar(25), 
biz_nature	 			varchar(20),
biz_name				varchar(20) NOT NULL,
date_established			date,
CONSTRAINT coop_biz_info_pk PRIMARY KEY(biz_info_recno) 
);


CREATE TABLE coop_educ_info 
(
educ_info_recno				varchar(2), 
mem_no	 				varchar(10) REFERENCES coop_member (mem_no), 
school_name 				varchar(35), 
school_level 				varchar (15), 
course 					varchar(15), 
graduated 				boolean, 
year_last_attended 			date,
CONSTRAINT coop_educ_info_pk PRIMARY KEY(educ_info_recno)
);

CREATE TABLE coop_empl_dtl 
(
mem_no					varchar(10) REFERENCES coop_member (mem_no),
employment_recno			varchar(2) NOT NULL, 
employment_stat 			varchar(15), 
rank_pos	 			varchar (15), 
comp_bracket 				varchar(25),
employment_date				date NOT NULL,
workplace_email_add			varchar(35),
emplr_biz_name	 			varchar(35) NOT NULL, 
emplr_contact_no			varchar(12),
CONSTRAINT coop_empl_dtl_pk PRIMARY KEY(employment_recno)
);

CREATE TABLE coop_mem_act
(
mem_act_recno				varchar(3) NOT NULL,
act_recno				integer REFERENCES coop_activity (act_recno), 
mem_no 					varchar(10)REFERENCES coop_member (mem_no),
CONSTRAINT coop_mem_act_pk PRIMARY KEY(mem_act_recno)
);

CREATE TABLE coop_ext_org 
(
ext_org_code 				varchar(4) NOT NULL, 
ext_org_name 				varchar(40) NOT NULL, 
ext_org_nature 				varchar(40), 
street 					varchar(60), 
barangay 				varchar(50), 
city_mun				varchar(50), 
region					varchar(50), 
province 				varchar(50), 
CONSTRAINT coop_ext_org_pk PRIMARY KEY(ext_org_code)
);

CREATE TABLE coop_ext_org_act
(
ext_org_act_recno			serial,
ext_org_code 				varchar(4) REFERENCES coop_ext_org (ext_org_code), 
act_recno 				integer REFERENCES coop_activity (act_recno),
CONSTRAINT coop_ext_org_act_pk PRIMARY KEY(EXT_org_act_recno)
);

CREATE TABLE coop_ou_act
(
ou_act_recno				varchar(3),
ou_recno				integer REFERENCES coop_org_unit (ou_recno), 
act_recno 				integer REFERENCES coop_activity (act_recno),
CONSTRAINT coop_ou_act_pk PRIMARY KEY(ou_act_recno)
);

CREATE TABLE coop_pers_act
(
pers_act_recno				serial,
personality_recno 			integer REFERENCES coop_personality (personality_recno), 
act_recno 				integer REFERENCES coop_activity (act_recno),
CONSTRAINT coop_pers_act_pk PRIMARY KEY(pers_act_recno)
);

CREATE TABLE coop_pers_ext_org 
(
pers_ext_org_recno			varchar(2),
ext_org_code 				varchar(4) REFERENCES coop_ext_org (ext_org_code), 
personality_recno 			integer REFERENCES coop_personality (personality_recno), 
rank_pos				varchar(15),
CONSTRAINT coop_pers_ext_org_pk PRIMARY KEY(pers_ext_org_recno)
);

CREATE TABLE coop_mem_skill
(
mem_no 				varchar(10) REFERENCES coop_member (mem_no), 
sk_prof_code 				varchar(4) REFERENCES coop_skill (sk_prof_code),
sk_prof_recno 				varchar(2),
CONSTRAINT coop_mem_skill_pk PRIMARY KEY(sk_prof_recno)
);

CREATE TABLE coop_pros_act 
(
pros_act_recno				varchar(2),
act_recno 				integer REFERENCES coop_activity (act_recno), 
prospect_no 				integer REFERENCES coop_prospect (prospect_no),
CONSTRAINT coop_pros_act_pk PRIMARY KEY(pros_act_recno)
); 			

CREATE TABLE coop_pros_log
(
ch_logno 				varchar(4), 
prospect_no 				integer REFERENCES coop_prospect (prospect_no),
change_log_date				date,
field_change				varchar(40),
old_value				varchar(40),
new_value				varchar(40),
user_id					varchar(8),
CONSTRAINT coop_pros_log_pk PRIMARY KEY(ch_logno)
);

CREATE TABLE coop_kin
(
relative_recno				varchar(3),
last_name 				varchar(20) NOT NULL, 
first_name 				varchar(25) NOT NULL, 
middle_name 				varchar(20),
birthdate				date,
mem_no				varchar(10) REFERENCES coop_member (mem_no),
CONSTRAINT coop_kin_pk PRIMARY KEY(relative_recno)
);

CREATE TABLE coop_kinship
(
kinship_no				varchar(3),
relative_id_no				varchar(10),
related_as				varchar(8) NOT NULL,
mem_no				varchar(10) REFERENCES coop_member (mem_no),
CONSTRAINT coop_kinship_pk PRIMARY KEY(relative_id_no)
);

CREATE TABLE coop_report_circ
(
report_num 				varchar(5) REFERENCES coop_report(report_num),
report_circ_recno			varchar(3) NOT NULL, 
to_ou_recno			 	integer REFERENCES coop_org_unit (ou_recno),  
CONSTRAINT coop_report_circ_pk PRIMARY KEY(report_circ_recno)
);

CREATE TABLE coop_pros_criteria
(
criteria_set_no				serial NOT NULL, 
criteria_set_date			date NOT NULL,  
CONSTRAINT coop_pros_criteria_pk PRIMARY KEY(criteria_set_no)
);

CREATE TABLE coop_pros_criteria_main
(
criteria_set_no				integer REFERENCES coop_pros_criteria(criteria_set_no) NOT NULL, 
criteria_no			 	integer NOT NULL,
criteria_dtl				text,
criteria_main_recno			serial NOT NULL,  
sub_criteria				boolean,	
CONSTRAINT coop_pros_criteria_main_pk PRIMARY KEY(criteria_main_recno)
);

CREATE TABLE coop_pros_criteria_sub
(
criteria_main_recno			integer REFERENCES coop_pros_criteria_main(criteria_main_recno), 
sub_criteria_no			 	integer,
sub_criteria_dtl			text,	
sub_criteria_recno			serial NOT NULL,
CONSTRAINT coop_pros_criteria_sub_pk PRIMARY KEY(sub_criteria_recno)
);

CREATE TABLE coop_pros_rating_main
(
pros_rep_recno 				integer REFERENCES coop_pros_report(pros_rep_recno),
criteria_main_recno			integer REFERENCES coop_pros_criteria_main(criteria_main_recno),
criteria_rating				integer,
pros_rating_main_recno			serial NOT NULL,  
CONSTRAINT coop_pros_rating_main_pk PRIMARY KEY(pros_rating_main_recno)
);

CREATE TABLE coop_pros_rating_sub
(
pros_rep_recno 				integer REFERENCES coop_pros_report(pros_rep_recno),
sub_criteria_recno			integer REFERENCES coop_pros_criteria_sub(sub_criteria_recno),
criteria_rating				integer,
pros_ratingsub_recno			serial NOT NULL,  
CONSTRAINT coop_pros_rating_sub_pk PRIMARY KEY(pros_rating_sub_recno)
);
