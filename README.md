# SQL project overview
The Bitter Melons project aim is to expand on the current “movies” database which provides a lot of
valuable information about feature films, budget, genres and franchises. The current database is
however static and does not provide any views or triggers for our consumers to engage with. As well
as this, it does not give us much insight into the analytics of engagement from our users. I have
provided this report that has two main pillars to it, the first one is to help drive consumer value, that
being help our users feel like they are not wasting their time trying to find something to watch that
does not fit their profile. The second pillar of this project is to provide for analytics insight so we can
better understand our users.
The original database provides a great starting point as it includes vital normalized tables on
features, genres, budget and gross earnings for feature films. I have designed and added normalized
tables in order to track critic contributions, audience ratings as well as crossing this with genre-based
recommendations on our user’s profiles. Looking at the database design I have adhered to the best
practices used for building and expanding our current schema. I achieved this by making sure all
newly introduced tables are normalised to BCNF. The foreign key relationships are also strictly
enforced across all interactions.
The Bitter Melons project also provides an elegant solution to SQL views, triggers and a stored
procedures which allows us to build out a recommender system, see real-time engagement tracking
and insight into top-performing media outlets. All queries are working and there is an ability to scale
as user engagement increases.
