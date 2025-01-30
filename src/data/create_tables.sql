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
select * 
from working_hours
where start_time::date = CURRENT_DATE;

SELECT * 
FROM working_hours
WHERE start_time::date >= date_trunc('week', CURRENT_DATE)
  AND start_time::date < date_trunc('week', CURRENT_DATE) + INTERVAL '7 days';

DELETE FROM working_hours
WHERE id BETWEEN 3 AND 97;

DELETE FROM working_hours
WHERE consultant_name = 'Mary Doe';

insert into working_hours (start_time, consultant_name, customer_name) values ('2025-01-29 08:00:00', 'John Joku', 'ACME');
insert into working_hours (start_time, end_time, lunch_break, consultant_name, customer_name) values ('2025-01-29 08:00:00', '2025-01-01 12:15:00', '30 minutes', 'Mary Doe', 'ACME');

--Generating fake entries for today
INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-29 07:30:00', '2025-01-29 11:30:00', '30 minutes', 'Alice Smith', 'Customer A'),
    ('2025-01-29 11:30:00', '2025-01-29 15:30:00', NULL, 'Alice Smith', 'Customer B'),
    ('2025-01-29 08:00:00', '2025-01-29 12:00:00', '45 minutes', 'Bob Johnson', 'Customer C'),
    ('2025-01-29 12:00:00', '2025-01-29 16:00:00', NULL, 'Bob Johnson', 'Customer B'),
    ('2025-01-29 07:15:00', '2025-01-29 11:15:00', NULL, 'Carol White', 'Customer E'),
    ('2025-01-29 11:15:00', '2025-01-29 15:15:00', '30 minutes', 'Carol White', 'Customer C'),
    ('2025-01-29 09:00:00', '2025-01-29 13:00:00', '15 minutes', 'David Brown', 'Customer G'),
    ('2025-01-29 13:00:00', '2025-01-29 17:00:00', NULL, 'David Brown', 'Customer H'),
    ('2025-01-29 07:45:00', '2025-01-29 11:45:00', '30 minutes', 'Emma Wilson', 'Customer A'),
    ('2025-01-29 11:45:00', '2025-01-29 15:45:00', NULL, 'Emma Wilson', 'Customer J'),
    ('2025-01-29 08:30:00', '2025-01-29 12:30:00', NULL, 'Franklin Moore', 'Customer K'),
    ('2025-01-29 12:30:00', '2025-01-29 16:30:00', '45 minutes', 'Franklin Moore', 'Customer D'),
    ('2025-01-29 07:20:00', '2025-01-29 11:20:00', '15 minutes', 'Grace Hall', 'Customer M'),
    ('2025-01-29 11:20:00', '2025-01-29 15:20:00', NULL, 'Grace Hall', 'Customer A'),
    ('2025-01-29 08:10:00', '2025-01-29 12:10:00', NULL, 'Henry King', 'Customer O'),
    ('2025-01-29 12:10:00', '2025-01-29 16:10:00', '30 minutes', 'Henry King', 'Customer P'),
    ('2025-01-29 07:40:00', '2025-01-29 11:40:00', '45 minutes', 'Ivy Scott', 'Customer Q'),
    ('2025-01-29 11:40:00', '2025-01-29 15:40:00', NULL, 'Ivy Scott', 'Customer G'),
    ('2025-01-29 08:50:00', '2025-01-29 12:50:00', NULL, 'Jack Lee', 'Customer S'),
    ('2025-01-29 12:50:00', '2025-01-29 16:50:00', '15 minutes', 'Jack Lee', 'Customer D'),
    ('2025-01-29 07:55:00', '2025-01-29 11:55:00', NULL, 'Katherine Adams', 'Customer D'),
    ('2025-01-29 11:55:00', '2025-01-29 15:55:00', '30 minutes', 'Katherine Adams', 'Customer V'),
    ('2025-01-29 08:20:00', '2025-01-29 12:20:00', '30 minutes', 'Leo Nelson', 'Customer W'),
    ('2025-01-29 12:20:00', '2025-01-29 16:20:00', NULL, 'Leo Nelson', 'Customer X'),
    ('2025-01-29 09:10:00', '2025-01-29 13:10:00', NULL, 'Megan Carter', 'Customer Y'),
    ('2025-01-29 13:10:00', '2025-01-29 17:10:00', '45 minutes', 'Megan Carter', 'Customer Z'),
    ('2025-01-29 07:35:00', '2025-01-29 11:35:00', '15 minutes', 'Noah Turner', 'Customer A'),
    ('2025-01-29 11:35:00', '2025-01-29 15:35:00', NULL, 'Noah Turner', 'Customer B');
INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-30 08:10:00', '2025-01-30 12:10:00', NULL, 'Henry King', 'Customer O'),
    ('2025-01-30 12:10:00', '2025-01-30 16:10:00', '30 minutes', 'Henry King', 'Customer P'),
    ('2025-01-30 07:40:00', '2025-01-30 11:40:00', '45 minutes', 'Ivy Scott', 'Customer Q'),
    ('2025-01-30 11:40:00', '2025-01-30 15:40:00', NULL, 'Ivy Scott', 'Customer G'),
    ('2025-01-30 08:50:00', '2025-01-30 12:50:00', NULL, 'Jack Lee', 'Customer S'),
    ('2025-01-30 12:50:00', '2025-01-30 16:50:00', '15 minutes', 'Jack Lee', 'Customer D'),
    ('2025-01-30 07:55:00', '2025-01-30 11:55:00', NULL, 'Katherine Adams', 'Customer D'),
    ('2025-01-30 11:55:00', '2025-01-30 15:55:00', '30 minutes', 'Katherine Adams', 'Customer V'),
    ('2025-01-30 08:20:00', '2025-01-30 12:20:00', '30 minutes', 'Leo Nelson', 'Customer W'),
    ('2025-01-30 12:20:00', '2025-01-30 16:20:00', NULL, 'Leo Nelson', 'Customer X'),
    ('2025-01-30 09:10:00', '2025-01-30 13:10:00', NULL, 'Megan Carter', 'Customer Y'),
    ('2025-01-30 13:10:00', '2025-01-30 17:10:00', '45 minutes', 'Megan Carter', 'Customer Z'),
    ('2025-01-30 07:35:00', '2025-01-30 11:35:00', '15 minutes', 'Noah Turner', 'Customer A'),
    ('2025-01-30 11:35:00', '2025-01-30 15:35:00', NULL, 'Noah Turner', 'Customer B');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-31 07:30:00', '2025-01-31 11:30:00', '30 minutes', 'Alice Smith', 'Customer A'),
    ('2025-01-31 11:30:00', '2025-01-31 15:30:00', NULL, 'Alice Smith', 'Customer B'),
    ('2025-01-31 08:00:00', '2025-01-31 12:00:00', '45 minutes', 'Bob Johnson', 'Customer C'),
    ('2025-01-31 12:00:00', '2025-01-31 16:00:00', NULL, 'Bob Johnson', 'Customer B'),
    ('2025-01-31 07:15:00', '2025-01-31 11:15:00', NULL, 'Carol White', 'Customer E'),
    ('2025-01-31 11:15:00', '2025-01-31 15:15:00', '30 minutes', 'Carol White', 'Customer C'),
    ('2025-01-31 09:00:00', '2025-01-31 13:00:00', '15 minutes', 'David Brown', 'Customer G'),
    ('2025-01-31 13:00:00', '2025-01-31 17:00:00', NULL, 'David Brown', 'Customer H');


INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
values
    ('2025-01-27 08:30:00', '2025-01-27 12:30:00', NULL, 'Franklin Moore', 'Customer K'),
    ('2025-01-27 12:30:00', '2025-01-27 16:30:00', '45 minutes', 'Franklin Moore', 'Customer D'),
    ('2025-01-27 07:20:00', '2025-01-27 11:20:00', '15 minutes', 'Grace Hall', 'Customer M'),
    ('2025-01-27 11:20:00', '2025-01-27 15:20:00', NULL, 'Grace Hall', 'Customer A'),
    ('2025-01-27 08:10:00', '2025-01-27 12:10:00', NULL, 'Henry King', 'Customer O'),
    ('2025-01-27 12:10:00', '2025-01-27 16:10:00', '30 minutes', 'Henry King', 'Customer P'),
    ('2025-01-27 07:40:00', '2025-01-27 11:40:00', '45 minutes', 'Ivy Scott', 'Customer Q'),
    ('2025-01-27 11:40:00', '2025-01-27 15:40:00', NULL, 'Ivy Scott', 'Customer G'),
    ('2025-01-27 08:50:00', '2025-01-27 12:50:00', NULL, 'Jack Lee', 'Customer S'),
    ('2025-01-27 12:50:00', '2025-01-27 16:50:00', '15 minutes', 'Jack Lee', 'Customer D');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
values
    ('2025-01-31 07:45:00', '2025-01-31 11:45:00', '30 minutes', 'Emma Wilson', 'Customer C'),
    ('2025-01-31 11:45:00', '2025-01-31 15:45:00', NULL, 'Emma Wilson', 'Customer A'),
    ('2025-01-31 08:30:00', '2025-01-31 12:30:00', NULL, 'Franklin Moore', 'Customer D'),
    ('2025-01-31 12:30:00', '2025-01-31 16:30:00', '45 minutes', 'Franklin Moore', 'Customer B'),
    ('2025-01-31 07:20:00', '2025-01-31 11:20:00', '15 minutes', 'Grace Hall', 'Customer E'),
    ('2025-01-31 11:20:00', '2025-01-31 15:20:00', NULL, 'Grace Hall', 'Customer F'),
    ('2025-01-31 08:10:00', '2025-01-31 12:10:00', NULL, 'Henry King', 'Customer E'),
    ('2025-01-31 12:10:00', '2025-01-31 16:10:00', '30 minutes', 'Henry King', 'Customer F'),
    ('2025-01-31 07:40:00', '2025-01-31 11:40:00', '45 minutes', 'Ivy Scott', 'Customer C'),
    ('2025-01-31 11:40:00', '2025-01-31 15:40:00', NULL, 'Ivy Scott', 'Customer G'),
    ('2025-01-31 08:50:00', '2025-01-31 12:50:00', NULL, 'Jack Lee', 'Customer E'),
    ('2025-01-31 12:50:00', '2025-01-31 16:50:00', '15 minutes', 'Jack Lee', 'Customer A');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
values
    ('2025-01-31 08:50:00', '2025-01-31 12:50:00', NULL, 'Jack Lee', 'Customer E'),
    ('2025-01-31 12:50:00', '2025-01-31 16:00:00', '15 minutes', 'Jack Lee', 'Customer A');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-29 07:30:00', '2025-01-29 11:30:00', '30 minutes', 'Alice Smith', 'Acme Corp'),
    ('2025-01-29 11:30:00', '2025-01-29 15:30:00', NULL, 'Alice Smith', 'Beta Technologies'),
    ('2025-01-29 08:00:00', '2025-01-29 12:00:00', '45 minutes', 'Bob Johnson', 'Gamma Solutions'),
    ('2025-01-29 12:00:00', '2025-01-29 16:00:00', NULL, 'Bob Johnson', 'Beta Technologies'),
    ('2025-01-29 07:15:00', '2025-01-29 11:15:00', NULL, 'Carol White', 'Eco Innovations'),
    ('2025-01-29 11:15:00', '2025-01-29 15:15:00', '30 minutes', 'Carol White', 'Gamma Solutions'),
    ('2025-01-29 09:00:00', '2025-01-29 13:00:00', '15 minutes', 'David Brown', 'HealthTech Inc.'),
    ('2025-01-29 13:00:00', '2025-01-29 17:00:00', NULL, 'David Brown', 'TechStart'),
    ('2025-01-29 07:45:00', '2025-01-29 11:45:00', '30 minutes', 'Emma Wilson', 'Acme Corp'),
    ('2025-01-29 11:45:00', '2025-01-29 15:45:00', NULL, 'Emma Wilson', 'Juno Enterprises'),
    ('2025-01-29 08:30:00', '2025-01-29 12:30:00', NULL, 'Franklin Moore', 'Kilo Systems'),
    ('2025-01-29 12:30:00', '2025-01-29 16:30:00', '45 minutes', 'Franklin Moore', 'Delta Group'),
    ('2025-01-29 07:20:00', '2025-01-29 11:20:00', '15 minutes', 'Grace Hall', 'Milo Industries'),
    ('2025-01-29 11:20:00', '2025-01-29 15:20:00', NULL, 'Grace Hall', 'Acme Corp'),
    ('2025-01-29 08:10:00', '2025-01-29 12:10:00', NULL, 'Henry King', 'Omega Solutions'),
    ('2025-01-29 12:10:00', '2025-01-29 16:10:00', '30 minutes', 'Henry King', 'Pioneer Tech'),
    ('2025-01-29 07:40:00', '2025-01-29 11:40:00', '45 minutes', 'Ivy Scott', 'Quantum Labs'),
    ('2025-01-29 11:40:00', '2025-01-29 15:40:00', NULL, 'Ivy Scott', 'HealthTech Inc.'),
    ('2025-01-29 08:50:00', '2025-01-29 12:50:00', NULL, 'Jack Lee', 'Sigma Partners'),
    ('2025-01-29 12:50:00', '2025-01-29 16:50:00', '15 minutes', 'Jack Lee', 'Delta Group'),
    ('2025-01-29 07:55:00', '2025-01-29 11:55:00', NULL, 'Katherine Adams', 'Delta Group'),
    ('2025-01-29 11:55:00', '2025-01-29 15:55:00', '30 minutes', 'Katherine Adams', 'Vortex Solutions'),
    ('2025-01-29 08:20:00', '2025-01-29 12:20:00', '30 minutes', 'Leo Nelson', 'Waves Technologies'),
    ('2025-01-29 12:20:00', '2025-01-29 16:20:00', NULL, 'Leo Nelson', 'XenoCorp'),
    ('2025-01-29 09:10:00', '2025-01-29 13:10:00', NULL, 'Megan Carter', 'Yotta Industries'),
    ('2025-01-29 13:10:00', '2025-01-29 17:10:00', '45 minutes', 'Megan Carter', 'ZebraTech'),
    ('2025-01-29 07:35:00', '2025-01-29 11:35:00', '15 minutes', 'Noah Turner', 'Acme Corp'),
    ('2025-01-29 11:35:00', '2025-01-29 15:35:00', NULL, 'Noah Turner', 'Beta Technologies');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-30 08:10:00', '2025-01-30 12:10:00', NULL, 'Henry King', 'Omega Solutions'),
    ('2025-01-30 12:10:00', '2025-01-30 16:10:00', '30 minutes', 'Henry King', 'Pioneer Tech'),
    ('2025-01-30 07:40:00', '2025-01-30 11:40:00', '45 minutes', 'Ivy Scott', 'Quantum Labs'),
    ('2025-01-30 11:40:00', '2025-01-30 15:40:00', NULL, 'Ivy Scott', 'HealthTech Inc.'),
    ('2025-01-30 08:50:00', '2025-01-30 12:50:00', NULL, 'Jack Lee', 'Sigma Partners'),
    ('2025-01-30 12:50:00', '2025-01-30 16:50:00', '15 minutes', 'Jack Lee', 'Delta Group'),
    ('2025-01-30 07:55:00', '2025-01-30 11:55:00', NULL, 'Katherine Adams', 'Delta Group'),
    ('2025-01-30 11:55:00', '2025-01-30 15:55:00', '30 minutes', 'Katherine Adams', 'Vortex Solutions'),
    ('2025-01-30 08:20:00', '2025-01-30 12:20:00', '30 minutes', 'Leo Nelson', 'Waves Technologies'),
    ('2025-01-30 12:20:00', '2025-01-30 16:20:00', NULL, 'Leo Nelson', 'XenoCorp'),
    ('2025-01-30 09:10:00', '2025-01-30 13:10:00', NULL, 'Megan Carter', 'Yotta Industries'),
    ('2025-01-30 13:10:00', '2025-01-30 17:10:00', '45 minutes', 'Megan Carter', 'ZebraTech'),
    ('2025-01-30 07:35:00', '2025-01-30 11:35:00', '15 minutes', 'Noah Turner', 'Acme Corp'),
    ('2025-01-30 11:35:00', '2025-01-30 15:35:00', NULL, 'Noah Turner', 'Beta Technologies');

INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
VALUES
    ('2025-01-31 07:30:00', '2025-01-31 11:30:00', '30 minutes', 'Alice Smith', 'Acme Corp'),
    ('2025-01-31 11:30:00', '2025-01-31 15:30:00', NULL, 'Alice Smith', 'Beta Technologies'),
    ('2025-01-31 08:00:00', '2025-01-31 12:00:00', '45 minutes', 'Bob Johnson', 'Gamma Solutions'),
    ('2025-01-31 12:00:00', '2025-01-31 16:00:00', NULL, 'Bob Johnson', 'Beta Technologies'),
    ('2025-01-31 07:15:00', '2025-01-31 11:15:00', NULL, 'Carol White', 'Eco Innovations'),
    ('2025-01-31 11:15:00', '2025-01-31 15:15:00', '30 minutes', 'Carol White', 'Gamma Solutions'),
    ('2025-01-31 09:00:00', '2025-01-31 13:00:00', '15 minutes', 'David Brown', 'HealthTech Inc.'),
    ('2025-01-31 13:00:00', '2025-01-31 17:00:00', NULL, 'David Brown', 'TechStart');