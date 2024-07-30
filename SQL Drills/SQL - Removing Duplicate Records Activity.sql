create or replace table TECHCATALYST_DE.SPATTURI.fun_facts 
(
id INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
name string,
salary int,
other_id int unique 
);

insert into fun_facts
(name, salary, other_id)
values
('Tarek', 122.5, 123),
('Joe', 90.89, 123),
('Sara', 100, 123),
('Jack', 90.99, 150),
('Tarek', 122.5, 123),
('Joe', 90.89, 123),
('Sara', 100, 123),
('Jack', 90.99, 150);


-- one way to remove duplicate records
delete from fun_facts where id in 
(with cte as
(
    select *,
    row_number() over(partition by name, salary, other_id order by ID) as row_num
    from fun_facts
)
select id from cte where row_num = 1);

-- another way to remove duplicate records
DELETE FROM fun_facts

WHERE id in (

  SELECT id 

  FROM (

      SELECT id

          ,ROW_NUMBER() OVER (PARTITION BY name, salary, other_id ORDER BY id) AS rn

      FROM fun_facts

  )

  WHERE rn > 1

);