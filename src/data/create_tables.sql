CREATE TABLE working_hours (
    id SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    lunch_break INTERVAL,
    consultant_name VARCHAR(100) NOT NULL,
    customer_name VARCHAR(100) NOT NULL
);

create or replace function set_end_time() 
returns trigger as $$
begin
    if new.end_time is null then
        new.end_time := new.start_time + INTERVAL '8 hours';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger set_end_time_trigger
before insert on working_hours
for each row
execute function set_end_time();

select * from working_hours;

insert into working_hours (start_time, lunch_break, consultant_name, customer_name) values ('2021-01-01 08:00:00', '30 minutes', 'John Doe', 'ACME');
insert into working_hours (start_time, end_time, lunch_break, consultant_name, customer_name) values ('2021-01-01 08:00:00', '2021-01-01 12:15:00', '30 minutes', 'Mary Doe', 'ACME');