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

CREATE INDEX idx_original_title ON basics (LOWER(original_title) varchar_pattern_ops);
create index idx_id_basics on basics (id);
create index idx_id_episodes on episodes (id);
create index idx_parent_id_episodes on episodes (parent_id);
create index idx_id_ratings on ratings (id);

-- SERIES
select a.parent_id "Series ID", a.id "Episode ID", a.season_number "Season", a.episode_number "Episode", b.avg_rating "Rating", b.num_votes "# Votes"
	, c.original_title, primary_title, c.start_year, c.end_year, runtime_minutes, genres
into series
from episodes a 
	join ratings b on a.id = b.id
	join basics c on a.parent_id = c.id and c.title_type in ('tvSeries', 'tvMiniSeries')

CREATE INDEX idx_original_title_series ON series (LOWER(original_title) varchar_pattern_ops);
create index idx_original_title_series2 on series (original_title);

-- MOVIES
select a.id, title_type, original_title, primary_title, start_year, runtime_minutes, genres, avg_rating, num_votes
into movies
from basics a
join ratings b on a.id = b.id
where title_type in ('movie', 'tvMovie')

CREATE INDEX idx_original_title_movies ON movies (LOWER(original_title) varchar_pattern_ops);
create index idx_original_title_movies2 on movies (original_title);

-- there are two rows for every record. we delete of them
-- decided to delete the duplicates on the csv file, because it was more reliable

-- delete from basics 
-- where (ctid::text::point)[1]::int % 2 = 1

-- delete from episodes
-- where (ctid::text::point)[1]::int % 2 = 1

-- delete from ratings
-- where (ctid::text::point)[1]::int % 2 = 1
