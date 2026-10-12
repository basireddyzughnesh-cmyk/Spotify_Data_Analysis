-- ============================================================
-- SPOTIFY MUSIC & POPULARITY INTELLIGENCE
-- File: 03_business_queries.sql
-- Purpose: Business & Advanced Analytical Queries
-- Database: spotify_analysis.db
-- ============================================================


-- ============================================================
-- 1. TOP 20 MOST POPULAR TRACKS
-- Business Question:
-- Which tracks have the highest popularity?
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    track_genre
FROM spotify_tracks
WHERE track_name IS NOT NULL
ORDER BY popularity DESC
LIMIT 20;


-- ============================================================
-- 2. TOP 20 ARTISTS BY AVERAGE POPULARITY
-- Business Question:
-- Which artists have the highest average popularity?
-- ============================================================

SELECT
    artists,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS highest_popularity
FROM spotify_tracks
WHERE artists IS NOT NULL
GROUP BY artists
HAVING COUNT(*) >= 5
ORDER BY avg_popularity DESC
LIMIT 20;


-- ============================================================
-- 3. TOP GENRES BY AVERAGE POPULARITY
-- Business Question:
-- Which genres have the highest average popularity?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS highest_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 50
ORDER BY avg_popularity DESC
LIMIT 20;


-- ============================================================
-- 4. GENRE PERFORMANCE ANALYSIS
-- Business Question:
-- How are genres performing based on popularity and audio features?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(acousticness), 3) AS avg_acousticness
FROM spotify_tracks
GROUP BY track_genre
ORDER BY avg_popularity DESC;


-- ============================================================
-- 5. HIGH-POPULARITY TRACK ANALYSIS
-- Business Question:
-- What are the characteristics of highly popular tracks?
-- ============================================================

SELECT
    COUNT(*) AS highly_popular_tracks,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(acousticness), 3) AS avg_acousticness,
    ROUND(AVG(instrumentalness), 3) AS avg_instrumentalness,
    ROUND(AVG(tempo), 2) AS avg_tempo
FROM spotify_tracks
WHERE popularity >= 80;


-- ============================================================
-- 6. POPULARITY SEGMENTATION
-- Business Question:
-- How are tracks distributed across popularity segments?
-- ============================================================

SELECT
    CASE
        WHEN popularity < 20 THEN 'Low'
        WHEN popularity < 50 THEN 'Medium'
        WHEN popularity < 80 THEN 'High'
        ELSE 'Very High'
    END AS popularity_segment,
    COUNT(*) AS track_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM spotify_tracks),
        2
    ) AS percentage
FROM spotify_tracks
GROUP BY popularity_segment
ORDER BY
    CASE popularity_segment
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Very High' THEN 4
    END;


-- ============================================================
-- 7. EXPLICIT CONTENT ANALYSIS
-- Business Question:
-- How does explicit content differ in popularity and audio features?
-- ============================================================

SELECT
    CASE
        WHEN explicit = 1 THEN 'Explicit'
        ELSE 'Non-Explicit'
    END AS content_type,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(speechiness), 3) AS avg_speechiness
FROM spotify_tracks
GROUP BY explicit;


-- ============================================================
-- 8. MOST DANCEABLE GENRES
-- Business Question:
-- Which genres have the highest average danceability?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 50
ORDER BY avg_danceability DESC
LIMIT 15;


-- ============================================================
-- 9. MOST ENERGETIC GENRES
-- Business Question:
-- Which genres have the highest average energy?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 50
ORDER BY avg_energy DESC
LIMIT 15;


-- ============================================================
-- 10. HAPPIEST / POSITIVE GENRES
-- Business Question:
-- Which genres have the highest average valence?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 50
ORDER BY avg_valence DESC
LIMIT 15;


-- ============================================================
-- 11. MOST ACOUSTIC GENRES
-- Business Question:
-- Which genres have the strongest acoustic characteristics?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(acousticness), 3) AS avg_acousticness,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 50
ORDER BY avg_acousticness DESC
LIMIT 15;


-- ============================================================
-- 12. ARTIST CONTENT PORTFOLIO
-- Business Question:
-- Which artists have a large number of tracks?
-- ============================================================

SELECT
    artists,
    COUNT(*) AS total_tracks,
    COUNT(DISTINCT track_genre) AS genre_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy
FROM spotify_tracks
WHERE artists IS NOT NULL
GROUP BY artists
HAVING COUNT(*) >= 20
ORDER BY total_tracks DESC
LIMIT 20;


-- ============================================================
-- 13. ARTISTS WITH HIGH POPULARITY AND LARGE CATALOG
-- Business Question:
-- Which artists combine catalog size with popularity?
-- ============================================================

SELECT
    artists,
    COUNT(*) AS total_tracks,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS highest_popularity
FROM spotify_tracks
WHERE artists IS NOT NULL
GROUP BY artists
HAVING COUNT(*) >= 20
   AND AVG(popularity) >= 50
ORDER BY avg_popularity DESC;


-- ============================================================
-- 14. POPULARITY BY DANCEABILITY
-- Business Question:
-- How does danceability vary across popularity levels?
-- ============================================================

SELECT
    CASE
        WHEN popularity < 20 THEN 'Low'
        WHEN popularity < 50 THEN 'Medium'
        WHEN popularity < 80 THEN 'High'
        ELSE 'Very High'
    END AS popularity_segment,
    COUNT(*) AS track_count,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(valence), 3) AS avg_valence
FROM spotify_tracks
GROUP BY popularity_segment
ORDER BY
    CASE popularity_segment
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Very High' THEN 4
    END;


-- ============================================================
-- 15. POPULARITY BY TRACK DURATION
-- Business Question:
-- Does track duration vary across popularity levels?
-- ============================================================

SELECT
    CASE
        WHEN popularity < 20 THEN 'Low'
        WHEN popularity < 50 THEN 'Medium'
        WHEN popularity < 80 THEN 'High'
        ELSE 'Very High'
    END AS popularity_segment,
    COUNT(*) AS track_count,
    ROUND(AVG(duration_minutes), 2) AS avg_duration_minutes
FROM spotify_tracks
GROUP BY popularity_segment
ORDER BY
    CASE popularity_segment
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Very High' THEN 4
    END;


-- ============================================================
-- 16. TOP TRACKS WITH HIGH DANCEABILITY AND POPULARITY
-- Business Question:
-- Which tracks combine strong danceability with popularity?
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    ROUND(danceability, 3) AS danceability,
    ROUND(energy, 3) AS energy,
    track_genre
FROM spotify_tracks
WHERE popularity >= 70
  AND danceability >= 0.70
ORDER BY popularity DESC, danceability DESC
LIMIT 20;


-- ============================================================
-- 17. TOP TRACKS WITH HIGH ENERGY AND POPULARITY
-- Business Question:
-- Which tracks combine high energy with popularity?
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    ROUND(energy, 3) AS energy,
    ROUND(danceability, 3) AS danceability,
    track_genre
FROM spotify_tracks
WHERE popularity >= 70
  AND energy >= 0.80
ORDER BY popularity DESC, energy DESC
LIMIT 20;


-- ============================================================
-- 18. GENRE POPULARITY BENCHMARK
-- Business Question:
-- Which genres perform above the overall dataset average?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING AVG(popularity) >
       (SELECT AVG(popularity) FROM spotify_tracks)
ORDER BY avg_popularity DESC;


-- ============================================================
-- 19. GENRES WITH LARGE CATALOG AND HIGH POPULARITY
-- Business Question:
-- Which genres have both strong representation and popularity?
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*) >= 500
ORDER BY avg_popularity DESC;


-- ============================================================
-- 20. TOP 20 TRACKS BY COMBINED ENGAGEMENT FEATURES
-- Business Question:
-- Which tracks have strong popularity, danceability and energy?
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    ROUND(danceability, 3) AS danceability,
    ROUND(energy, 3) AS energy,
    ROUND(
        popularity * 0.50 +
        danceability * 100 * 0.25 +
        energy * 100 * 0.25,
        2
    ) AS engagement_score,
    track_genre
FROM spotify_tracks
WHERE track_name IS NOT NULL
ORDER BY engagement_score DESC
LIMIT 20;


-- ============================================================
-- 21. TOP GENRES FOR HIGH-ENERGY MUSIC
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY track_genre
HAVING AVG(energy) >= 0.70
ORDER BY avg_popularity DESC;


-- ============================================================
-- 22. TRACKS WITH EXTREME AUDIO FEATURES
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    ROUND(danceability, 3) AS danceability,
    ROUND(energy, 3) AS energy,
    ROUND(valence, 3) AS valence,
    track_genre
FROM spotify_tracks
WHERE danceability >= 0.90
   OR energy >= 0.95
   OR valence >= 0.95
ORDER BY popularity DESC
LIMIT 30;


-- ============================================================
-- 23. TOP GENRES BY CONTENT VOLUME
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS total_tracks,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM spotify_tracks),
        2
    ) AS dataset_share_percentage
FROM spotify_tracks
GROUP BY track_genre
ORDER BY total_tracks DESC
LIMIT 20;


-- ============================================================
-- 24. ARTIST GENRE DIVERSITY
-- Business Question:
-- Which artists appear across the largest number of genres?
-- ============================================================

SELECT
    artists,
    COUNT(DISTINCT track_genre) AS genre_count,
    COUNT(*) AS total_tracks,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
WHERE artists IS NOT NULL
GROUP BY artists
HAVING COUNT(*) >= 10
ORDER BY genre_count DESC, avg_popularity DESC
LIMIT 20;


-- ============================================================
-- 25. FINAL BUSINESS KPI SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_tracks,
    COUNT(DISTINCT track_id) AS unique_tracks,
    COUNT(DISTINCT artists) AS unique_artists,
    COUNT(DISTINCT track_genre) AS unique_genres,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(duration_minutes), 2) AS avg_duration_minutes,
    SUM(CASE WHEN explicit = 1 THEN 1 ELSE 0 END) AS explicit_tracks
FROM spotify_tracks;


-- ============================================================
-- END OF BUSINESS QUERIES
-- ============================================================