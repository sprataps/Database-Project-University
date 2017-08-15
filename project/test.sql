use stackoverflow;

select p.id, count(v.post_id)
    from posts p
    join votes v on p.id = v.post_id
    where p.parent_post_id = 15376
    group by p.id