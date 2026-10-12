import os
import pandas as pd

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

# ============================================================
# LOAD DATA
# ============================================================

df = pd.read_csv(DATA_PATH)

insights = []

# ============================================================
# BASIC KPIs
# ============================================================

total_tracks = len(df)

insights.append(
    f"Total tracks analyzed: {total_tracks:,}"
)

# ============================================================

if "popularity" in df.columns:

    avg_popularity = df["popularity"].mean()

    most_popular = df.loc[
        df["popularity"].idxmax()
    ]

    insights.append(
        f"Average track popularity: {avg_popularity:.2f}"
    )

    track_name = (
        most_popular["track_name"]
        if "track_name" in df.columns
        else "Unknown"
    )

    insights.append(
        f"Highest popularity track: {track_name}"
    )

# ============================================================
# ARTIST ANALYSIS
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

    top_artist = (
        df[artist_column]
        .value_counts()
        .idxmax()
    )

    top_artist_count = (
        df[artist_column]
        .value_counts()
        .max()
    )

    insights.append(
        f"Artist with the highest number of tracks: "
        f"{top_artist} ({top_artist_count} tracks)"
    )

# ============================================================
# GENRE ANALYSIS
# ============================================================

if "track_genre" in df.columns:

    top_genre = (
        df["track_genre"]
        .value_counts()
        .idxmax()
    )

    top_genre_count = (
        df["track_genre"]
        .value_counts()
        .max()
    )

    insights.append(
        f"Most represented genre: "
        f"{top_genre} ({top_genre_count:,} tracks)"
    )

    if "popularity" in df.columns:

        genre_popularity = (
            df.groupby("track_genre")["popularity"]
            .mean()
            .sort_values(
                ascending=False
            )
        )

        best_genre = genre_popularity.index[0]

        best_genre_score = genre_popularity.iloc[0]

        insights.append(
            f"Genre with the highest average popularity: "
            f"{best_genre} ({best_genre_score:.2f})"
        )

# ============================================================
# AUDIO FEATURES
# ============================================================

if "energy" in df.columns:

    insights.append(
        f"Average energy: "
        f"{df['energy'].mean():.3f}"
    )

if "danceability" in df.columns:

    insights.append(
        f"Average danceability: "
        f"{df['danceability'].mean():.3f}"
    )

if "valence" in df.columns:

    insights.append(
        f"Average valence: "
        f"{df['valence'].mean():.3f}"
    )

if "tempo" in df.columns:

    insights.append(
        f"Average tempo: "
        f"{df['tempo'].mean():.2f} BPM"
    )

# ============================================================
# EXPLICIT CONTENT
# ============================================================

if "explicit" in df.columns:

    explicit_count = (
        df["explicit"]
        .astype(str)
        .str.lower()
        .eq("true")
        .sum()
    )

    explicit_percentage = (
        explicit_count / len(df) * 100
    )

    insights.append(
        f"Explicit tracks: "
        f"{explicit_count:,} "
        f"({explicit_percentage:.2f}%)"
    )

# ============================================================
# SAVE INSIGHTS
# ============================================================

insight_file = os.path.join(
    OUTPUT_PATH,
    "insights.txt"
)

with open(
    insight_file,
    "w",
    encoding="utf-8"
) as file:

    file.write(
        "SPOTIFY MUSIC & POPULARITY INTELLIGENCE\n"
    )

    file.write("=" * 60 + "\n\n")

    for number, insight in enumerate(
        insights,
        start=1
    ):

        file.write(
            f"{number}. {insight}\n"
        )

print("=" * 60)
print("SPOTIFY INSIGHTS")
print("=" * 60)

for insight in insights:
    print("-", insight)

print("\nInsights saved to:")
print(insight_file)

print("\nINSIGHT GENERATION COMPLETED")