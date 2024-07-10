create database etl;

-- EXTRACT  - TRANSFORM - LOAD --
-- extract Female candidates with python > 30%,  sql >50%, ML>20%, Tableau > 40% and excel > 50%
-- Transform the above % as weightage (0~1) SQL ->30% , ML -> 10%, others -> 20% each and add all the skills weightage in new column 
--            Now make new column and update right hiring if the above conditions are met
-- Load the output table into new table "Hiring_Analysis" into same database ETL : Columns -> Gender, Weightage, Decision

-- 1. Exract + Transform  =============================

ALTER TABLE students_etl
rename COLUMN `Sql` to sqll;
with B as 
(
with A as
(
select * from students_etl
where Gender = 'Female' and Python > 0.3 and Sqll>0.5 and ML>0.2 and Tableau > 0.4 and Excel > 0.5
)
select Gender, Python * 0.2 pyt, Sqll*0.3 sq, ML*0.1 ml, Tableau*0.2 tbl, Excel*0.2 xl, 
round((Python * 0.2 + Sqll*0.3 + ML*0.1 + Tableau*0.2 + Excel*0.2),1) as weightage, `Student Placed` as SF from A 
)
select Gender, weightage, 
	case when SF = 'No' then 'wrong_decesion' 
	else 'Right_decesion' 
	end as Decision
from B; 

-- 2. LOAD ===========================================================
create table Hiring_Analysis
(
Gender enum('Male','Female'),
weightage double,
Decision varchar(50)
);
select * from Hiring_Analysis;  -- empty table created 

insert into Hiring_Analysis   -- LOAD operation with above transformation
(Gender, weightage, Decision)
 with B as 
(
with A as
(
select * from students_etl
where Gender = 'Female' and Python > 0.3 and Sqll>0.5 and ML>0.2 and Tableau > 0.4 and Excel > 0.5
)
select Gender, Python * 0.2 pyt, Sqll*0.3 sq, ML*0.1 ml, Tableau*0.2 tbl, Excel*0.2 xl, 
round((Python * 0.2 + Sqll*0.3 + ML*0.1 + Tableau*0.2 + Excel*0.2),1) as weightage, `Student Placed` as SF from A 
)
select Gender, weightage, 
	case when SF = 'No' then 'wrong_decesion' 
	else 'Right_decesion' 
	end as Decision
from B; 

select	* from Hiring_Analysis;