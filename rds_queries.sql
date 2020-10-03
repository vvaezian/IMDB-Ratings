create table basics (
	id char(9),
	title_type varchar(30),
	primary_title varchar(200),
	original_title varchar(200),
	is_adult smallint,
	start_Year char(4),
	end_year char(4),
	runtime_minutes smallint,
	genres varchar(200)
)

create table episodes (
	id char(9),
	parent_id char(9),
	season_number smallint,
	episode_number smallint
)

create table ratings (
	id char(9),
	avg_rating numeric(3, 1),
	num_votes int
)
