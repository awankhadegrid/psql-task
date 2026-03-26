--table creation

CREATE TABLE continent (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    population BIGINT,
    area DOUBLE PRECISION,
    continent_id INT,
    FOREIGN KEY (continent_id) REFERENCES continent(id)
);


CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE person_country (
    person_id INT,
    country_id INT,
    PRIMARY KEY (person_id, country_id),
    FOREIGN KEY (person_id) REFERENCES people(id),
    FOREIGN KEY (country_id) REFERENCES country(id)
);

-- Adding data into table

INSERT INTO continent (name) VALUES
('Asia'),
('Europe'),
('Africa'),
('North America'),
('South America');

INSERT INTO country (name, population, area, continent_id) VALUES
('India', 1400000000, 3287263, 1),
('China', 1440000000, 9596961, 1),
('Germany', 83000000, 357022, 2),
('France', 67000000, 551695, 2),
('Nigeria', 220000000, 923768, 3),
('USA', 331000000, 9833517, 4),
('Brazil', 212000000, 8515767, 5),
('Fiji', 900000, 18274, 1),
('Finland', 5500000, 338455, 2),
('Norway', 5400000, 385207, 2);

INSERT INTO people (name) VALUES
('John'),
('Alice'),
('Bob'),
('John'),
('Emma'),
('Liam');

INSERT INTO person_country VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(3, 4),
(4, 5),
(5, 6);

-- printing all tables

select * from continent;
select * from country;
select * from people;
select * from person_country;


--Country Queries

--  Country with biggest population
select id,name from country where population = (select max(population) from country);

-- Top 10 lowest population density
SELECT name from country ORDER BY (population / area) ASC LIMIT 10;

-- Countries with density higher than average
SELECT name from country WHERE (population / area) > (SELECT AVG(population / area) FROM country);

-- Country with longest name
select name from country where LENGTH(name) = (SELECT MAX(LENGTH(name)) FROM country);

-- Countries containing letter 'F'
select name from country where name ilike '%f%';

-- Country + Continent Queries
-- Count countries per continent

select c.name, COUNT(ct.id) AS country_count from continent c left join country ct ON c.id = ct.continent_id GROUP BY c.name;

-- Total area per continent
select c.name, sum(ct.area) AS total_area from continent c join country ct ON c.id = ct.continent_id GROUP BY c.name;

-- average population density per continent
select c.name, AVG(ct.population / ct.area) AS avg_density from continent c join country ct ON c.id = ct.continent_id group by c.name;

--Continents with avg population < 20M
select con.name from continent con join country c on con.id = c.continent_id group by con.name having avg(c.population) < 20000000 ;



--People Queries

--Person with most citizenships
select p.name, COUNT(pc.country_id) AS citizenships FROM people p JOIN person_country pc ON p.id = pc.person_id GROUP BY p.name ORDER BY citizenships DESC LIMIT 1;

--People with no citizenship
select p.name from people p left join person_country pc on p.id = pc.person_id where pc.country_id is null;

--pairs of people with the same name
select  p1.id, p2.id, p1.name from people p1 join people p2 on p1.name = p2.name and p1.id < p2.id;

--update people set name = 'Abhi' where id=1;
--update people set name = 'Ram' where id=2;
--update people set name = 'Sham' where id=3;
--update people set name = 'Radha' where id=4;
--update people set name = 'rani' where id=5;
--update people set name = 'sita' where id=6;
--select * from people;


INSERT INTO people(name) VALUES ('Rahul');

SELECT * FROM people;

UPDATE people SET name = 'Rahul Sharma' WHERE id = 1;

SELECT * FROM country WHERE population > 1000000 ORDER BY name LIMIT 5 OFFSET 0;

