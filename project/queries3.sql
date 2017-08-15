use stackoverflow;

drop procedure if exists question_data; 

delimiter //

create procedure question_data (qid int)

begin 
	-- Get: Title, Body, Post Date, User Name, Date Posted
    -- Number of Votes, Number of Favs
    declare out_id int;
    declare out_post_date datetime;
    declare out_display_name varchar(200);
    declare out_title varchar(1000);
    declare out_body text;
    declare out_fav_count int;
    declare out_vote_count int;
    
	select distinct 
			p1.id 'ID',
			p1.post_date 'Post Date', 
			u.display_name 'Question Author', 
			p1.title 'Title', 
			p1.body 'Body',
            count(v.vote_type) '# Votes'
	into 
		out_id,
		out_post_date,
        out_display_name,
        out_title,
        out_body,
        out_vote_count
	from posts p1
    join users u on u.id = p1.user_id
	join votes v on v.post_id = p1.id
    where p1.id = qid
    ;
    
    -- Get the favs
    select distinct 
		count(*)
    into 
        out_fav_count
    from posts p1
    join favs f on f.post_id = p1.id
    where p1.id = qid
    ;

	-- Show all Question comments
    select c.body 'Comments'
	from posts p1 
    join comments c on p1.id = c.post_id
    where p1.id = qid
    ;
    
    -- Show all Answer votes
    select 
		p2.id 'Answer ID', 
		count(v.vote_type) '# Comments'
    from posts p2
    join votes v on v.post_id = p2.id and p2.parent_post_id = qid
    group by p2.id
    ;
    
    -- Show all comments on all answers
	select
		p.id 'Answer ID',
        c.body 'Comment'
    from posts p join comments c on p.id = c.post_id
    where p.parent_post_id = qid
    ;
    
	-- Display General Results
    select
		out_id 'Question ID',
		out_post_date 'Post Date',
        out_display_name 'Question Author',
        out_title 'Question Title',
        out_body 'Question Body',
        out_vote_count '# Votes',
        out_fav_count '# Favs'
    ;

end //

delimiter ;

call question_data(15376);