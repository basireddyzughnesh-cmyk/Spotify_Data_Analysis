import sqlite3
import pandas as pd
import os

# ============================================================
# PATHS
# ============================================================

BASE_PATH = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

CSV_PATH = os.path.join(
    BASE_PATH,
    "Output",
    "spotify_cleaned.csv"
)

DB_PATH = os.path.join(
    BASE_PATH,
    "SQL",
    "spotify_analysis.db"
)

# ============================================================
# LOAD CLEANED CSV
# ============================================================

print("=" * 60)
print("SPOTIFY DATABASE CREATION")
print("=" * 60)

print("\nLoading cleaned CSV...")

df = pd.read_csv(CSV_PATH)

print("Rows loaded:", len(df))
print("Columns loaded:", len(df.columns))

# ============================================================
# CONNECT TO SQLITE DATABASE
# ============================================================

conn = sqlite3.connect(DB_PATH)

print("\nDatabase created/connected:")
print(DB_PATH)

# ============================================================
# CREATE TABLE
# ============================================================

create_table_sql = """
CREATE TABLE IF NOT EXISTS spotify_tracks (
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
"""

conn.execute(create_table_sql)

# ============================================================
# CLEAR OLD DATA
# ============================================================

conn.execute("DELETE FROM spotify_tracks")

# ============================================================
# IMPORT CSV DATA
# ============================================================

df.to_sql(
    "spotify_tracks",
    conn,
    if_exists="append",
    index=False
)

# ============================================================
# CREATE INDEXES
# ============================================================

conn.execute("""
CREATE INDEX IF NOT EXISTS idx_spotify_genre
ON spotify_tracks(track_genre)
""")

conn.execute("""
CREATE INDEX IF NOT EXISTS idx_spotify_artist
ON spotify_tracks(artists)
""")

conn.execute("""
CREATE INDEX IF NOT EXISTS idx_spotify_popularity
ON spotify_tracks(popularity)
""")

# ============================================================
# COMMIT
# ============================================================

conn.commit()

# ============================================================
# VALIDATION
# ============================================================

cursor = conn.cursor()

cursor.execute(
    "SELECT COUNT(*) FROM spotify_tracks"
)

total_tracks = cursor.fetchone()[0]

cursor.execute(
    "SELECT COUNT(DISTINCT track_id) FROM spotify_tracks"
)

unique_tracks = cursor.fetchone()[0]

cursor.execute(
    "SELECT COUNT(DISTINCT artists) FROM spotify_tracks"
)

unique_artists = cursor.fetchone()[0]

cursor.execute(
    "SELECT COUNT(DISTINCT track_genre) FROM spotify_tracks"
)

unique_genres = cursor.fetchone()[0]

print("\n" + "=" * 60)
print("DATABASE VALIDATION")
print("=" * 60)

print("Total tracks   :", total_tracks)
print("Unique tracks  :", unique_tracks)
print("Unique artists :", unique_artists)
print("Unique genres  :", unique_genres)

# ============================================================
# SAMPLE DATA
# ============================================================

print("\nSample records:")

sample = pd.read_sql_query(
    """
    SELECT
        track_id,
        artists,
        track_name,
        popularity,
        track_genre
    FROM spotify_tracks
    LIMIT 5
    """,
    conn
)

print(sample.to_string(index=False))

# ============================================================
# CLOSE DATABASE
# ============================================================

conn.close()

print("\n" + "=" * 60)
print("DATABASE CREATION COMPLETED")
print("=" * 60)

print("\nDatabase saved at:")
print(DB_PATH)