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

-- GENRES (Helper Table)
create table genres (
	genre varchar(20)
)

insert into genres 
values ('Action'),('Adventure'),('Animation'),('Biography'),('Comedy'),('Crime'),('Drama')
		,('Family'),('Fantasy'),('Film-Noir'),('History'),('Horror'),('Music'),('Musical')
		,('Mystery'),('Romance'),('Sci-Fi'),('Sport'),('Thriller'),('War'),('Western')
		
-- MOVIES and SERIES
select a.id, title_type,
	case when title_type in ('movie', 'tvMovie') then 'Movie'
		 when title_type in ('tvSeries', 'tvMiniSeries') then 'Series'
	end as item_type,
	original_title, primary_title, start_year, runtime_minutes, genres, avg_rating, num_votes
into movies_series
from source_basics a
join source_ratings b on a.id = b.id
where title_type in ('movie','tvMovie','tvSeries','tvMiniSeries')

create index idx_item_type_movies_series on movies_series (item_type)

-- Series' Episodes
select a.parent_id "Series ID", a.id "Episode ID", a.season_number "Season", a.episode_number "Episode", b.avg_rating "Rating", b.num_votes "# Votes"
  , c.original_title, c.primary_title, d.original_title episode_original_title, d.primary_title episode_title, c.start_year, c.end_year, c.runtime_minutes, c.genres
into series
from source_episodes a 
  join source_ratings b on a.id = b.id
  join source_basics d on a.id = d.id 
  join source_basics c on a.parent_id = c.id

create index idx_primary_title_search on series (lower(primary_title) varchar_pattern_ops);
create index idx_primary_title_filter on series (primary_title);


-- there are two rows for every record. we delete of them
-- (decided to delete the duplicates on the csv file, because it was more reliable)

-- delete from basics 
-- where (ctid::text::point)[1]::int % 2 = 1

-- delete from episodes
-- where (ctid::text::point)[1]::int % 2 = 1

-- delete from ratings
-- where (ctid::text::point)[1]::int % 2 = 1


----------------------
------- Cards --------
----------------------
 
-- Seasons Rating (AVG)
select "Season", avg("Rating") "Rating Average"
from series
where 1 = 1
[[ and {{primary_title}} ]]
[[ and "# Votes" > {{num_votes}} ]]
group by "Season"

-- episodes rating
select case when length(cast("Season" as varchar)) = 1 then case when length(cast("Episode" as varchar)) = 1 then concat('S0', cast("Season" as varchar), 'E0', cast("Episode" as varchar) )
                                                                 else concat('S0', cast("Season" as varchar), 'E', cast("Episode" as varchar) )
                                                            end
            else case when length(cast("Episode" as varchar)) = 1 then concat('S', cast("Season" as varchar), 'E0', cast("Episode" as varchar) )
                      else concat('S', cast("Season" as varchar), 'E', cast("Episode" as varchar) )
                 end
        end as episode_full_name, "Rating"
from series
where "Season" is not Null
and "Episode" is not Null
[[ and {{primary_title}} ]]
[[ and "# Votes" > {{num_votes}} ]]
order by 1
			
-- episodes ranking
select episode_title "Episode Title", "Season", "Episode", "Rating", "# Votes", concat('https://www.imdb.com/title/', "Episode ID") "Link"
from series
where "Season" is not null
and "Episode" is not null
[[ and {{primary_title}} ]]
[[ and "# Votes" > {{num_votes}} ]]
order by "Rating" desc
