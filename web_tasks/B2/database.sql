create database task3;

use task3

create table users(
  user_id int(1) auto_increment,
  user_name varchar(25) not null,
  password varchar(25) not null,
  primary key(user_id)
);


create table messages(
  id int(1) auto_increment,
  content varchar(150) not null,
  user_id int not null,
  create_at datetime not null,
  primary key(id)
);
