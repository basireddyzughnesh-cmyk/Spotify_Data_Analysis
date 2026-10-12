-- ============================================================
-- SPOTIFY MUSIC & POPULARITY INTELLIGENCE
-- File: 01_create_database.sql
-- Database: SQLite
-- ============================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS spotify_tracks;

CREATE TABLE spotify_tracks (
    track_id TEXT,
    artists TEXT,
    album_name TEXT,
    track_name TEXT,
    popularity INTEGER,
    duration_ms INTEGER,
    explicit INTEGER,
    danceability REAL,
    energy REAL,
    key INTEGER,
    loudness REAL,
    mode INTEGER,
    speechiness REAL,
    acousticness REAL,
    instrumentalness REAL,
    liveness REAL,
    valence REAL,
    tempo REAL,
    time_signature INTEGER,
    track_genre TEXT,
    duration_minutes REAL,
    explicit_flag INTEGER
);

CREATE INDEX idx_spotify_genre
ON spotify_tracks(track_genre);

CREATE INDEX idx_spotify_artist
ON spotify_tracks(artists);

CREATE INDEX idx_spotify_popularity
ON spotify_tracks(popularity);

CREATE INDEX idx_spotify_track
ON spotify_tracks(track_name);

-- Validation
SELECT COUNT(*) AS total_tracks
FROM spotify_tracks;

SELECT COUNT(DISTINCT track_id) AS unique_tracks
FROM spotify_tracks;

SELECT COUNT(DISTINCT artists) AS unique_artists
FROM spotify_tracks;

SELECT COUNT(DISTINCT track_genre) AS unique_genres
FROM spotify_tracks;