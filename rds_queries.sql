drop table if exists basics;
create table basics (
	id varchar(15),
	title_type varchar(30),
	primary_title varchar(500),
	original_title varchar(500),
	is_adult int,
	start_Year int,
	end_year int,
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

-- in basics table and episodes table, there are two rows for every record. we delete of them
delete from basics 
where (ctid::text::point)[1]::int % 1 = 1


CREATE INDEX idx_original_title ON basics (LOWER(original_title) varchar_pattern_ops)
create index idx_id_basics on basics (id);
create index idx_id_episodes on episodes (id);
create index idx_parent_id_episodes on episodes (parent_id);
create index idx_id_ratings on ratings (id);
