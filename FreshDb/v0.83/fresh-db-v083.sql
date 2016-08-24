-- Create a person
set @uid = uuid();

INSERT INTO openmrs.person (gender, birthdate, birthdate_estimated, dead, death_date, cause_of_death, creator, date_created, changed_by, date_changed, voided,
voided_by, date_voided, void_reason, uuid, deathdate_estimated, birthtime) VALUES ('M', null, 0, 0, null, null, 1, now(), null, null, 0, null, null, null, @uid, 0, null);

-- Create a provider with person ID
set @pid = null;

SELECT person_id into @pid from person where uuid = @uid;

INSERT INTO openmrs.person_name (preferred, person_id, prefix, given_name, middle_name, family_name_prefix, family_name, family_name2, family_name_suffix, degree, creator, date_created, voided, voided_by, date_voided, void_reason, changed_by, date_changed, uuid) VALUES (1, @pid, null, 'Super', '', null, 'Man', null, null, null, 1, now(), 0, null, null, null, null, null, uuid());

INSERT INTO openmrs.provider (person_id, name, identifier, creator, date_created, changed_by, date_changed, retired, retired_by, date_retired, retire_reason, uuid, provider_role_id) VALUES (@pid, null, 'SUPERMAN', 1, now(), null, null, 0, null, null, null,uuid(), null);

-- Create a User with person Id

INSERT INTO openmrs.users (system_id, username, password, salt, secret_question, secret_answer, creator, date_created, changed_by, date_changed, person_id, retired, retired_by, date_retired, retire_reason, uuid) VALUES ('SUPERMAN', 'superman', 'fe0f4ff3ef8f1c08e773f44049cb3fc5d7245d05a2def777f6393aad89a1285f67f3664f4df7cf7d04c373960fa4ebb89239be6820b788fe741c83a0c24db644', 'b084dc52f7de4003c536d0c2a6ed3fd0bc10256d0ac5ef69cdd223be5d39d30ea810bb24dfa11ef6b85f778fe4f5e535e1e7bad83c8e8ca0ec09dc0d1c48f9d9', '', null, 1, now(), 1, now(), @pid, 0, null, null, null, uuid());


-- Insert OPD, IPD visit types


INSERT INTO openmrs.visit_type (name, description, creator, date_created, changed_by, date_changed, retired, retired_by, date_retired, retire_reason, uuid) VALUES ('OPD', 'Visit for patients coming for OPD', 1, now(), null, null, 0, null, null, null, uuid());

INSERT INTO openmrs.visit_type (name, description, creator, date_created, changed_by, date_changed, retired, retired_by, date_retired, retire_reason, uuid) VALUES ('IPD', 'Visit for patients coming for IPD', 1, now(), null, null, 0, null, null, null, uuid());

-- Insert a sample Location

set @hospital_uuid = uuid();

set @location_id = null;
set @location_tag_id = null;
set @visit_location_tag_id = null;

INSERT INTO openmrs.location (name, description, address1, address2, city_village, state_province, postal_code, country, latitude, longitude, creator, date_created, county_district, address3, address4, address5, address6, retired, retired_by, date_retired, retire_reason, parent_location, uuid, changed_by, date_changed) VALUES ('Hospital', null, null, null, null, null, null, null, null, null, 1, now(), null, null, null, null, null, 0, null, null, null, null, @hospital_uuid, null, null);

select location_id into @location_id from location where uuid=@hospital_uuid;

SELECT location_tag_id into @location_tag_id from location_tag where name = 'Login Location';

SELECT location_tag_id into @visit_location_tag_id from location_tag where name = 'Visit Location';

INSERT INTO openmrs.location_tag_map values(@location_id,@location_tag_id);

INSERT INTO openmrs.location_tag_map values(@location_id,@visit_location_tag_id);

-- Give Required Privileges to superman
set @superman_id = null;
select  user_id into @superman_id from openmrs.users where username = 'superman';
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Bahmni-User');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Clinical:FullAccess');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Emr-Reports');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Privilege Level: Full');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Provider');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'Registration');
INSERT INTO openmrs.user_role (user_id, role) VALUES (@superman_id, 'System Developer');

-- Give 'Get Locations' Privilege to Anonymous
INSERT INTO openmrs.role_privilege (role, privilege) VALUES ('Anonymous', 'Get Locations');



