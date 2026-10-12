import os
import pandas as pd
import matplotlib.pyplot as plt

# ============================================================
# PATHS
# ============================================================

BASE_PATH = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

DATA_PATH = os.path.join(
    BASE_PATH,
    "Output",
    "spotify_cleaned.csv"
)

OUTPUT_PATH = os.path.join(
    BASE_PATH,
    "Output"
)

CHART_PATH = os.path.join(
    OUTPUT_PATH,
    "Charts"
)

os.makedirs(CHART_PATH, exist_ok=True)

# ============================================================
# LOAD DATA
# ============================================================

print("=" * 60)
print("SPOTIFY EXPLORATORY DATA ANALYSIS")
print("=" * 60)

df = pd.read_csv(DATA_PATH)

print("\nDataset Shape:", df.shape)

# ============================================================
# 1. TOP GENRES
# ============================================================

if "track_genre" in df.columns:

    genre_counts = (
        df["track_genre"]
        .value_counts()
        .head(10)
    )

    plt.figure(figsize=(10, 6))

    genre_counts.sort_values().plot(
        kind="barh"
    )

    plt.title("Top 10 Spotify Genres by Track Count")
    plt.xlabel("Number of Tracks")
    plt.ylabel("Genre")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "01_top_genres.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 2. POPULARITY DISTRIBUTION
# ============================================================

if "popularity" in df.columns:

    plt.figure(figsize=(10, 6))

    plt.hist(
        df["popularity"],
        bins=20
    )

    plt.title("Spotify Track Popularity Distribution")
    plt.xlabel("Popularity")
    plt.ylabel("Number of Tracks")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "02_popularity_distribution.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 3. ENERGY DISTRIBUTION
# ============================================================

if "energy" in df.columns:

    plt.figure(figsize=(10, 6))

    plt.hist(
        df["energy"],
        bins=20
    )

    plt.title("Energy Distribution")
    plt.xlabel("Energy")
    plt.ylabel("Number of Tracks")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "03_energy_distribution.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 4. DANCEABILITY DISTRIBUTION
# ============================================================

if "danceability" in df.columns:

    plt.figure(figsize=(10, 6))

    plt.hist(
        df["danceability"],
        bins=20
    )

    plt.title("Danceability Distribution")
    plt.xlabel("Danceability")
    plt.ylabel("Number of Tracks")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "04_danceability_distribution.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 5. ENERGY VS DANCEABILITY
# ============================================================

if (
    "energy" in df.columns and
    "danceability" in df.columns
):

    sample = df.sample(
        min(5000, len(df)),
        random_state=42
    )

    plt.figure(figsize=(10, 6))

    plt.scatter(
        sample["energy"],
        sample["danceability"],
        alpha=0.4
    )

    plt.title("Energy vs Danceability")
    plt.xlabel("Energy")
    plt.ylabel("Danceability")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "05_energy_vs_danceability.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 6. VALENCE VS POPULARITY
# ============================================================

if (
    "valence" in df.columns and
    "popularity" in df.columns
):

    sample = df.sample(
        min(5000, len(df)),
        random_state=42
    )

    plt.figure(figsize=(10, 6))

    plt.scatter(
        sample["valence"],
        sample["popularity"],
        alpha=0.4
    )

    plt.title("Valence vs Popularity")
    plt.xlabel("Valence")
    plt.ylabel("Popularity")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "06_valence_vs_popularity.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 7. TOP ARTISTS
# ============================================================

artist_column = None

for column in [
    "artists",
    "artist",
    "artist_name"
]:

    if column in df.columns:
        artist_column = column
        break

if artist_column:

    artist_counts = (
        df[artist_column]
        .value_counts()
        .head(10)
    )

    plt.figure(figsize=(10, 6))

    artist_counts.sort_values().plot(
        kind="barh"
    )

    plt.title("Top 10 Artists by Number of Tracks")
    plt.xlabel("Number of Tracks")
    plt.ylabel("Artist")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "07_top_artists.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# 8. EXPLICIT VS NON-EXPLICIT
# ============================================================

if "explicit" in df.columns:

    explicit_counts = df["explicit"].value_counts()

    plt.figure(figsize=(8, 6))

    explicit_counts.plot(
        kind="bar"
    )

    plt.title("Explicit vs Non-Explicit Tracks")
    plt.xlabel("Explicit")
    plt.ylabel("Number of Tracks")

    plt.tight_layout()

    plt.savefig(
        os.path.join(
            CHART_PATH,
            "08_explicit_tracks.png"
        ),
        dpi=300
    )

    plt.close()

# ============================================================
# SAVE GENRE SUMMARY
# ============================================================

if "track_genre" in df.columns:

    if "popularity" in df.columns:

        genre_summary = (
            df.groupby("track_genre")
            .agg(
                tracks=("track_genre", "count"),
                avg_popularity=("popularity", "mean")
            )
            .sort_values(
                "avg_popularity",
                ascending=False
            )
        )

        genre_summary.to_csv(
            os.path.join(
                OUTPUT_PATH,
                "genre_summary.csv"
            )
        )

print("\nCharts saved in:")
print(CHART_PATH)

print("\nEDA COMPLETED")