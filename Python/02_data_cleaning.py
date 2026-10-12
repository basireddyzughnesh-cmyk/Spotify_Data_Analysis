import os
import pandas as pd
import numpy as np

# ============================================================
# PATHS
# ============================================================

BASE_PATH = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

DATA_PATH = os.path.join(
    BASE_PATH,
    "Data",
    "spotify-tracks-dataset-detailed.csv"
)

OUTPUT_PATH = os.path.join(BASE_PATH, "Output")

os.makedirs(OUTPUT_PATH, exist_ok=True)

# ============================================================
# LOAD DATA
# ============================================================

print("=" * 60)
print("SPOTIFY DATA CLEANING")
print("=" * 60)

df = pd.read_csv(DATA_PATH)

print("\nOriginal Shape:", df.shape)

# ============================================================
# CLEAN COLUMN NAMES
# ============================================================

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
    .str.replace("(", "", regex=False)
    .str.replace(")", "", regex=False)
)

print("\nCleaned Column Names:")
print(df.columns.tolist())

# ============================================================
# REMOVE COMPLETELY EMPTY COLUMNS
# ============================================================

empty_columns = df.columns[df.isnull().all()].tolist()

if empty_columns:
    df.drop(columns=empty_columns, inplace=True)

print("\nEmpty columns removed:", empty_columns)

# ============================================================
# REMOVE DUPLICATES
# ============================================================

before_duplicates = len(df)

df.drop_duplicates(inplace=True)

after_duplicates = len(df)

print("\nDuplicates removed:",
      before_duplicates - after_duplicates)

# ============================================================
# REMOVE EXTRA SPACES FROM TEXT COLUMNS
# ============================================================

text_columns = df.select_dtypes(include="object").columns

for column in text_columns:
    df[column] = df[column].astype(str).str.strip()

# ============================================================
# CONVERT NUMERIC COLUMNS
# ============================================================

possible_numeric_columns = [
    "popularity",
    "duration_ms",
    "danceability",
    "energy",
    "key",
    "loudness",
    "mode",
    "speechiness",
    "acousticness",
    "instrumentalness",
    "liveness",
    "valence",
    "tempo",
    "time_signature"
]

for column in possible_numeric_columns:

    if column in df.columns:
        df[column] = pd.to_numeric(
            df[column],
            errors="coerce"
        )

# ============================================================
# MISSING VALUE REPORT
# ============================================================

missing_before = df.isnull().sum()

print("\nMissing values:")
print(missing_before[missing_before > 0])

# ============================================================
# HANDLE MISSING VALUES
# ============================================================

numeric_columns = df.select_dtypes(
    include=np.number
).columns

for column in numeric_columns:

    if df[column].isnull().sum() > 0:
        df[column] = df[column].fillna(
            df[column].median()
        )

text_columns = df.select_dtypes(
    include="object"
).columns

for column in text_columns:

    if df[column].isnull().sum() > 0:
        df[column] = df[column].fillna(
            "Unknown"
        )

# ============================================================
# REMOVE INVALID VALUES
# ============================================================

# Popularity should normally be between 0 and 100
if "popularity" in df.columns:

    df = df[
        (df["popularity"] >= 0) &
        (df["popularity"] <= 100)
    ]

# Audio features normally range from 0 to 1
audio_columns = [
    "danceability",
    "energy",
    "speechiness",
    "acousticness",
    "instrumentalness",
    "liveness",
    "valence"
]

for column in audio_columns:

    if column in df.columns:

        df = df[
            (df[column] >= 0) &
            (df[column] <= 1)
        ]

# ============================================================
# DURATION
# ============================================================

if "duration_ms" in df.columns:

    df["duration_minutes"] = (
        df["duration_ms"] / 60000
    )

# ============================================================
# EXPLICIT CLEANING
# ============================================================

if "explicit" in df.columns:

    df["explicit"] = df["explicit"].astype(str).str.lower()

    df["explicit_flag"] = df["explicit"].map({
        "true": 1,
        "false": 0
    })

# ============================================================
# SAVE CLEANED DATA
# ============================================================

cleaned_file = os.path.join(
    OUTPUT_PATH,
    "spotify_cleaned.csv"
)

df.to_csv(
    cleaned_file,
    index=False
)

# ============================================================
# SAVE SUMMARY
# ============================================================

summary = pd.DataFrame({
    "Metric": [
        "Total Rows",
        "Total Columns",
        "Duplicate Rows",
        "Missing Values"
    ],
    "Value": [
        len(df),
        len(df.columns),
        before_duplicates - after_duplicates,
        int(df.isnull().sum().sum())
    ]
})

summary_file = os.path.join(
    OUTPUT_PATH,
    "data_summary.csv"
)

summary.to_csv(
    summary_file,
    index=False
)

print("\nFinal Shape:", df.shape)

print("\nCleaned dataset saved:")
print(cleaned_file)

print("\nSummary saved:")
print(summary_file)

print("\nDATA CLEANING COMPLETED")