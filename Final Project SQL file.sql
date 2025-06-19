use movies;

-- 1. Outlets Table
CREATE TABLE outlets (
    outlet_id INT AUTO_INCREMENT PRIMARY KEY,
    outlet_name VARCHAR(255) NOT NULL,
    outlet_website VARCHAR(255)
);
-- 2. Critics Table
CREATE TABLE critics (
    critic_id INT AUTO_INCREMENT PRIMARY KEY,
    critic_name VARCHAR(255) NOT NULL,
    is_top_critic BOOLEAN NOT NULL DEFAULT FALSE,
    outlet_id INT,
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
);

-- 3. Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    feature_id INT NOT NULL,   -- connects to your 'features' table
    critic_id INT NOT NULL,    -- connects to the critic who wrote it
    review_date DATE NOT NULL,
    is_positive BOOLEAN NOT NULL,  -- thumbs up/down (1 = positive, 0 = negative)
    star_rating DECIMAL(2,1),       -- optional, like 3.5/5 stars
    FOREIGN KEY (feature_id) REFERENCES features(feature_id),
    FOREIGN KEY (critic_id) REFERENCES critics(critic_id)
);

-- create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE user_preferences (
    user_id INT,
    genre_name VARCHAR(50),
    PRIMARY KEY (user_id, genre_name),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE user_activity_log (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_type VARCHAR(100),  -- e.g., 'browse', 'rate', 'search'
    activity_start DATETIME NOT NULL,
    activity_end DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Audience Reviews
CREATE TABLE audience_reviews (
    audience_review_id INT AUTO_INCREMENT PRIMARY KEY,
    feature_id INT NOT NULL,
    review_date DATE NOT NULL,
    star_rating DECIMAL(2,1) NOT NULL,
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);

ALTER TABLE audience_reviews
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE audience_reviews
ADD COLUMN user_id INT NOT NULL;

-- Sweetness Index View
CREATE VIEW sweetness_index AS
SELECT 
    feature_id,
    ROUND(AVG(CASE WHEN is_positive = TRUE THEN 1 ELSE 0 END) * 100, 2) AS sweetness_percentage
FROM reviews
GROUP BY feature_id;

-- insert statements
INSERT INTO outlets (outlet_name) VALUES
('The New York Times'),
('The Guardian'),
('Rolling Stone'),
('IGN'),
('Variety');

INSERT INTO critics (critic_name, is_top_critic, outlet_id) VALUES
('Ava Reynolds', TRUE, 1),
('Liam Patel', TRUE, 2),
('Sophia Bennett', FALSE, 2),
('Ethan Kim', FALSE, 3),
('Mia Chen', TRUE, 1),
('Noah Scott', FALSE, 4),
('Isabella Moore', FALSE, 5),
('James Walker', TRUE, 5);

INSERT INTO reviews (feature_id, critic_id, review_date, is_positive, star_rating) VALUES
(1, 1, '2025-01-15', TRUE, 4.5),
(1, 2, '2025-01-16', TRUE, 4.0),
(1, 3, '2025-01-17', FALSE, 2.0),
(2, 1, '2025-02-01', TRUE, 3.5),
(2, 5, '2025-02-02', FALSE, 2.5),
(3, 4, '2025-03-10', TRUE, 4.0),
(3, 6, '2025-03-11', FALSE, 1.5),
(3, 7, '2025-03-12', TRUE, 3.0),
(4, 2, '2025-04-05', TRUE, 5.0),
(4, 3, '2025-04-06', FALSE, 2.0),
(5, 5, '2025-05-01', TRUE, 3.5),
(5, 6, '2025-05-02', TRUE, 3.0),
(6, 7, '2025-06-15', FALSE, 2.0),
(6, 8, '2025-06-16', TRUE, 4.0),
(7, 1, '2025-07-10', TRUE, 5.0),
(7, 2, '2025-07-11', TRUE, 4.5),
(8, 3, '2025-08-20', FALSE, 2.5),
(8, 4, '2025-08-21', TRUE, 3.5),
(9, 5, '2025-09-05', TRUE, 4.0),
(10, 6, '2025-10-10', FALSE, 1.0);


INSERT INTO audience_reviews (feature_id, review_date, star_rating) VALUES
(1, '2025-04-01', 4.5),
(1, '2025-04-02', 4.0),
(2, '2025-04-03', 3.5),
(2, '2025-04-03', 2.5),
(3, '2025-04-05', 5.0),
(3, '2025-04-06', 4.0),
(4, '2025-04-07', 2.0),
(5, '2025-04-08', 3.0),
(5, '2025-04-09', 4.5),
(6, '2025-04-10', 1.5);

INSERT INTO users (username, join_date)
VALUES 
('moviebuff123', CURDATE()),
('cinema_queen', CURDATE()),
('filmnerd99', CURDATE()),
('popcornfan', CURDATE()),
('cultclassics', CURDATE());

INSERT INTO user_preferences (user_id, genre_name) VALUES
(1, 'Action'),
(1, 'Drama'),
(2, 'Comedy'),
(3, 'Horror'),
(4, 'Action'),
(5, 'Romance');

INSERT INTO user_activity_log (user_id, activity_type, activity_start, activity_end)
VALUES 
(1, 'browse', '2025-04-28 15:00:00', '2025-04-28 15:20:00'),
(1, 'rate',   '2025-04-29 16:00:00', '2025-04-29 16:05:00'),
(2, 'browse', '2025-04-29 13:10:00', '2025-04-29 13:40:00'),
(3, 'search', '2025-04-29 10:00:00', '2025-04-29 10:30:00'),
(3, 'rate',   '2025-04-29 11:00:00', '2025-04-29 11:10:00'),
(4, 'browse', '2025-04-29 12:00:00', '2025-04-29 12:10:00'),
(5, 'rate',   '2025-04-28 14:00:00', '2025-04-28 14:03:00');

-- populate with dummer users 
UPDATE audience_reviews
SET user_id = FLOOR(1 + RAND() * 5)
WHERE audience_review_id > 0;



-- Add some queries 
-- SQL queries (1)
-- top 10 hottest right now 
CREATE VIEW Hottest_right_now AS
SELECT title, year, sweetness_percentage
FROM features
JOIN sweetness_index ON features.feature_id = sweetness_index.feature_id
WHERE type = "Movie"
ORDER BY sweetness_index.sweetness_percentage DESC, year DESC
LIMIT 10;

-- HoneyDew Melons aka certified fresh (2)
CREATE VIEW honeyDew AS
SELECT title, year, sweetness_percentage
FROM features
JOIN sweetness_index  ON features.feature_id = sweetness_index .feature_id
WHERE type = "Movie"
    AND sweetness_percentage  >= 60
 ORDER BY year DESC, sweetness_index.sweetness_percentage DESC
 LIMIT 5;
 
 -- outlets ranked by the number of postive reviews given (3)
 CREATE VIEW positive_reviews AS
 SELECT outlet_name, 
	COUNT(review_id) AS positive_reviews
FROM outlets
JOIN critics ON outlets.outlet_id = critics.outlet_id
JOIN reviews ON critics.critic_id = reviews.critic_id
WHERE reviews.is_positive = TRUE
GROUP BY outlets.outlet_id, outlet_name
ORDER BY positive_reviews DESC
LIMIT 5;

-- most active critics (4)
CREATE VIEW most_active_critics AS
SELECT critic_name, 
	COUNT(reviews.review_id) AS total_reviews,
    round(AVG(reviews.star_rating), 2 ) AS avg_star_rating
FROM critics
JOIN reviews ON critics.critic_id = reviews.critic_id
GROUP BY critics.critic_id, critics.critic_name
ORDER BY total_reviews DESC
LIMIT 5;

-- audience average score vs critic score (5)
-- Compare Critic and Audience Average Scores per Movie
CREATE VIEW critic_scores AS
SELECT features.title,
       ROUND(AVG(DISTINCT reviews.star_rating), 2) AS critic_avg_score,
       ROUND(AVG(DISTINCT a.star_rating), 2) AS audience_avg_score,
       ROUND(AVG(DISTINCT a.star_rating) - AVG(DISTINCT reviews.star_rating), 2) AS score_disagreement
FROM features 
LEFT JOIN reviews ON features.feature_id = reviews.feature_id
LEFT JOIN audience_reviews a ON features.feature_id = a.feature_id
GROUP BY features.feature_id, features.title
HAVING critic_avg_score IS NOT NULL AND audience_avg_score IS NOT NULL
ORDER BY features.title
LIMIT 5;


-- Does budget correlate with the sweetness index (6)
CREATE VIEW data_analsis_tool_one AS
SELECT title, budget.amount AS budget, (domestic_gross.amount + international_gross.amount) AS total_gross, sweetness_index.sweetness_percentage
FROM features
LEFT JOIN budget ON features.feature_id = budget.feature_id
LEFT JOIN domestic_gross ON features.feature_id = domestic_gross.feature_id
LEFT JOIN international_gross ON features.feature_id = international_gross.feature_id
LEFT JOIN sweetness_index ON features.feature_id = sweetness_index.feature_id
WHERE budget.amount IS NOT NULL
	AND domestic_gross.amount IS NOT NULL 
    AND international_gross.amount IS NOT NULL
    AND sweetness_index.sweetness_percentage IS NOT NULL 
ORDER BY budget DESC
LIMIT 5;

-- trending now (7)
CREATE OR REPLACE VIEW trending_now AS
SELECT
    features.feature_id,
    features.title,
    features.type,
    ROUND(AVG(reviews.star_rating), 2) AS avg_star_rating,
    COUNT(reviews.review_id) AS review_count,
    MAX(reviews.review_date) AS most_recent_review
FROM features
JOIN reviews ON features.feature_id = reviews.feature_id
WHERE reviews.review_date >= CURDATE() 
GROUP BY features.feature_id, features.title, features.type
ORDER BY avg_star_rating DESC, review_count DESC;


-- users who love action query
-- This is to show that I understand the union set operatir
CREATE VIEW Union_function AS
SELECT DISTINCT users.user_id, users.username, 'Preference' AS source
FROM users
JOIN user_preferences ON users.user_id = user_preferences.user_id
WHERE user_preferences.genre_name = 'Action'

UNION

SELECT DISTINCT users.user_id, users.username, 'Rated' AS source
FROM users
JOIN audience_reviews ON users.user_id = audience_reviews.user_id
JOIN genres ON audience_reviews.feature_id = genres.feature_id
WHERE genres.action >= 50;

-- total time spent per user
CREATE OR REPLACE VIEW user_engagement_summary AS
SELECT 
    users.user_id,
    users.username,
    COUNT(*) AS session_count,
    SEC_TO_TIME(SUM(TIMESTAMPDIFF(SECOND, activity_start, activity_end))) AS total_time_spent,
    SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, activity_start, activity_end))) AS avg_session_time
FROM user_activity_log
JOIN users ON user_activity_log.user_id = users.user_id
GROUP BY users.user_id, users.username;




CREATE OR REPLACE VIEW dont_miss_out AS
SELECT
    features.feature_id,
    features.title,
    features.type,
    ROUND(AVG(audience_reviews.star_rating), 2) AS avg_audience_score,
    COUNT(audience_reviews.audience_review_id) AS total_engaged_reviews
FROM audience_reviews
JOIN (
    SELECT user_id
    FROM audience_reviews
    GROUP BY user_id
    ORDER BY COUNT(*) DESC
    LIMIT 5
) AS top_users ON audience_reviews.user_id = top_users.user_id
JOIN features ON audience_reviews.feature_id = features.feature_id
GROUP BY features.feature_id, features.title, features.type
HAVING avg_audience_score >= 3.5
ORDER BY avg_audience_score DESC, total_engaged_reviews DESC;


-- recommends movies or shows to a givern user based on their preferred genres
CREATE OR REPLACE VIEW user_preferred_genres AS
SELECT DISTINCT features.feature_id,
       features.title,
       features.type,
       features.year
FROM users
JOIN user_preferences ON users.user_id = user_preferences.user_id
JOIN genres ON (
    (user_preferences.genre_name = 'Action' AND genres.action >= 50) OR
    (user_preferences.genre_name = 'Comedy' AND genres.comedy >= 50) OR
    (user_preferences.genre_name = 'Drama' AND genres.drama >= 50) OR
    (user_preferences.genre_name = 'Romance' AND genres.romance >= 50) OR
    (user_preferences.genre_name = 'Horror' AND genres.horror >= 50)
)
JOIN features ON genres.feature_id = features.feature_id
WHERE users.user_id = 1  -- Replace with actual user ID
ORDER BY features.year DESC;


-- stored procedures (1)
-- making this a stored precedure so we have the option to pull either one if wanted
DELIMITER //

CREATE PROCEDURE GetHottestFeatures(IN feature_type VARCHAR(50))
BEGIN
    SELECT f.title, f.year, si.sweetness_percentage
    FROM features f
    JOIN sweetness_index si ON f.feature_id = si.feature_id
    WHERE f.type = feature_type
    ORDER BY si.sweetness_percentage DESC, f.year DESC
    LIMIT 10;
END //

DELIMITER ; 

CALL FeaturesNeedingReviews();



-- procedure (2)
DROP PROCEDURE IF EXISTS FeaturesNeedingReviews;

DELIMITER //

CREATE PROCEDURE FeaturesNeedingReviews()
BEGIN 
    SELECT title, 
           COUNT(reviews.review_id) AS num_reviews
    FROM features
    LEFT JOIN reviews ON features.feature_id = reviews.feature_id
    GROUP BY features.feature_id, features.title
    HAVING COUNT(reviews.review_id) < 3
    ORDER BY num_reviews ASC;
END //

DELIMITER ;

CALL RecommendSimilarFeatures(4);

-- Trigger (3)
ALTER TABLE features
ADD COLUMN last_reviewed_date DATE NULL;

DELIMITER //

CREATE TRIGGER UpdateLastReviewedDate
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    UPDATE features
    SET last_reviewed_date = NEW.review_date
    WHERE feature_id = NEW.feature_id;
END //

DELIMITER ;

-- testing 
INSERT INTO reviews (feature_id, critic_id, review_date, is_positive, star_rating)
VALUES (1, 2, '2025-05-01', TRUE, 4.5);

-- check to see if it works
SELECT title, last_reviewed_date
FROM features
WHERE feature_id = 1;


-- hybrid recommender query
DROP PROCEDURE IF EXISTS RecommendSimilarFeatures;

DELIMITER //

CREATE PROCEDURE RecommendSimilarFeatures(IN input_feature_id INT)
BEGIN
    SELECT f2.title,
           f2.year,
           ROUND(si2.sweetness_percentage, 2) AS sweetness_percentage,
           CONCAT(
               CASE WHEN g2.comedy >= 50 THEN 'Comedy ' ELSE '' END,
               CASE WHEN g2.action >= 50 THEN 'Action ' ELSE '' END,
               CASE WHEN g2.drama >= 50 THEN 'Drama ' ELSE '' END,
               CASE WHEN g2.romance >= 50 THEN 'Romance ' ELSE '' END,
               CASE WHEN g2.crime >= 50 THEN 'Crime ' ELSE '' END,
               CASE WHEN g2.fantasy >= 50 THEN 'fantasy ' ELSE '' END, 
               CASE WHEN g2.horror >= 50 THEN 'horror ' ELSE '' END,
               CASE WHEN g2.mystery >= 50 THEN 'mystery ' ELSE '' END,
               CASE WHEN g2.science_fiction >= 50 THEN 'science_fiction ' ELSE '' END,
               CASE WHEN g2.historical >= 50 THEN 'historical ' ELSE '' END,
               CASE WHEN g2.espionage >= 50 THEN 'espionage ' ELSE '' END,
               CASE WHEN g2.youth >= 50 THEN 'youth ' ELSE '' END,
               CASE WHEN g2.biography >= 50 THEN 'biography ' ELSE '' END,
               CASE WHEN g2.political >= 50 THEN 'political ' ELSE '' END
               
           ) AS genres,
           (
               (g1.comedy >= 50 AND g2.comedy >= 50) +
               (g1.action >= 50 AND g2.action >= 50) +
               (g1.drama >= 50 AND g2.drama >= 50) +
               (g1.romance >= 50 AND g2.romance >= 50) +
               (g1.crime >= 50 AND g2.crime >= 50) + 
               (g1.fantasy >= 50 AND g2.fantasy >= 50) + 
               (g1.horror >= 50 AND g2.horror >= 50) + 
               (g1.mystery >= 50 AND g2.mystery >= 50) + 
               (g1.science_fiction >= 50 AND g2.science_fiction >= 50) + 
               (g1.historical >= 50 AND g2.historical >= 50) + 
               (g1.espionage >= 50 AND g2.espionage >= 50) + 
               (g1.youth >= 50 AND g2.youth >= 50) + 
               (g1.biography >= 50 AND g2.biography >= 50) + 
               (g1.political >= 50 AND g2.political >= 50) 
           ) AS genre_overlap
    FROM genres g1
    JOIN genres g2 ON g1.feature_id <> g2.feature_id
    JOIN sweetness_index si1 ON g1.feature_id = si1.feature_id
    JOIN sweetness_index si2 ON g2.feature_id = si2.feature_id
    JOIN features f2 ON g2.feature_id = f2.feature_id
    WHERE g1.feature_id = input_feature_id
      AND f2.feature_id <> input_feature_id  -- explicit safety net
      AND ABS(si1.sweetness_percentage - si2.sweetness_percentage) <= 15
    ORDER BY genre_overlap DESC, si2.sweetness_percentage DESC;
END //

DELIMITER ; 
CALL RecommendSimilarFeatures(5);


-- this means that recommend similar features returns moveis like goldfinger 
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'movies';
































