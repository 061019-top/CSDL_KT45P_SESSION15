create database if not exists student_management;
use student_management;

create table students (
    student_id varchar(5) primary key,
    full_name varchar(50) not null,
    total_debt decimal(10,2) default 0
);

create table subjects (
    subject_id varchar(5) primary key,
    subject_name varchar(50) not null,
    credits int check (credits > 0)
);

create table grades (
    student_id varchar(5),
    subject_id varchar(5),
    score decimal(4,2) check (score between 0 and 10),
    primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);

create table grade_log (
    log_id int auto_increment primary key,
    student_id varchar(5),
    old_score decimal(4,2),
    new_score decimal(4,2),
    change_date datetime default current_timestamp,
    foreign key (student_id) references students(student_id)
);

insert into students (student_id, full_name, total_debt) values 
('Sv01', 'Nguyen Van A', 5000000),
('Sv03', 'Nguyen Van B', 2000000);

insert into subjects (subject_id, subject_name, credits) values 
('Sub01', 'CSDL', 3),
('Sub02', 'JS', 4);

insert into grades (student_id, subject_id, score) values 
('Sv01', 'Sub01', 8.5),
('Sv01', 'Sub02', 3.0);

delimiter //
create trigger tg_check_score
before insert on grades
for each row
begin
    if new.score < 0 then
        set new.score = 0;
    elseif new.score > 10 then
        set new.score = 10;
    end if;
end //
delimiter ;

start transaction;
insert into students (student_id, full_name, total_debt)
values ('sv02', 'ha bich ngoc', 5000000);
commit;

delimiter //
create trigger tg_log_grade_update
after update on grades
for each row
begin
    if old.score <> new.score then
        insert into grade_log (student_id, old_score, new_score, change_date)
        values (new.student_id, old.score, new.score, now());
    end if;
end //

delimiter ;