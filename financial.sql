-- Table: coop_applicant

-- DROP TABLE coop_applicant;

CREATE TABLE coop_applicant
(
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
  occupation character varying(50),
  application_date date NOT NULL,
  application_stat character varying(1) NOT NULL,
  board_action boolean,
  board_reso_no character varying(7),
  action_date date,
  applicant_stat_rem text,
  civil_status character(1) NOT NULL,
  education character(1),
  applicant_no serial NOT NULL,
  prospect_no integer,
  resident_since integer,
  sc_acctno integer,
  sc_complete boolean,
  CONSTRAINT coop_applicant_pkey PRIMARY KEY (applicant_no),
  CONSTRAINT coop_applicant_fkey FOREIGN KEY (sc_acctno)
      REFERENCES coop_finance_share_capital_accounts (sc_acctno) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_applicant
  OWNER TO postgres;

-- Function: function_insert_to_account_profile()

-- DROP FUNCTION function_insert_to_account_profile();

CREATE OR REPLACE FUNCTION function_insert_to_account_profile()
  RETURNS trigger AS
$BODY$
BEGIN
if new.sc_complete is TRUE  then
INSERT INTO
account_profile(last_name,first_name,middle_name,birthdate,date_added,applicant_no)
Values
(new.last_name,new.first_name,new.middle_name,new.birthdate,current_date,new.applicant_no);

RETURN new;
end if;
 if new.sc_complete is FALSE OR new.sc_complete IS NULL then
return null;

end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_account_profile()
  OWNER TO postgres;


-- Trigger: trig_insert_to_account_profile on coop_applicant

-- DROP TRIGGER trig_insert_to_account_profile ON coop_applicant;

CREATE TRIGGER trig_insert_to_account_profile
  AFTER UPDATE OF sc_complete
  ON coop_applicant
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_account_profile();

-- Table: coop_finance_account_profile

-- DROP TABLE coop_finance_account_profile;

CREATE TABLE coop_finance_account_profile
(
  acct_profile_id serial NOT NULL,
  last_name character varying,
  first_name character varying,
  middle_name character varying,
  birthdate date,
  member_no character varying(10),
  date_added date,
  application_no integer,
  CONSTRAINT account_profile_pkey PRIMARY KEY (acct_profile_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_account_profile
  OWNER TO postgres;

-- Function: function_insert_to_scap()

-- DROP FUNCTION function_insert_to_scap();

CREATE OR REPLACE FUNCTION function_insert_to_scap()
  RETURNS trigger AS
$BODY$
BEGIN

INSERT INTO
        sharecapital_account_profile(sc_account,profile_id,date_added)
VALUES
        (default,new.profile_id,default);
        RETURN new;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_scap()
  OWNER TO postgres;

-- Trigger: trig_insert_to_scap on coop_finance_account_profile

-- DROP TRIGGER trig_insert_to_scap ON coop_finance_account_profile;

CREATE TRIGGER trig_insert_to_scap
  AFTER INSERT
  ON coop_finance_account_profile
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_scap();

-- Table: coop_finance_chart_of_account

-- DROP TABLE coop_finance_chart_of_account;

CREATE TABLE coop_finance_chart_of_account
(
  coa_code integer NOT NULL,
  coa_title character varying,
  coa_desc text,
  CONSTRAINT coop_finance_chart_of_account_pkey PRIMARY KEY (coa_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_chart_of_account
  OWNER TO postgres;

-- Table: coop_finance_coa_particular

-- DROP TABLE coop_finance_coa_particular;

CREATE TABLE coop_finance_coa_particular
(
  coa_code integer,
  particular_code character varying NOT NULL,
  particular_title text,
  CONSTRAINT coop_finance_coa_particular_pkey PRIMARY KEY (particular_code),
  CONSTRAINT coop_finance_coa_particular_coa_code_fkey FOREIGN KEY (coa_code)
      REFERENCES coop_finance_chart_of_account (coa_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_coa_particular
  OWNER TO postgres;

-- Table: coop_finance_daily_cash_transaction

-- DROP TABLE coop_finance_daily_cash_transaction;

CREATE TABLE coop_finance_daily_cash_transaction
(
  trans_num serial NOT NULL,
  particular_code character varying,
  or_num character varying,
  amount double precision,
  teller_code character varying(3),
  trans_date date,
  trans_item character varying,
  entry_type character(1),
  CONSTRAINT daily_cash_transaction_pkey PRIMARY KEY (trans_num),
  CONSTRAINT coo_finance_daily_cash_transaction_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_daily_cash_transaction
  OWNER TO postgres;

-- Function: function_insert_to_ascal()

-- DROP FUNCTION function_insert_to_ascal();

CREATE OR REPLACE FUNCTION function_insert_to_ascal()
  RETURNS trigger AS
$BODY$
BEGIN

INSERT INTO
        sharecapital_ledger(sc_account,debit,post_date,trans_no)Select cast(trans_item AS integer),amount,trans_date,trans_no from daily_transaction where particular_code ='30150-01' AND trans_no =new.trans_no;
        RETURN new;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_ascal()
  OWNER TO postgres;


-- Trigger: trig_insert_to_ascal on coop_finance_daily_cash_transaction

-- DROP TRIGGER trig_insert_to_ascal ON coop_finance_daily_cash_transaction;

CREATE TRIGGER trig_insert_to_ascal
  AFTER INSERT
  ON coop_finance_daily_cash_transaction
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_ascal();

-- Function: function_insert_to_crj()

-- DROP FUNCTION function_insert_to_crj();

CREATE OR REPLACE FUNCTION function_insert_to_crj()
  RETURNS trigger AS
$BODY$
BEGIN
    INSERT INTO
        coop_finance_cash_receipt_journal(particular_code,or_num,amount,entry_type,trans_no,trans_date)
        VALUES(new.particular_code,new.or_num,new.amount,new.entry_type,new.trans_no,new.trans_date);
        RETURN new;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_crj()
  OWNER TO postgres;

-- Trigger: trig_insert_to_crj on coop_finance_daily_cash_transaction

-- DROP TRIGGER trig_insert_to_crj ON coop_finance_daily_cash_transaction;

CREATE TRIGGER trig_insert_to_crj
  AFTER INSERT
  ON coop_finance_daily_cash_transaction
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_crj();

-- Function: function_insert_to_sal()

-- DROP FUNCTION function_insert_to_sal();

CREATE OR REPLACE FUNCTION function_insert_to_sal()
  RETURNS trigger AS
$BODY$
BEGIN

INSERT INTO
        savingdeposit_ledger(sd_account,debit,post_date,trans_no)Select trans_item,amount,trans_date,trans_no from daily_transaction where particular_code ='21100-01' AND trans_no =new.trans_no;
        RETURN new;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_sal()
  OWNER TO postgres;

-- Trigger: trig_insert_to_sal on coop_finance_daily_cash_transaction

-- DROP TRIGGER trig_insert_to_sal ON coop_finance_daily_cash_transaction;

CREATE TRIGGER trig_insert_to_sal
  AFTER INSERT
  ON coop_finance_daily_cash_transaction
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_sal();

-- Function: function_update_daily()

-- DROP FUNCTION function_update_daily();

CREATE OR REPLACE FUNCTION function_update_daily()
  RETURNS trigger AS
$BODY$
BEGIN
IF new.trans_no = old.trans_no THEN
Update coop_finance_cash_receipt_journal set amount=new.amount,particular_code=new.particular_code,or_num=new.or_num where trans_no = old.trans_no;
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_update_daily()
  OWNER TO postgres;

-- Trigger: trigger_update_daily on coop_finance_daily_cash_transaction

-- DROP TRIGGER trigger_update_daily ON coop_finance_daily_cash_transaction;

CREATE TRIGGER trigger_update_daily
  AFTER UPDATE
  ON coop_finance_daily_cash_transaction
  FOR EACH ROW
  EXECUTE PROCEDURE function_update_daily();

-- Function: function_update_scl()

-- DROP FUNCTION function_update_scl();

CREATE OR REPLACE FUNCTION function_update_scl()
  RETURNS trigger AS
$BODY$
BEGIN
IF new.trans_no = old.trans_no THEN
Update sharecapital_ledger set debit=new.amount,
sc_account=cast(new.trans_item AS integer)
where trans_no = old.trans_no;
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_update_scl()
  OWNER TO postgres;

-- Trigger: trigger_update_scl on coop_finance_daily_cash_transaction

-- DROP TRIGGER trigger_update_scl ON coop_finance_daily_cash_transaction;

CREATE TRIGGER trigger_update_scl
  AFTER UPDATE
  ON coop_finance_daily_cash_transaction
  FOR EACH ROW
  EXECUTE PROCEDURE function_update_scl();
                                                                                                                                                  
-- Table: coop_finance_share_capital_accounts

-- DROP TABLE coop_finance_share_capital_accounts;

CREATE TABLE coop_finance_share_capital_accounts
(
  sc_acctno integer NOT NULL,
  acct_profile_id integer,
  date_added date,
  CONSTRAINT coop_finance_share_capital_accounts_pkey PRIMARY KEY (sc_acctno),
  CONSTRAINT coop_finance_share_capital_accounts_acct_profile_id_fkey FOREIGN KEY (acct_profile_id)
      REFERENCES coop_finance_account_profile (acct_profile_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_share_capital_accounts
  OWNER TO postgres;

-- Function: function_insert_sc_account_num_to_applicant()

-- DROP FUNCTION function_insert_sc_account_num_to_applicant();

CREATE OR REPLACE FUNCTION function_insert_sc_account_num_to_applicant()
  RETURNS trigger AS
$BODY$
BEGIN
UPDATE coop_applicant SET sc_no = new.sc_account 
where
sc_no IS NULL and sc_complete IS TRUE;
return new;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_sc_account_num_to_applicant()
  OWNER TO postgres;

-- Trigger: trig_insert_sc_account_num_to_applicant on coop_finance_share_capital_accounts

-- DROP TRIGGER trig_insert_sc_account_num_to_applicant ON coop_finance_share_capital_accounts;

CREATE TRIGGER trig_insert_sc_account_num_to_applicant
  AFTER INSERT
  ON coop_finance_share_capital_accounts
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_sc_account_num_to_applicant();

-- Function: function_insert_to_sd()

-- DROP FUNCTION function_insert_to_sd();

CREATE OR REPLACE FUNCTION function_insert_to_sd()
  RETURNS trigger AS
$BODY$
BEGIN

INSERT INTO
        coop_finance_savings_account(sd_account,profile_id,date_added)
VALUES
        (new.sc_account,new.profile_id,current_date);
        RETURN new;       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_sd()
  OWNER TO postgres;

-- Trigger: trig_insert_to_sd on coop_finance_share_capital_accounts

-- DROP TRIGGER trig_insert_to_sd ON coop_finance_share_capital_accounts;

CREATE TRIGGER trig_insert_to_sd
  AFTER INSERT
  ON coop_finance_share_capital_accounts
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_sd();

-- Table: coop_finance_savings_account

-- DROP TABLE coop_finance_savings_account;

CREATE TABLE coop_finance_savings_account
(
  sd_acctno integer NOT NULL,
  acct_profile_id integer,
  date_added date,
  CONSTRAINT coop_finance_savings_account_pkey PRIMARY KEY (sd_acctno),
  CONSTRAINT coop_finance_savings_account_acct_profile_id_fkey FOREIGN KEY (acct_profile_id)
      REFERENCES coop_finance_account_profile (acct_profile_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_savings_account
  OWNER TO postgres;

-- Table: coop_finance_cash_receipt_journal

-- DROP TABLE coop_finance_cash_receipt_journal;

CREATE TABLE coop_finance_cash_receipt_journal
(
  record_num serial NOT NULL,
  particular_code character varying,
  or_num character varying,
  entry_type character(1),
  amount double precision,
  date_recorded date,
  trans_num integer,
  CONSTRAINT coop_finance_cash_receipt_journal_pkey PRIMARY KEY (record_num),
  CONSTRAINT coop_finance_cash_receipt_journal_trans_num_fkey FOREIGN KEY (trans_num)
      REFERENCES coop_finance_daily_cash_transaction (trans_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_cash_receipt_journal
  OWNER TO postgres;

-- Function: function_insert_to_subsis()

-- DROP FUNCTION function_insert_to_subsis();

CREATE OR REPLACE FUNCTION function_insert_to_subsis()
  RETURNS trigger AS
$BODY$
BEGIN
If CAST((LEFT(new.particular_code,5))AS INTEGER)<=20000  THEN 
    INSERT INTO
        subsi_asset(particular_code,amount,entry_type,rec_no,post_date)
        VALUES(new.particular_code,new.amount,new.entry_type,new.rec_no,new.trans_date);
ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=20000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=30000 THEN
INSERT INTO
        subsi_liabilities(particular_code,amount,entry_type,rec_no,post_date)
        VALUES(new.particular_code,new.amount,new.entry_type,new.rec_no,new.trans_date);
ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=30000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=40000 THEN
INSERT INTO
        subsi_equity(particular_code,amount,entry_type,rec_no,post_date)
        VALUES(new.particular_code,new.amount,new.entry_type,new.rec_no,new.trans_date);
ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=40000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=70000 THEN
INSERT INTO
        subsi_revenue(particular_code,amount,entry_type,rec_no,post_date)
        VALUES(new.particular_code,new.amount,new.entry_type,new.rec_no,new.trans_date);
ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=70000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=90000 THEN
INSERT INTO
        subsi_expenses(particular_code,amount,entry_type,rec_no,post_date)
        VALUES(new.particular_code,new.amount,new.entry_type,new.rec_no,new.trans_date);
END IF;        
RETURN new;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_insert_to_subsis()
  OWNER TO postgres;

-- Trigger: trigger_insert_subsis on coop_finance_cash_receipt_journal

-- DROP TRIGGER trigger_insert_subsis ON coop_finance_cash_receipt_journal;

CREATE TRIGGER trigger_insert_subsis
  AFTER INSERT
  ON coop_finance_cash_receipt_journal
  FOR EACH ROW
  EXECUTE PROCEDURE function_insert_to_subsis();

-- Function: function_update_to_subsis()

-- DROP FUNCTION function_update_to_subsis();

CREATE OR REPLACE FUNCTION function_update_to_subsis()
  RETURNS trigger AS
$BODY$
BEGIN
If CAST((LEFT(new.particular_code,5))AS INTEGER)<=20000  THEN 

    update 
        subsi_asset set amount = new.amount where rec_no = old.rec_no;

ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=20000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=30000 THEN
update 
        subsi_liabilities set amount = new.amount where rec_no = old.rec_no;

ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=30000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=40000 THEN

update 
        subsi_equity set amount = new.amount where rec_no = old.rec_no;

ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=40000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=70000 THEN

update 
        subsi_revenue set amount = new.amount where rec_no = old.rec_no;

ELSEIF CAST((LEFT(new.particular_code,5))AS INTEGER)>=70000 AND 
       CAST((LEFT(new.particular_code,5))AS INTEGER)<=90000 THEN

update 
        subsi_expenses set amount = new.amount where rec_no = old.rec_no;
END IF;        
RETURN new;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_update_to_subsis()
  OWNER TO postgres;

-- Trigger: trigger_update_subsis on coop_finance_cash_receipt_journal

-- DROP TRIGGER trigger_update_subsis ON coop_finance_cash_receipt_journal;

CREATE TRIGGER trigger_update_subsis
  AFTER UPDATE
  ON coop_finance_cash_receipt_journal
  FOR EACH ROW
  EXECUTE PROCEDURE function_update_to_subsis();

-- Table: coop_finance_share_capital_account_ledger

-- DROP TABLE coop_finance_share_capital_account_ledger;

CREATE TABLE coop_finance_share_capital_account_ledger
(
  sc_postnum integer NOT NULL,
  date_posted date,
  trans_code character varying,
  trans_num integer,
  sc_debit double precision,
  sc_credit double precision,
  sc_old_balance double precision,
  sc_new_balance double precision,
  sc_acctno integer,
  CONSTRAINT coop_finance_share_capital_account_ledger_pkey PRIMARY KEY (sc_postnum),
  CONSTRAINT coop_finance_share_capital_account_ledger_sc_acctno_fkey FOREIGN KEY (sc_acctno)
      REFERENCES coop_finance_share_capital_accounts (sc_acctno) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_finance_share_capital_account_ledger_trans_num_fkey FOREIGN KEY (trans_num)
      REFERENCES coop_finance_daily_cash_transaction (trans_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_share_capital_account_ledger
  OWNER TO postgres;

-- Table: coop_finance_ledger

-- DROP TABLE coop_finance_savings_account_ledger;

CREATE TABLE coop_finance_savings_account_ledger
(
  sd_postnum serial NOT NULL,
  trans_num integer,
  sd_acctno integer,
  sd_debit double precision,
  sd_credit double precision,
  sd_old_balance double precision,
  sd_new_balance double precision,
  date_posted date,
  trans_code character varying,
  CONSTRAINT coop_finance_savings_account_ledger_pkey PRIMARY KEY (sd_postnum),
  CONSTRAINT coop_finance_savings_account_ledger_sd_acctno_fkey FOREIGN KEY (sd_acctno)
      REFERENCES coop_finance_savings_account (sd_acctno) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT coop_finance_savings_account_ledger_trans_num_fkey FOREIGN KEY (trans_num)
      REFERENCES coop_finance_daily_cash_transaction (trans_num) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_savings_account_ledger
  OWNER TO postgres;

-- Function: function_update_saving_balance()

-- DROP FUNCTION function_update_saving_balance();

CREATE OR REPLACE FUNCTION function_update_saving_balance()
  RETURNS trigger AS
$BODY$Declare var integer;
BEGIN
Select new_balance into var from savingdeposit_ledger where sd_account = new.sd_account order by sd_no desc limit 1 offset 1;
if var IS NULL then 
Update savingdeposit_ledger set old_balance = 0,new_balance = new.debit 
where sd_account = new.sd_account AND trans_no = new.trans_no;
return new;
Elsif var = 0 OR var > 0 then
Update savingdeposit_ledger set old_balance =var,new_balance = new.debit + var
where sd_account = new.sd_account AND trans_no = new.trans_no;
return new;
end if;

END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION function_update_saving_balance()
  OWNER TO postgres;

-- Trigger: trigger_update_saving_balance on coop_finance_savings_account_ledger

-- DROP TRIGGER trigger_update_saving_balance ON coop_finance_savings_account_ledger;

CREATE TRIGGER trigger_update_saving_balance
  AFTER INSERT
  ON coop_finance_savings_account_ledger
  FOR EACH ROW
  EXECUTE PROCEDURE function_update_saving_balance();


-- Table: coop_finance_general_ledger

-- DROP TABLE coop_finance_general_ledger;

CREATE TABLE coop_finance_general_ledger
(
  gl_postnum serial NOT NULL,
  particular_code character varying,
  entry_type character(1),
  amount double precision,
  ref_date date,
  date_posted date,
  CONSTRAINT coop_finance_general_ledger_pkey PRIMARY KEY (gl_postnum),
  CONSTRAINT coop_finance_general_ledger_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_general_ledger
  OWNER TO postgres;

-- Table: coop_finance_subsi_asset

-- DROP TABLE coop_finance_subsi_asset;

CREATE TABLE coop_finance_subsi_asset
(
  entry_type character varying(1),
  amount double precision,
  date_posted date,
  particular_code character varying,
  ast_postnum serial NOT NULL,
  record_num integer NOT NULL,
  CONSTRAINT coop_finance_subsi_asset_pkey PRIMARY KEY (ast_postnum, record_num),
  CONSTRAINT coop_finance_subsi_asset_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_subsi_asset
  OWNER TO postgres;


-- Table: coop_finance_subsi_equity

-- DROP TABLE coop_finance_subsi_equity;

CREATE TABLE coop_finance_subsi_equity
(
  entry_type character varying(1),
  amount double precision,
  date_posted date,
  particular_code character varying,
  equi_postnum serial NOT NULL,
  record_num integer NOT NULL,
  CONSTRAINT coop_finance_subsi_equity_pkey PRIMARY KEY (equi_postnum, record_num),
  CONSTRAINT coop_finance_subsi_equity_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_subsi_equity
  OWNER TO postgres;

-- Table: coop_finance_subsi_expenses

-- DROP TABLE coop_finance_subsi_expenses;

CREATE TABLE coop_finance_subsi_expenses
(
  entry_type character varying(1),
  amount double precision,
  date_posted date,
  particular_code character varying,
  exp_postnum serial NOT NULL,
  record_num integer NOT NULL,
  CONSTRAINT coop_finance_subsi_expenses_pkey PRIMARY KEY (exp_postnum, record_num),
  CONSTRAINT coop_finance_subsi_expenses_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_subsi_expenses
  OWNER TO postgres;

-- Table: coop_finance_subsi_liability

-- DROP TABLE coop_finance_subsi_liability;

CREATE TABLE coop_finance_subsi_liability
(
  entry_type character varying(1),
  amount double precision,
  date_posted date,
  particular_code character varying,
  lia_postnum serial NOT NULL,
  record_num integer NOT NULL,
  CONSTRAINT coop_finance_subsi_liability_pkey PRIMARY KEY (lia_postnum, record_num),
  CONSTRAINT coop_finance_subsi_liability_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_subsi_liability
  OWNER TO postgres;

-- Table: coop_finance_subsi_revenue

-- DROP TABLE coop_finance_subsi_revenue;

CREATE TABLE coop_finance_subsi_revenue
(
  entry_type character varying(1),
  amount double precision,
  date_posted date,
  particular_code character varying,
  rev_postnum serial NOT NULL,
  record_num integer NOT NULL,
  CONSTRAINT coop_finance_subsi_revenue_pkey PRIMARY KEY (rev_postnum, record_num),
  CONSTRAINT coop_finance_subsi_revenue_particular_code_fkey FOREIGN KEY (particular_code)
      REFERENCES coop_finance_coa_particular (particular_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE coop_finance_subsi_revenue
  OWNER TO postgres;
