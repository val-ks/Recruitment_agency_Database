--Create all tables for the relational model you created while studying DB Basics module (fixed model in 3nf). 
--Create a separate database for them and give it appropriate domain-related name. 
--Make sure you choose optimal datatype for each column. 
--Use NOT NULL constraints, default values and generated columns where appropriate.
--Create all table relationships with primary and foreign keys.
--Create at least 5 check constraints, not considering unique and not null, on your tables (in total 5, not for each table).


--if you need to create separate db - uncomment the row below 
--CREATE DATABASE recruitment_agency; 

CREATE SCHEMA IF NOT EXISTS recruitment_data; --then creating schema

SET search_path TO recruitment_data; --setting the search path for our new schema

CREATE TABLE IF NOT EXISTS recruitment_data.industry ( --creating table and checking if it already exists
	industry_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc       
    description TEXT NOT NULL, --using text for big descriptions 
    CONSTRAINT PK_industry_industry_ID PRIMARY KEY (industry_id) --using this constraint to define PK
);

CREATE TABLE IF NOT EXISTS recruitment_data.salary (--creating table and checking if it already exists
	salary_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    amount NUMERIC NOT NULL, --using numeric with float numbers
    currency VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    CONSTRAINT PK_salary_salary_ID PRIMARY KEY (salary_id) --using this constraint to define PK
);

CREATE TABLE IF NOT EXISTS recruitment_data.skill_set (--creating table and checking if it already exists
	skill_set_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    description TEXT NOT NULL, --using text for big descriptions
    CONSTRAINT PK_skill_set_skill_set_ID PRIMARY KEY (skill_set_id) --using this constraint to define PK
);

CREATE TABLE IF NOT EXISTS recruitment_data.education (--creating table and checking if it already exists
	education_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    degree VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    institution VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    date_obtained DATE NOT NULL, --using date where we don't need to add time
    CONSTRAINT PK_education_education_ID PRIMARY KEY (education_id), --using this constraint to define PK
    CONSTRAINT degree_choose CHECK (degree IN ('High School', 'Associate', 'Bachelor', 'Master', 'Doctorate')) --I added this check to clarify exact degree of candidate
);

CREATE TABLE IF NOT EXISTS recruitment_data.address ( --creating table and checking if it already exists
	address_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    street VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    city VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    state VARCHAR(50), --I didn't restricted BY NOT NULL because not every country has state or its equivalent
    country VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    postal_code VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc 
    CONSTRAINT PK_address_address_ID PRIMARY KEY (address_id) --using this constraint to define PK
);

CREATE TABLE IF NOT EXISTS recruitment_data.resume (--creating table and checking if it already exists
	resume_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    title VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    work_experience VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    date_submitted DATE NOT NULL DEFAULT CURRENT_DATE, --I used here default constraint to fill the date automatically
    education_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT PK_resume_resume_ID PRIMARY KEY (resume_id), --using this constraint to define PK
    CONSTRAINT FK_resume_education_ID FOREIGN KEY (education_id) REFERENCES recruitment_data.education(education_id) --using this constraint to define FK 
    ON DELETE RESTRICT ON UPDATE CASCADE --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.resume_skill ( --creating table and checking if it already exists
skill_set_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
resume_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_resume_skill_resume_skill_ID PRIMARY KEY (skill_set_id,
resume_id), --this is a bridge table, so there are two PK/FK
	CONSTRAINT FK_resume_skill_skill_set_ID FOREIGN KEY (skill_set_id) REFERENCES recruitment_data.skill_set(skill_set_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE, --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_resume_skill_resume_ID FOREIGN KEY (resume_id) REFERENCES recruitment_data.resume(resume_id)  --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.candidate (--creating table and checking if it already exists
	candidate_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    first_name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    last_name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    full_name VARCHAR(50) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED, --I've made one generated table here for convinience
    email VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    resume_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    address_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT chk_candidate_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'), --to check email valid signs
    CONSTRAINT PK_candidate_candidate_ID PRIMARY KEY (candidate_id), --using this constraint to define PK
    CONSTRAINT FK_candidate_resume_ID FOREIGN KEY (resume_id) REFERENCES recruitment_data.resume(resume_id)   --using this constraint to define FK
    ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE, --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_candidate_address_ID FOREIGN KEY (address_id) REFERENCES recruitment_data.address(address_id)  --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.company ( --creating table and checking if it already exists
	company_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    email VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    phone VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    contact_person VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    address_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT PK_company_company_ID PRIMARY KEY (company_id), --using this constraint to define PK
    CONSTRAINT FK_company_address_ID FOREIGN KEY (address_id) REFERENCES recruitment_data.address(address_id)  --using this constraint to define FK
    ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.interviewer (--creating table and checking if it already exists
	interviewer_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    first_name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    last_name VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    email VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    phone_number VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    CONSTRAINT PK_interviewer_interviewer_ID PRIMARY KEY (interviewer_id) --using this constraint to define PK
 );

CREATE TABLE IF NOT EXISTS recruitment_data.feedback (--creating table and checking if it already exists
	feedback_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    comments TEXT NOT NULL, --using text for big descriptions
    rating INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    interviewer_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT rating_numbers CHECK (rating >= 1
	AND rating <= 5), --I made this check to specify that we can only give points from 1 to 5
    CONSTRAINT PK_feedback_feedback_ID PRIMARY KEY (feedback_id), --using this constraint to define PK
    CONSTRAINT FK_feedback_interviewer_ID FOREIGN KEY (interviewer_id) REFERENCES recruitment_data.interviewer(interviewer_id)  --using this constraint to define FK
    ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.job_posting (--creating table and checking if it already exists
	job_posting_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    job_title VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    description TEXT NOT NULL, --using text for big descriptions
    address_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    company_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    industry_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    salary_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT PK_job_posting_job_posting_ID PRIMARY KEY (job_posting_id), --using this constraint to define PK
		CONSTRAINT FK_job_posting_company_ID FOREIGN KEY (company_id) REFERENCES recruitment_data.company(company_id)  --using this constraint to define FK
		ON
DELETE
			RESTRICT ON
	UPDATE
				CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
				CONSTRAINT FK_job_posting_industry_ID FOREIGN KEY (industry_id) REFERENCES recruitment_data.industry(industry_id)  --using this constraint to define FK
				ON
		DELETE
					RESTRICT ON
			UPDATE
						CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
						CONSTRAINT FK_job_posting_salary_ID FOREIGN KEY (salary_id) REFERENCES recruitment_data.salary(salary_id)  --using this constraint to define FK
						ON
				DELETE
							RESTRICT ON
					UPDATE
								CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
    );

CREATE TABLE IF NOT EXISTS recruitment_data.job_posting_skill (--creating table and checking if it already exists
	skill_set_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	job_posting_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_job_posting_skill_ID PRIMARY KEY (job_posting_id,
skill_set_id), --using this constraint to define PK
	CONSTRAINT FK_job_posting_skill_skill_set_ID FOREIGN KEY (skill_set_id) REFERENCES recruitment_data.skill_set(skill_set_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_job_posting_skill_job_posting_ID FOREIGN KEY (job_posting_id) REFERENCES recruitment_data.job_posting(job_posting_id) --using this constraint to define FK 
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.job_posting_candidate (--creating table and checking if it already exists
	job_posting_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	candidate_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_job_posting_candidate_ID PRIMARY KEY (job_posting_id,
candidate_id), --using this constraint to define PK
	CONSTRAINT FK_job_posting_candidate_candidate_ID FOREIGN KEY (candidate_id) REFERENCES recruitment_data.candidate(candidate_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_job_posting_candidate_job_posting_ID FOREIGN KEY (job_posting_id) REFERENCES recruitment_data.job_posting(job_posting_id) --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.interview (--creating table and checking if it already exists
	interview_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    date TIMESTAMP NOT NULL, --this data type gives exact time for intrview
    feedback_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT interview_date_validity CHECK (date >= CURRENT_DATE), --I added this constraint to define the date not in past
    CONSTRAINT PK_intrview_interview_ID PRIMARY KEY (interview_id), --using this constraint to define PK
    CONSTRAINT FK_interview_feedback_ID FOREIGN KEY (feedback_id) REFERENCES recruitment_data.feedback(feedback_id)  --using this constraint to define FK
    ON
DELETE
			RESTRICT ON
	UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.interview_interviewer (--creating table and checking if it already exists
	interview_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	interviewer_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_interview_interviewer_ID PRIMARY KEY (interview_id,
interviewer_id), --using this constraint to define PK
	CONSTRAINT FK_interview_interviewer_interviewer_ID FOREIGN KEY (interviewer_id) REFERENCES recruitment_data.interviewer(interviewer_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_interview_interviewer_interview_ID FOREIGN KEY (interview_id) REFERENCES recruitment_data.interview(interview_id) --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.interview_candidate (--creating table and checking if it already exists
	interview_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	candidate_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_interview_candidate_ID PRIMARY KEY (interview_id,
candidate_id), --using this constraint to define PK
	CONSTRAINT FK_interview_candidate_candidate_ID FOREIGN KEY (candidate_id) REFERENCES recruitment_data.candidate(candidate_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE, --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_interview_candidate_interview_ID FOREIGN KEY (interview_id) REFERENCES recruitment_data.interview(interview_id)  --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.contract (--creating table and checking if it already exists
	contract_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    contract_type VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    duration VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    start_date date NOT NULL, --using date as we need only date without time
    CONSTRAINT PK_contract_contract_ID PRIMARY KEY (contract_id), --using this constraint to define PK
    CONSTRAINT future_start_date CHECK (start_date > now()) --to get it started in the future
);

CREATE TABLE IF NOT EXISTS recruitment_data.job_offer (--creating table and checking if it already exists
	job_offer_id SERIAL4 NOT NULL, --using serial4 for ids to automatically generate them
    title VARCHAR(50) NOT NULL, --using varchar for naming, headers and etc
    company_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    salary_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    contract_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
    CONSTRAINT PK_job_offer_job_offer_ID PRIMARY KEY (job_offer_id), --using this constraint to define PK
    CONSTRAINT FK_job_offer_company_ID FOREIGN KEY (company_id) REFERENCES recruitment_data.company(company_id)  --using this constraint to define FK
    ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_job_offer_salary_ID FOREIGN KEY (salary_id) REFERENCES recruitment_data.salary(salary_id)  --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE, --means that data in both tables will be updated automatically but deleting will be restricted
				CONSTRAINT FK_job_offer_contract_ID FOREIGN KEY (contract_id) REFERENCES recruitment_data.contract(contract_id)  --using this constraint to define FK
				ON
				DELETE
					RESTRICT ON
					UPDATE
						CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

CREATE TABLE IF NOT EXISTS recruitment_data.job_offer_candidate (--creating table and checking if it already exists
	job_offer_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	candidate_id INT2 NOT NULL, --I used this data type because it suitable when working with small datasets
	CONSTRAINT PK_job_offer_candidate_ID PRIMARY KEY (job_offer_id,
candidate_id), --using this constraint to define PK
	CONSTRAINT FK_job_offer_candidate_candidate_ID FOREIGN KEY (candidate_id) REFERENCES recruitment_data.candidate(candidate_id)  --using this constraint to define FK
	ON
DELETE
	RESTRICT ON
	UPDATE
		CASCADE,  --means that data in both tables will be updated automatically but deleting will be restricted
		CONSTRAINT FK_job_offer_candidate_job_offer_ID FOREIGN KEY (job_offer_id) REFERENCES recruitment_data.job_offer(job_offer_id)  --using this constraint to define FK
		ON
		DELETE
			RESTRICT ON
			UPDATE
				CASCADE  --means that data in both tables will be updated automatically but deleting will be restricted
);

--Fill your tables with sample data (create it yourself, 20+ rows total in all tables, make sure each table has at least 2 rows).

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.contract (contract_type,
	duration,
	start_date)
SELECT
	'Full-time',
	'12 months',
	'2023-06-06'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.contract
	WHERE
		contract_type = 'Full-time'
		AND duration = '12 months'
		AND start_date = '2023-06-06'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.contract (contract_type,
	duration,
	start_date)
SELECT
	'Part-time',
	'6 months',
	'2023-07-08'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.contract
	WHERE
		contract_type = 'Part-time'
		AND duration = '6 months'
		AND start_date = '2023-07-08'
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.education (degree,
	institution,
	date_obtained)
SELECT
	'Bachelor',
	'University of XYZ',
	'2018-05-15'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.education
	WHERE
		degree = 'Bachelor'
		AND institution = 'University of XYZ'
		AND date_obtained = '2018-05-15'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.education (degree,
	institution,
	date_obtained)
SELECT
	'Master',
	'College of ABC',
	'2022-06-30'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.education
	WHERE
		degree = 'Master'
		AND institution = 'College of ABC'
		AND date_obtained = '2022-06-30'
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.industry (name,
	description)
SELECT
	'Technology',
	'Companies in the technology sector'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.industry
	WHERE
		name = 'Technology'
		AND description = 'Companies in the technology sector'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.industry (name,
	description)
SELECT
	'Finance',
	'Companies in the finance sector'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.industry
	WHERE
		name = 'Finance'
		AND description = 'Companies in the finance sector'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.interviewer (first_name,
	last_name,
	email,
	phone_number)
SELECT
	'John',
	'Doe',
	'johndoe@example.com',
	'555-1234'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interviewer
	WHERE
		first_name = 'John'
		AND last_name = 'Doe'
		AND email = 'johndoe@example.com'
		AND phone_number = '555-1234'
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interviewer (first_name,
	last_name,
	email,
	phone_number)
SELECT
	'Jane',
	'Doe',
	'janedoe@example.com',
	'555-5678'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interviewer
	WHERE
		first_name = 'Jane'
		AND last_name = 'Doe'
		AND email = 'janedoe@example.com'
		AND phone_number = '555-5678'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.salary (amount,
	currency)
SELECT
	50000,
	'USD'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.salary
	WHERE
		amount = 50000
		AND currency = 'USD'
);

INSERT --inserting data using SELECT and checking if it already exists 

	INTO
	recruitment_data.salary (amount,
	currency)
SELECT
	60000,
	'EUR'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.salary
	WHERE
		amount = 60000
		AND currency = 'EUR'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.skill_set (name,
	description)
SELECT
	'Java',
	'Proficiency in Java programming language'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.skill_set
	WHERE
		name = 'Java'
		AND description = 'Proficiency in Java programming language'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.skill_set (name,
	description)
SELECT
	'Python',
	'Experience with Python scripting language'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.skill_set
	WHERE
		name = 'Python'
		AND description = 'Experience with Python scripting language'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'123 Main St',
	'New York',
	'NY',
	'USA',
	'10001'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '123 Main St'
		AND a.city = 'New York'
		AND a.state = 'NY'
		AND a.country = 'USA'
		AND a.postal_code = '10001'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'456 Elm St',
	'Los Angeles',
	'CA',
	'USA',
	'90001'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '456 Elm St'
		AND a.city = 'Los Angeles'
		AND a.state = 'CA'
		AND a.country = 'USA'
		AND a.postal_code = '90001'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'45 Rue de la Pompe',
	'Paris',
	'Île-de-France',
	'France',
	'75116'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '45 Rue de la Pompe'
		AND a.city = 'Paris'
		AND a.state = 'Île-de-France'
		AND a.country = 'France'
		AND a.postal_code = '75116'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'789 Bay St',
	'Toronto',
	'Ontario',
	'Canada',
	'M5J 2N8'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '789 Bay St'
		AND a.city = 'Toronto'
		AND a.state = 'Ontario'
		AND a.country = 'Canada'
		AND a.postal_code = 'M5J 2N8'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'23 Rue de la Paix',
	'Paris',
	NULL,
	'France',
	'75001'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '23 Rue de la Paix'
		AND a.city = 'Paris'
		AND a.country = 'France'
		AND a.postal_code = '75001'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.address (street,
	city,
	state,
	country,
	postal_code)
SELECT
	'23 Ivereli St',
	'Tbilisi',
	NULL,
	'Georgia',
	'10101'
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.address a
	WHERE
		a.street = '23 Ivereli St'
		AND a.city = 'Tbilisi'
		AND a.country = 'Georgia'
		AND a.postal_code = '10101'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.resume (title,
	work_experience,
	date_submitted,
	education_id)
SELECT
	'Software Developer',
	'3 years',
	'2022-04-30',
	e.education_id
FROM
	recruitment_data.education e
WHERE
	e.degree = 'Bachelor'
	AND e.institution = 'University of XYZ'
	AND e.date_obtained = '2018-05-15'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.resume r
	WHERE
		r.title = 'Software Developer'
		AND r.work_experience = '3 years'
		AND r.date_submitted = '2022-04-30'
		AND r.education_id = e.education_id 
  );

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.resume (title,
	work_experience,
	date_submitted,
	education_id)
SELECT
	'Software Engineer',
	'5 years',
	'2023-01-01',
	e.education_id
FROM
	recruitment_data.education e
WHERE
	e.degree = 'Master'
	AND e.institution = 'College of ABC'
	AND e.date_obtained = '2022-06-30'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.resume r
	WHERE
		r.title = 'Software Engineer'
		AND r.work_experience = '5 years'
		AND r.date_submitted = '2023-01-01'
		AND r.education_id = e.education_id 
  );

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.feedback (comments,
	rating,
	interviewer_id)
SELECT
	'Great candidate!',
	5,
	i.interviewer_id
FROM
	recruitment_data.interviewer i
WHERE
	i.first_name = 'John'
	AND i.last_name = 'Doe'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.feedback
	WHERE
		comments = 'Great candidate!'
		AND rating = 5
		AND interviewer_id = i.interviewer_id 
  );

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.feedback (comments,
	rating,
	interviewer_id)
SELECT
	'Poor communication skills',
	2,
	i.interviewer_id
FROM
	recruitment_data.interviewer i
WHERE
	i.first_name = 'Jane'
	AND i.last_name = 'Doe'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.feedback
	WHERE
		comments = 'Poor communication skills'
		AND rating = 2
		AND interviewer_id = i.interviewer_id 
  );

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.candidate (first_name,
	last_name,
	email,
	resume_id,
	address_id)
SELECT
	'El',
	'Smith',
	'elsmith@gmail.com',
	r.resume_id,
	a.address_id
FROM
	recruitment_data.resume r
JOIN recruitment_data.address a ON
	a.postal_code = '10101'
WHERE
	r.title = 'Software Engineer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.candidate c
	WHERE
		c.first_name = 'El'
		AND c.last_name = 'Smith'
		AND c.email = 'elsmith@gmail.com'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.candidate (first_name,
	last_name,
	email,
	resume_id,
	address_id)
SELECT
	'Anna',
	'Smith',
	'annasmith@gmail.com',
	r.resume_id,
	a.address_id
FROM
	recruitment_data.resume r
JOIN recruitment_data.address a ON
	a.postal_code = '10001'
WHERE
	r.title = 'Software Developer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.candidate
	WHERE
		first_name = 'Anna'
		AND last_name = 'Smith'
		AND email = 'annasmith@gmail.com'
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.company (name,
	email,
	phone,
	contact_person,
	address_id)
SELECT
	'Acme Inc.',
	'contact@acme.com',
	'599-1234',
	'Elisa Taylor',
	a.address_id
FROM
	recruitment_data.address a
WHERE
	a.postal_code = '75001'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.company
	WHERE
		name = 'Acme Inc.'
		AND email = 'contact@acme.com' 
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.company (name,
	email,
	phone,
	contact_person,
	address_id)
SELECT
	'Alias Inc.',
	'contact@alias.com',
	'394-1234',
	'Georgi Blade',
	a.address_id
FROM
	recruitment_data.address a
WHERE
	a.postal_code = 'M5J 2N8'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.company
	WHERE
		name = 'Alias Inc.'
		AND email = 'contact@alias.com' 
);

INSERT --inserting data using SELECT and checking if it already exists 
	INTO
	recruitment_data.interview (date,
	feedback_id)
SELECT
	'2023-05-21 9:30:00',
	f.feedback_id
FROM
	recruitment_data.feedback f
INNER JOIN recruitment_data.interviewer i ON
	f.interviewer_id = i.interviewer_id
WHERE
	i.email = 'johndoe@example.com'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview
	WHERE
		date = '2023-05-21 9:30:00'
		AND feedback_id = f.feedback_id
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interview (date,
	feedback_id)
SELECT
	'2023-06-25 10:30:00',
	f.feedback_id
FROM
	recruitment_data.feedback f
INNER JOIN recruitment_data.interviewer i ON
	f.interviewer_id = i.interviewer_id
WHERE
	i.email = 'janedoe@example.com'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview
	WHERE
		date = '2023-06-25 10:30:00'
		AND feedback_id = f.feedback_id
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_offer (title,
	company_id,
	salary_id,
	contract_id)
SELECT
	'Software Developer',
	c.company_id,
	s.salary_id,
	co.contract_id
FROM
	recruitment_data.company c
JOIN recruitment_data.salary s ON
	s.amount = 60000
	AND s.currency = 'EUR'
JOIN recruitment_data.contract co ON
	co.contract_type = 'Part-time'
	AND co.duration = '6 months'
WHERE
	c.email = 'contact@alias.com'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_offer
	WHERE
		title = 'Software Developer'
		AND company_id = c.company_id
		AND salary_id = s.salary_id
		AND contract_id = co.contract_id
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_offer (title,
	company_id,
	salary_id,
	contract_id)
SELECT
	'Software Engineer',
	c.company_id,
	s.salary_id,
	co.contract_id
FROM
	recruitment_data.company c
JOIN recruitment_data.salary s ON
	s.amount = 50000
	AND s.currency = 'USD'
JOIN recruitment_data.contract co ON
	co.contract_type = 'Full-time'
	AND co.duration = '12 months'
WHERE
	c.email = 'contact@acme.com'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_offer
	WHERE
		title = 'Software Engineer'
		AND company_id = c.company_id
		AND salary_id = s.salary_id
		AND contract_id = co.contract_id
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting (job_title,
	description,
	address_id,
	company_id,
	industry_id,
	salary_id)
SELECT
	'Data Analyst',
	'We are seeking a highly skilled data analyst to join our team and help us make data-driven decisions.',
	a.address_id,
	c.company_id,
	i.industry_id,
	s.salary_id
FROM
	recruitment_data.address a
JOIN recruitment_data.company c ON
	c.email = 'contact@acme.com'
JOIN recruitment_data.industry i ON
	i.name = 'Technology'
JOIN recruitment_data.salary s ON
	s.amount = 50000
	AND s.currency = 'USD'
WHERE
	a.postal_code = '75116'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting
	WHERE
		job_title = 'Data Analyst'
		AND address_id = a.address_id
		AND company_id = c.company_id
		AND industry_id = i.industry_id
		AND salary_id = s.salary_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting (job_title,
	description,
	address_id,
	company_id,
	industry_id,
	salary_id)
SELECT
	'Software Engineer',
	'We are seeking a talented software engineer to join our team...',
	a.address_id,
	c.company_id,
	i.industry_id,
	s.salary_id
FROM
	recruitment_data.address a
JOIN recruitment_data.company c ON
	c.email = 'contact@alias.com'
JOIN recruitment_data.industry i ON
	i.name = 'Technology'
JOIN recruitment_data.salary s ON
	s.amount = 60000
	AND s.currency = 'EUR'
WHERE
	a.postal_code = '90001'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting
	WHERE
		job_title = 'Software Engineer'
		AND address_id = a.address_id
		AND company_id = c.company_id
		AND industry_id = i.industry_id
		AND salary_id = s.salary_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interview_candidate (interview_id,
	candidate_id)
SELECT
	i.interview_id,
	c.candidate_id
FROM
	recruitment_data.interview i
JOIN recruitment_data.candidate c ON
	c.email = 'elsmith@gmail.com'
WHERE
	i.date = '2023-05-21 09:30:00'
	AND i.feedback_id = (
	SELECT
		f.feedback_id
	FROM
		recruitment_data.interviewer i2
	INNER JOIN recruitment_data.feedback f ON
		f.interviewer_id = i2.interviewer_id
	WHERE
		i2.email = 'johndoe@example.com')
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview_candidate ic
	WHERE
		ic.interview_id = i.interview_id
		AND ic.candidate_id = c.candidate_id
	);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interview_candidate (interview_id,
	candidate_id)
SELECT
	i.interview_id,
	c.candidate_id
FROM
	recruitment_data.interview i
JOIN recruitment_data.candidate c ON
	c.email = 'annasmith@gmail.com'
WHERE
	i.date = '2023-06-25 10:30:00'
	AND i.feedback_id = (
	SELECT
		f.feedback_id
	FROM
		recruitment_data.interviewer i2
	INNER JOIN recruitment_data.feedback f ON
		f.interviewer_id = i2.interviewer_id
	WHERE
		i2.email = 'janedoe@example.com')
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview_candidate ic
	WHERE
		ic.interview_id = i.interview_id
		AND ic.candidate_id = c.candidate_id
	);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interview_interviewer 
SELECT
	i.interview_id,
	i2.interviewer_id
FROM
	recruitment_data.interview i
JOIN recruitment_data.interviewer i2 ON
	email = 'janedoe@example.com'
WHERE
	i.date = '2023-06-25 10:30:00'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview_interviewer ii
	WHERE
		ii.interview_id = i.interview_id
		AND ii.interviewer_id = i2.interviewer_id
	);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.interview_interviewer 
SELECT
	i.interview_id,
	i2.interviewer_id
FROM
	recruitment_data.interview i
JOIN recruitment_data.interviewer i2 ON
	email = 'johndoe@example.com'
WHERE
	i.date = '2023-05-21 09:30:00'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.interview_interviewer ii
	WHERE
		ii.interview_id = i.interview_id
		AND ii.interviewer_id = i2.interviewer_id
	);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_offer_candidate 
SELECT
	j.job_offer_id,
	c.candidate_id
FROM
	recruitment_data.job_offer j
JOIN recruitment_data.candidate c ON
	c.email = 'elsmith@gmail.com'
WHERE
	j.title = 'Software Engineer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_offer_candidate joc
	WHERE
		joc.job_offer_id = j.job_offer_id
		AND joc.candidate_id = c.candidate_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_offer_candidate 
SELECT
	j.job_offer_id,
	c.candidate_id
FROM
	recruitment_data.job_offer j
JOIN recruitment_data.candidate c ON
	c.email = 'annasmith@gmail.com'
WHERE
	j.title = 'Software Developer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_offer_candidate joc
	WHERE
		joc.job_offer_id = j.job_offer_id
		AND joc.candidate_id = c.candidate_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting_candidate 
SELECT
	j.job_posting_id,
	c.candidate_id
FROM
	recruitment_data.job_posting j
JOIN recruitment_data.candidate c ON
	c.email = 'elsmith@gmail.com'
WHERE
	j.job_title = 'Software Engineer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting_candidate joc
	WHERE
		joc.job_posting_id = j.job_posting_id
		AND joc.candidate_id = c.candidate_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting_candidate 
SELECT
	j.job_posting_id,
	c.candidate_id
FROM
	recruitment_data.job_posting j
JOIN recruitment_data.candidate c ON
	c.email = 'annasmith@gmail.com'
WHERE
	j.job_title = 'Data Analyst'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting_candidate joc
	WHERE
		joc.job_posting_id = j.job_posting_id
		AND joc.candidate_id = c.candidate_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting_skill (job_posting_id,
	skill_set_id)
SELECT
	jp.job_posting_id,
	s.skill_set_id
FROM
	recruitment_data.job_posting jp
JOIN recruitment_data.skill_set s ON
	s.name = 'Python'
WHERE
	jp.job_title = 'Data Analyst'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting_skill jps
	WHERE
		jps.job_posting_id = jp.job_posting_id
		AND jps.skill_set_id = s.skill_set_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.job_posting_skill (job_posting_id,
	skill_set_id)
SELECT
	j.job_posting_id,
	ss.skill_set_id
FROM
	recruitment_data.job_posting j
JOIN recruitment_data.skill_set ss ON
	ss.name = 'Java'
WHERE
	j.job_title = 'Software Engineer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.job_posting_skill
	WHERE
		job_posting_id = j.job_posting_id
		AND skill_set_id = ss.skill_set_id  
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.resume_skill (resume_id,
	skill_set_id)
SELECT
	r.resume_id,
	s.skill_set_id
FROM
	recruitment_data.resume r
JOIN recruitment_data.skill_set s ON
	s.name = 'Java'
WHERE
	r.title = 'Software Engineer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.resume_skill rs
	WHERE
		rs.resume_id = r.resume_id
		AND rs.skill_set_id = s.skill_set_id 
);

INSERT --inserting data using SELECT and checking if it already exists
	INTO
	recruitment_data.resume_skill (resume_id,
	skill_set_id)
SELECT
	r.resume_id,
	s.skill_set_id
FROM
	recruitment_data.resume r
JOIN recruitment_data.skill_set s ON
	s.name = 'Python'
WHERE
	r.title = 'Software Developer'
	AND NOT EXISTS (
	SELECT
		*
	FROM
		recruitment_data.resume_skill rs
	WHERE
		rs.resume_id = r.resume_id
		AND rs.skill_set_id = s.skill_set_id 
);

--Alter all tables and add 'record_ts' field to each table. Make it not null and set its default value to current_date.
--Check that the value has been set for existing rows.


--adding column to every table with checking if it exists and with adding default value 
ALTER TABLE recruitment_data.address ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.company ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.contract ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.candidate ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.education ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.resume ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.salary ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.industry ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.job_offer ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.job_posting ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.skill_set ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.feedback ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.interview ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.job_posting_candidate ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.job_posting_skill ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.resume_skill ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.interview_candidate ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.interview_interviewer ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.interviewer ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE recruitment_data.job_offer_candidate ADD COLUMN IF NOT EXISTS record_ts DATE NOT NULL DEFAULT CURRENT_DATE;
