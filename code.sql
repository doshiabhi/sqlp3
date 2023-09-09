with running_total as 
(
  select *,
  sum(salary) over (partition by positions order by salary,id) as running_sum
  from candidates
),
senior_cte as 
(
  select count(*) as seniors, coalesce(sum(salary),0) as s_salary  from running_total
  where positions = "senior" and running_sum < 50000
  
 ),
 junior_cte as(
select count(*) as juniors  from running_total
  where positions = "junior" and running_sum < 50000 - (select s_salary from senior_cte))
  select juniors,seniors from junior_cte, senior_cte
  
