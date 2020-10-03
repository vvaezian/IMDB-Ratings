drop table if exists basics;
create table basics (
	id varchar(15),
	title_type varchar(30),
	primary_title varchar(500),
	original_title varchar(500),
	is_adult int,
	start_Year char(4),
	end_year char(4),
	runtime_minutes int,
	genres varchar(200)
)

drop table if exists episodes;
create table episodes (
	id varchar(15),
	parent_id varchar(15),
	season_number int,
	episode_number int
)

drop table if exists ratings;
create table ratings (
	id varchar(15),
	avg_rating numeric(3, 1),
	num_votes int
)

delete from basics a using basics b
where a.id < b.id
and a.title_type = b.title_type
and a.original_title = b.original_title
and a.start_year = b.start_year
and a.runtime_minute = b.runtime_minute
and a.genres = b.genres


CREATE INDEX idx_original_title ON basics (LOWER(original_title) varchar_pattern_ops)
