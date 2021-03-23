USE crime_data;
#1
SELECT COUNT(DISTINCT(crime_type))
FROM incident_reports;

#2
SELECT crime_type, COUNT(crime_type) as num_crimes
FROM incident_reports
GROUP BY crime_type
ORDER BY crime_type;

#3
SELECT COUNT(incident_number)
FROM incident_reports
WHERE CAST(date_reported AS DATE) = CAST(date_occured AS DATE);

#4
SELECT date_reported, date_occured AS DATE, crime_type, (CAST(date_occured AS YEAR) - CAST(date_reported AS YEAR)) AS time_difference
FROM incident_reports
WHERE (CAST(date_occured AS YEAR) - CAST(date_reported AS YEAR)) >= 1
ORDER BY time_difference DESC;

#5
SELECT count(incident_number) AS num_incidents, CAST(date_occured AS YEAR) AS year
FROM incident_reports
GROUP BY CAST(date_occured AS YEAR)
ORDER BY CAST(date_occured AS YEAR) DESC;

#6
SELECT *
FROM incident_reports
WHERE crime_type = 'ROBBERY';

#7
SELECT lmpd_division, incident_number, date_occured
FROM incident_reports
WHERE crime_type='ROBBERY'
ORDER BY lmpd_division, date_occured;

#8
SELECT date_occured, crime_type
FROM incident_reports
WHERE zip_code = 40202
ORDER BY crime_type, date_occured;

#9
SELECT zip_code, COUNT(incident_number) AS num_thefts
FROM incident_reports
WHERE crime_type = 'MOTOR VEHICLE THEFT'
GROUP BY zip_code
ORDER BY num_thefts DESC;
#41 results
#zip_code 40214 had the most with 4566 thefts

#10
SELECT COUNT(DISTINCT(CITY))
FROM incident_reports;

#11
SELECT city, COUNT(incident_number) as num_incidents
FROM incident_reports
GROUP BY city
ORDER BY num_incidents DESC;
#LVIL is the second highest city in incidents reported. But this is likely an abbreviation
#for louisville. So LYNDON is likely the actual second highest at 4898 incidents reported.
# There are several abbreviations and missplled cities farther down the list 
#(e.g., LYND probably = LYNDON, LOUSVILLE = LOUISVILLE, etc.)

#12
SELECT uor_desc, crime_type
FROM incident_reports
WHERE crime_type NOT IN('OTHER')
ORDER BY uor_desc, crime_type;
#UOR code appears to be more detailed descriptions of the crime.
#It also appears as though several different UOR codes can correspond to one crime
#type, which would make the UOR codes a subset of the crime_type.

#13 
SELECT COUNT(lmpd_beat)
FROM incident_reports;

#Not sure if you wanted distinct lmpd beats, or total. 
SELECT COUNT(DISTINCT(lmpd_beat))
FROM incident_reports;

#14
SELECT COUNT(offense_code)
FROM nibrs_codes;

#15
SELECT COUNT(DISTINCT(nibrs_code))
FROM incident_reports;

#16
SELECT date_occured, block_address, zip_code, offense_description
FROM incident_reports, nibrs_codes
WHERE nibrs_code = offense_code AND nibrs_code in (240, 250, 270, 280)
ORDER BY block_address;

#17
SELECT zip_code, offense_against
FROM incident_reports, nibrs_codes
WHERE nibrs_code = offense_code AND LENGTH(zip_code) >= 5 AND offense_against NOT IN('')
ORDER BY zip_code;

#18
SELECT offense_against, COUNT(incident_number)
FROM nibrs_codes, incident_reports
WHERE nibrs_code = offense_code AND offense_against NOT IN ('')
GROUP BY offense_against
ORDER BY offense_against;

#19 Amount of crimes in a residence in each year (over 100 crimes only)
SELECT COUNT(incident_number) AS num_crimes, CAST(date_occured AS YEAR) AS year
FROM incident_reports
WHERE premise_type IN('RESIDENCE / HOME')
GROUP BY year
HAVING num_crimes > 100
ORDER BY year DESC;

#Clue Accusations (I was going to use this for #19, but didn't know if 
#CONCAT was an aggregate function).
SELECT pkey, CONCAT('I accuse the suspect of committing ', crime_type, ' in the ', premise_type) AS clue_accusation
FROM incident_reports
HAVING pkey >= 1388931;

#20
#Finding out all the crimes on my birthday last year! :)
SELECT city, premise_type, offense_category
FROM incident_reports, nibrs_codes
WHERE nibrs_code = offense_code 
AND CAST(date_occured AS DATE) = '2020-12-03' 
AND offense_category NOT IN('');

