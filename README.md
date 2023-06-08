# SQL-Murder-Mystery

## Introduction
The Structured Query Language (SQL) murder mystery challenge was a second level challenge that i participated in the Data Analysis Super League (DASL), a project-based competition by [Lighthall](https://www.lighthall.co/). The challenge for this level was to solve a murder mystery that took place and figure out the person that committed the crime.

## Task
The task for the challenge is provided below.

> *A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on January 15, 2018 and that it took place in SQL City. Start by retrieving the corresponding crime scene report from the police department’s database.*

The entity relationship diagram (ERD) that shows how the different tables in the database are related is also provided.

![schema](https://github.com/Inemesit1995/SQL-Murder-Mystery/assets/52798222/db36447e-8508-476e-90c6-478f6e736878)

## Investigation
As prescribed in the task, I started my investigation of the crime case by querying the crime scene report, with some key points from the task:

+ The crime was a murder
+ It occurred on January 15, 2018
+ It took place in SQL City

I queried the crime scene report table.

```
SELECT *
FROM 
	crime_scene_report
WHERE 
	type = 'murder' 
  AND city = 'SQL City'
  AND date = '2018-01-15';
  ```
  
  The decription of the murder case from the query is as follows:
  
 > *Security footage shows that there were 2 witnesses. The first witness lives at the last house on **Northwestern Dr**. The second witness, named Annabel, lives somewhere on **Franklin Ave**.*
  
  I went on to learn more information about the witnesses from the ***person*** table and the ***facebook_event_checkin*** table.
  
  ```
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
  ```
  
  The last investigation revealed the names of the two witnesses as ***Morty Schapiro*** and ***Annabel Miller***. They both attended the same Facebook event on the day the murder was committed called ***The Funky Grooves Tour***.
  
  I decided to query the interview table to read the transcript of testimonies of both witnesses.
  
```
SELECT *
FROM interview
WHERE person_id in('14887', '16371');
```

**Morty Schapiro’s** testimony:

> *I heard a gunshot and then saw a man run out. He had a “Get Fit Now Gym” bag. The membership number on the bag started with “48Z”. Only gold members have those bags. The man got into a car with a plate that included “H42W”.*



**Annabel Miller’s** testimony:

> *I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.*

I decided find the person who fits the information that were given by the first witness.

```
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
```

The result of the query based on Morty Schapiro’s testimony shows that the person that fits his description is ***Jeremy Bowler***.

I decided to also probe the testimony of the second witness, Annabel Miller, to confirm if the suspect was at the gym on January 09, 2018.

```
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
 ```
 The result of this query confirms that both Annabel Miller and Jeremy Bowler are gold members of the ***Get Fit Now Gym***, that both of them where at the gym on January 09, 2018, and checked out at the same time.
 
 I decided to conduct two more steps of investigation to help me arrive at a logical conclusion.
 
 Firstly, I decided to check if Jeremy Bowler attended the Facebook event that were also attended by two witnesses on January 15, 2018.
 
 ```
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
 ```
 
 The result of the above query confirms that Jeremy Bowler attended the Facebook event, called “The Funky Grooves Tour” on January 15, 2018.
 
 Secondly, I decided to query the interview table and the person table to see if I would find Jeremy Bowers transcript of testimony in connection to the murder case.
 
 ```
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
 ```
 
 His testimony reads:

> *I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.*


He confessed to committing the murder, but said that he was hired by a woman with a lot of money, whose name he claims not to know.

Based on his description of the woman that hired him, I decided to probe further to uncover the woman who was behind the murder case.

```
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
```

The query from the description of the woman that hired Jeremy Bowler to commit the murder as contained in his testimony, reveals that the woman is 68 years old, named ***Miranda Priestly***.

## Conclusion
The transcript of testimony from the two witnesses played a crucial role in helping me to solve the murder mystery that took place in January 15, 2018. After testing 4 scenarios, I have been able to solve the murder mystery and figure out the person who committed the murder. The killer is ***Jeremy Bowler***, a 30 year old man and a gold member of Get Fit Now Gym. He was hired by a 68 year old woman, named ***Miranda Priestly***.



+ [Medium](https://medium.com/@inemesitumoh/solving-murder-mystery-using-structured-query-language-sql-a0f4c3ed69f9)
+ [LinkedIn](https://www.linkedin.com/in/inemesitumoh/)
+ [Twitter](https://twitter.com/InemesitUmoh95)
