--
-- Copyright 2010-2017 Boxfuse GmbH
--
-- INTERNAL RELEASE. ALL RIGHTS RESERVED.
--

create table EMPLOYEE ( "ID" integer not null, "NAME" varchar(100) );
alter table EMPLOYEE add primary KEY ("ID");

-- Issue #
ALTER TABLE EMPLOYEE ADD COLUMN SYS_START TIMESTAMP(12) NOT NULL GENERATED AS ROW BEGIN IMPLICITLY HIDDEN;
ALTER TABLE EMPLOYEE ADD COLUMN SYS_END TIMESTAMP(12) NOT NULL GENERATED AS ROW END IMPLICITLY HIDDEN;
ALTER TABLE EMPLOYEE ADD COLUMN TRANS_ID TIMESTAMP(12) GENERATED AS TRANSACTION START ID IMPLICITLY HIDDEN;
ALTER TABLE EMPLOYEE ADD PERIOD SYSTEM_TIME (sys_start, sys_end);

CREATE TABLE EMPLOYEE_HIST LIKE EMPLOYEE;

ALTER TABLE EMPLOYEE ADD VERSIONING USE HISTORY TABLE EMPLOYEE_HIST;

create table ADDRESS ( "ID" integer not null, "EMPL_ID" integer not null, "STREET" VARCHAR(250) );
alter TABLE ADDRESS add PRIMARY KEY ("ID");
alter table ADDRESS add CONSTRAINT "EMPL" FOREIGN KEY("ID") REFERENCES "EMPLOYEE" ("ID");

insert into employee values(1, 'Mark');
insert into employee values(2, 'Tommy');

insert into address values(1, 1, 'Street 1');
insert into address values(2, 2, 'Street 2');

create view EMPL as select E.NAME, A.STREET from EMPLOYEE as E, ADDRESS as A where E.ID = A.EMPL_ID;

CREATE table empl_mqt as (SELECT * FROM EMPL) data initially deferred refresh deferred;

set integrity for empl_mqt immediate checked not incremental;