-- SQL Tables: DDL

create database stackoverflow;

use stackoverflow;

-------------- Version 1 -------------------

-- users table
create table users (
    id int auto_increment,
    display_name varchar(200),
    creation_date datetime not null,
    location varchar(100),
    
    primary key (id)
);


-- Post table
create table posts (
	id int auto_increment,
    post_type int,
    user_id int,
    post_date datetime not null,
    title varchar(1000),
    body text,
    parent_post_id int,
    accepted_post_id int,
    
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (parent_post_id) references posts (id),
    foreign key (accepted_post_id) references posts (id)
);

-- comments table
create table comments (
    id int auto_increment,
    post_id int not null,
    user_id int,
    post_date datetime not null,
    body text,
    
    primary key (id),
    foreign key (post_id) references posts (id),
    foreign key (user_id) references users (id)
);

-- tags
create table tags (
	id int,
    name varchar(50),
    primary key (id)
);

-------------- Relation Tables --------------

-- Notes: 
--  tag_name, question should be unique together
--  can we simply use SET() data type in "question"???
create table posttags (
    post_id int not null,
    tag_id int not null,
    
    primary key (post_id, tag_id),
    foreign key (tag_id) references tags (id),
    foreign key (post_id) references posts (id)
);

create table favs (
    post_id int not null,
    user_id int not null,
    fav_date datetime not null,
    
    primary key (post_id, user_id),
    foreign key (post_id) references posts (id),
    foreign key (user_id) references users (id)
);

-- Its good to have votes numerical.. but strictly -1, 1
create table votes (
    post_id int not null,
    user_id int not null,
    vote_type int not null,
    vote_date datetime not null,
    
    primary key (post_id, user_id),
    foreign key (post_id) references posts (id),
    foreign key (user_id) references users (id)
);


-- ------ Version 2 -------

SET FOREIGN_KEY_CHECKS = 0;

create table questions (
    id int auto_increment,
    post_date datetime not null,
    user_id int,
    title varchar(1000),
    body text,
    accepted_post_id int,
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (accepted_post_id) references answers (id)
);

create table answers (
    id int auto_increment,
    parent_post_id int not null,
    post_date datetime not null,
    user_id int,
    body text,
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (parent_post_id) references questions (id)
);


insert into questions select id,post_date,user_id,title, body, accepted_post_id from posts where post_type=1;
insert into answers select id,parent_post_id,post_date,user_id,body from posts where post_type=2;

SET FOREIGN_KEY_CHECKS = 1;

