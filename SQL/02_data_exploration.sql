-- ============================================================
-- SPOTIFY MUSIC & POPULARITY INTELLIGENCE
-- File: 02_data_exploration.sql
-- Purpose: Initial Data Exploration
-- Database: spotify_analysis.db
-- ============================================================


-- ============================================================
-- 1. TOTAL NUMBER OF RECORDS
-- ============================================================

SELECT
    COUNT(*) AS total_records
FROM spotify_tracks;


-- ============================================================
-- 2. UNIQUE TRACKS
-- ============================================================

SELECT
    COUNT(DISTINCT track_id) AS unique_tracks
FROM spotify_tracks;


-- ============================================================
-- 3. UNIQUE ARTISTS
-- ============================================================

SELECT
    COUNT(DISTINCT artists) AS unique_artists
FROM spotify_tracks;


-- ============================================================
-- 4. UNIQUE GENRES
-- ============================================================

SELECT
    COUNT(DISTINCT track_genre) AS unique_genres
FROM spotify_tracks;


-- ============================================================
-- 5. BASIC POPULARITY STATISTICS
-- ============================================================

SELECT
    MIN(popularity) AS minimum_popularity,
    MAX(popularity) AS maximum_popularity,
    ROUND(AVG(popularity), 2) AS average_popularity
FROM spotify_tracks;


-- ============================================================
-- 6. AUDIO FEATURE SUMMARY
-- ============================================================

SELECT
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(acousticness), 3) AS avg_acousticness,
    ROUND(AVG(instrumentalness), 3) AS avg_instrumentalness,
    ROUND(AVG(liveness), 3) AS avg_liveness,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(speechiness), 3) AS avg_speechiness,
    ROUND(AVG(tempo), 2) AS avg_tempo
FROM spotify_tracks;


-- ============================================================
-- 7. DURATION ANALYSIS
-- ============================================================

SELECT
    ROUND(AVG(duration_minutes), 2) AS avg_duration_minutes,
    ROUND(MIN(duration_minutes), 2) AS minimum_duration_minutes,
    ROUND(MAX(duration_minutes), 2) AS maximum_duration_minutes
FROM spotify_tracks;


-- ============================================================
-- 8. EXPLICIT VS NON-EXPLICIT TRACKS
-- ============================================================

SELECT
    CASE
        WHEN explicit = 1 THEN 'Explicit'
        ELSE 'Non-Explicit'
    END AS content_type,

    COUNT(*) AS track_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM spotify_tracks),
        2
    ) AS percentage

FROM spotify_tracks

GROUP BY explicit

ORDER BY track_count DESC;


-- ============================================================
-- 9. TOP 10 MOST POPULAR TRACKS
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    track_genre

FROM spotify_tracks

ORDER BY popularity DESC

LIMIT 10;


-- ============================================================
-- 10. TOP 10 ARTISTS BY NUMBER OF TRACKS
-- ============================================================

SELECT
    artists,
    COUNT(*) AS track_count

FROM spotify_tracks

GROUP BY artists

ORDER BY track_count DESC

LIMIT 10;


-- ============================================================
-- 11. TOP 20 GENRES BY TRACK COUNT
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count

FROM spotify_tracks

GROUP BY track_genre

ORDER BY track_count DESC

LIMIT 20;


-- ============================================================
-- 12. GENRE-WISE POPULARITY
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity

FROM spotify_tracks

GROUP BY track_genre

ORDER BY avg_popularity DESC;


-- ============================================================
-- 13. GENRE-WISE AUDIO FEATURES
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,

    ROUND(AVG(danceability), 3) AS avg_danceability,

    ROUND(AVG(energy), 3) AS avg_energy,

    ROUND(AVG(valence), 3) AS avg_valence,

    ROUND(AVG(acousticness), 3) AS avg_acousticness,

    ROUND(AVG(instrumentalness), 3) AS avg_instrumentalness

FROM spotify_tracks

GROUP BY track_genre

ORDER BY avg_energy DESC;


-- ============================================================
-- 14. POPULARITY GROUPS
-- ============================================================

SELECT
    CASE
        WHEN popularity < 20
            THEN 'Low Popularity'

        WHEN popularity < 50
            THEN 'Medium Popularity'

        WHEN popularity < 80
            THEN 'High Popularity'

        ELSE 'Very High Popularity'
    END AS popularity_category,

    COUNT(*) AS track_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM spotify_tracks),
        2
    ) AS percentage

FROM spotify_tracks

GROUP BY popularity_category

ORDER BY
    CASE popularity_category
        WHEN 'Low Popularity' THEN 1
        WHEN 'Medium Popularity' THEN 2
        WHEN 'High Popularity' THEN 3
        WHEN 'Very High Popularity' THEN 4
    END;


-- ============================================================
-- 15. HIGHLY POPULAR TRACKS
-- ============================================================

SELECT
    track_name,
    artists,
    popularity,
    danceability,
    energy,
    valence,
    track_genre

FROM spotify_tracks

WHERE popularity >= 80

ORDER BY popularity DESC;


-- ============================================================
-- 16. TOP 10 MOST DANCEABLE TRACKS
-- ============================================================

SELECT
    track_name,
    artists,
    ROUND(danceability, 3) AS danceability,
    popularity,
    track_genre

FROM spotify_tracks

ORDER BY danceability DESC

LIMIT 10;


-- ============================================================
-- 17. TOP 10 MOST ENERGETIC TRACKS
-- ============================================================

SELECT
    track_name,
    artists,
    ROUND(energy, 3) AS energy,
    popularity,
    track_genre

FROM spotify_tracks

ORDER BY energy DESC

LIMIT 10;


-- ============================================================
-- 18. GENRES WITH HIGH AVERAGE POPULARITY
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity

FROM spotify_tracks

GROUP BY track_genre

HAVING AVG(popularity) >= 50

ORDER BY avg_popularity DESC;


-- ============================================================
-- 19. ARTISTS WITH MORE THAN 50 TRACKS
-- ============================================================

SELECT
    artists,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity

FROM spotify_tracks

GROUP BY artists

HAVING COUNT(*) > 50

ORDER BY avg_popularity DESC;


-- ============================================================
-- 20. DATA QUALITY CHECK
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(track_id) AS non_null_track_ids,

    COUNT(track_name) AS non_null_track_names,

    COUNT(artists) AS non_null_artists,

    COUNT(album_name) AS non_null_album_names,

    COUNT(track_genre) AS non_null_genres

FROM spotify_tracks;


-- ============================================================
-- 21. NULL VALUE CHECK
-- ============================================================

SELECT
    SUM(
        CASE
            WHEN track_id IS NULL THEN 1
            ELSE 0
        END
    ) AS null_track_ids,

    SUM(
        CASE
            WHEN track_name IS NULL THEN 1
            ELSE 0
        END
    ) AS null_track_names,

    SUM(
        CASE
            WHEN artists IS NULL THEN 1
            ELSE 0
        END
    ) AS null_artists,

    SUM(
        CASE
            WHEN track_genre IS NULL THEN 1
            ELSE 0
        END
    ) AS null_genres

FROM spotify_tracks;


-- ============================================================
-- 22. POPULARITY DISTRIBUTION
-- ============================================================

SELECT
    popularity,
    COUNT(*) AS track_count

FROM spotify_tracks

GROUP BY popularity

ORDER BY popularity DESC;


-- ============================================================
-- 23. AVERAGE AUDIO FEATURES
-- BY EXPLICIT CONTENT
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

    ROUND(AVG(valence), 3) AS avg_valence

FROM spotify_tracks

GROUP BY explicit

ORDER BY avg_popularity DESC;


-- ============================================================
-- 24. GENRE TRACK COUNT + POPULARITY
-- ============================================================

SELECT
    track_genre,
    COUNT(*) AS total_tracks,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS highest_popularity

FROM spotify_tracks

GROUP BY track_genre

ORDER BY avg_popularity DESC;


-- ============================================================
-- 25. LONGEST TRACKS
-- ============================================================

SELECT
    track_name,
    artists,
    ROUND(duration_minutes, 2) AS duration_minutes,
    popularity,
    track_genre

FROM spotify_tracks

ORDER BY duration_minutes DESC

LIMIT 10;


-- ============================================================
-- END OF DATA EXPLORATION
-- ============================================================