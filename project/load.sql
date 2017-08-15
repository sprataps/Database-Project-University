use stackoverflow;

-- users data
LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/users.txt'
INTO TABLE users
FIELDS TERMINATED BY '\t';

-- tags data
LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/tags.txt'
INTO TABLE tags 
FIELDS TERMINATED BY '\t';

-- posts data
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/posts.txt'
INTO TABLE posts 
FIELDS TERMINATED BY '\t';

SET FOREIGN_KEY_CHECKS = 1;
-- comments data
LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/comments.txt'
INTO TABLE comments
FIELDS TERMINATED BY '\t';

-- posttags data
LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/posttags.txt'
INTO TABLE posttags 
FIELDS TERMINATED BY '\t';

-- fav data
ALTER TABLE favs ADD COLUMN `dummy` INT NULL AFTER `user_id`;
COMMIT;

LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/favs.txt'
INTO TABLE favs
FIELDS TERMINATED BY '\t';

ALTER TABLE favs DROP COLUMN `dummy`;
COMMIT;

-- votes data
LOAD DATA LOCAL INFILE '/users/suryak/courses/db-class/project/data/votes.txt'
INTO TABLE votes 
FIELDS TERMINATED BY '\t';

