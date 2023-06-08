CREATE DATABASE murder_mystery;

USE murder_mystery;

--- retrieve corresponding crime scene report as contained in the task
SELECT *
FROM 
	crime_scene_report
WHERE 
	type = 'murder' 
  AND city = 'SQL City'
  AND date = '2018-01-15';


--- check for more information about the witnesses from the person table and the facebook_event_checkin table
SELECT 
	p.name, 
	fec.person_id, 
	fec.date, 
	p.address_street_name,
	fec.event_name
FROM 
	person p
JOIN 
	facebook_event_checkin fec
  ON 
	p.id = fec.person_id
WHERE 
	address_street_name IN ('Northwestern Dr', 'Franklin Ave') 
  AND date = '20180115';


--- query the interview table to read the transcript of testimonies of both witnesses
SELECT *
FROM interview
WHERE person_id in('14887', '16371');


--- to query the driver_license table, person table, and get_fit_now_member table to 
--- find the person that fits the information given by the first witness
SELECT 
	g.person_id, 
	g.id AS membership_id, 
	p.name, 
	d.gender, 
	d.age, 
	g.membership_status, 
	d.plate_number
FROM 
	drivers_license d
JOIN 
	person p
  ON 
    p.license_id = d.id
JOIN 
	get_fit_now_member g
  ON 
    p.id = g.person_id
WHERE 
	g.id LIKE '48Z%' 
  AND d.plate_number LIKE '%H42W%' 
  AND g.membership_status = 'gold';


--- to query the driver_license table, person table, and get_fit_now_member table to 
--- find the person that fits the information given by the second witness
SELECT 
	gf.membership_id, 
	g.person_id, 
	g.name, 
	g.membership_status, gf.check_in_date, gf.check_out_time
FROM 
	get_fit_now_check_in gf
JOIN 
	get_fit_now_member g
	ON gf.membership_id = g.id
WHERE 
	gf.check_in_date = '20180109'
  AND g.person_id IN ('16371', '67318');


--- check if Jeremy Bowler attended the facebook event that were also attended by two witnesses on January 15, 2018
SELECT 
	f.*, 
	p.name
FROM 
	facebook_event_checkin f
JOIN 
	person p
	ON f.person_id = p.id
WHERE 
	f.person_id = '67318' 
  AND f.date = '20180115';


--- query the interview table and the person table to find suspect's transcript of testimony
--- in connection to the murder case
SELECT 
	p.name, 
	i.*
FROM 
	interview i
JOIN 
	person p
	ON i.person_id = p.id
WHERE 
	i.person_id = '67318';


--- probe further to uncover the woman who hired the killer as contained in the killer's testimony
SELECT 
    p.name, 
    f.event_name,
    d.gender, 
    d.age,
    f.date, 
    d.car_make, 
    d.car_model, 
    d.height
FROM 
    drivers_license d
JOIN 
    person p
   ON 
    d.id = p.license_id
JOIN 
    facebook_event_checkin f
  ON 
    f.person_id = p.id
WHERE 
    event_name = 'SQL Symphony Concert' 
  AND (f.date BETWEEN '20171201' AND '20171231') 
  AND d.hair_color = 'red' 
  AND d.car_make = 'Tesla';