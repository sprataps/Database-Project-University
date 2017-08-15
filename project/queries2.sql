-- Queries
use stackoverflow;

-- 4.a.i
select distinct 
		p1.id 'ID',
		p1.title 'Title', 
		p1.post_date 'Post Date', 
        u.display_name 'Question Author', 
        count(p2.id) '# Answers',
        count(v.vote_type) '# Votes'
from posttags pt 
join tags t on (pt.tag_id = t.id and t.name = 'java')
join questions p1 ignore index (primary) on p1.id = pt.post_id and p1.accepted_post_id is null
join answers p2 on p2.parent_post_id = p1.id
left outer join users u on u.id = p1.user_id
join votes v on v.post_id = p1.id
group by p1.id
;


-- 4.a.ii
select distinct 
		p1.id 'ID',
		p1.title 'Title', 
		p1.post_date 'Post Date', 
        u.display_name 'Question Author', 
        count(p2.id) '# Answers',
        count(v.vote_type) '# Votes',
        group_concat(distinct t.name separator ',') 'Tags'
from posttags pt
straight_join questions p1 on p1.id = pt.post_id and p1.accepted_post_id is null
join users u on u.id = p1.user_id
join votes v on v.post_id = p1.id
straight_join tags t on pt.tag_id = t.id
straight_join answers p2 use index (parent_post_id) on p1.id = p2.parent_post_id
group by p1.id
order by -p1.post_date
;

-- 4.a.iii
select distinct 
		p1.id 'ID',
		p1.title 'Title', 
		p1.post_date 'Post Date', 
        u.display_name 'Question Author', 
        count(p2.id) '# Answers',
        count(v.vote_type) '# Votes',
        group_concat(distinct t.name separator ',') 'Tags'
from posttags pt
straight_join questions p1 use index (primary) on p1.id = pt.post_id and p1.accepted_post_id is null
join users u on u.id = p1.user_id
straight_join votes v on v.post_id = p1.id
straight_join tags t on pt.tag_id = t.id
straight_join answers p2 use index (parent_post_id) on p1.id = p2.parent_post_id
group by p1.id
order by -count(v.vote_type)
;

-- 4b
set @POST_ID = 15376;

select 
	-- basic stuff
	p1.id 'ID',
    p1.title 'Title',
    p1.post_date 'Post Date',
    p1.body 'Body',
    u1.display_name 'Author',
    
    -- count votes
    (select count(v.post_id) from votes v where v.post_id = p1.id) '# Votes',
    
    -- count favs
    (select count(f.post_id) from favs f where f.post_id = p1.id) '# Favs',
    
    -- Comments
    (select group_concat(c.body separator '\n') 
     from comments c
     where c.post_id = p1.id) 'Comments',
     
	-- Answers, Votes, Comments
    a1.post_id 'Answer ID',
    a1.votes_count 'Answer Votes Count',
    a1.comments 'Answer Comments'

from questions p1
join users u1 on p1.user_id = u1.id
join (
	select 
		-- answer id
        p.id 'post_id',
        
        -- answer votes count
		count(v.post_id) 'votes_count',
        
        -- answer comments
		(select group_concat(c2.body separator '\n') 
		 from comments c2
		 where c2.post_id = p.id) 'comments'
        
    from answers p
    join votes v on p.id = v.post_id
    where p.parent_post_id = @POST_ID
    group by p.id) a1
    

where p1.id = @POST_ID
;