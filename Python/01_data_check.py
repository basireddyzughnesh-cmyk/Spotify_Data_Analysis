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
    "Data",
    "spotify-tracks-dataset-detailed.csv"
)

OUTPUT_PATH = os.path.join(BASE_PATH, "Output")

os.makedirs(OUTPUT_PATH, exist_ok=True)

# ============================================================
# LOAD DATA
# ============================================================

print("=" * 60)
print("SPOTIFY DATASET CHECK")
print("=" * 60)

df = pd.read_csv(DATA_PATH)

print("\nDataset loaded successfully!")

print("\nRows:", df.shape[0])
print("Columns:", df.shape[1])

print("\nColumn Names:")
for column in df.columns:
    print("-", column)

# ============================================================
# DATA TYPES
# ============================================================

print("\nData Types:")
print(df.dtypes)

# ============================================================
# MISSING VALUES
# ============================================================

missing = df.isnull().sum()

print("\nMissing Values:")
print(missing)

# ============================================================
# DUPLICATES
# ============================================================

duplicates = df.duplicated().sum()

print("\nDuplicate Rows:", duplicates)

# ============================================================
# NUMERICAL SUMMARY
# ============================================================

numeric_summary = df.describe().T

print("\nNumerical Summary:")
print(numeric_summary)

# ============================================================
# SAVE DATA CHECK REPORT
# ============================================================

report_file = os.path.join(
    OUTPUT_PATH,
    "data_check.txt"
)

with open(report_file, "w", encoding="utf-8") as file:

    file.write("SPOTIFY DATASET CHECK REPORT\n")
    file.write("=" * 60 + "\n\n")

    file.write(f"Rows: {df.shape[0]}\n")
    file.write(f"Columns: {df.shape[1]}\n\n")

    file.write("COLUMN NAMES\n")
    file.write("-" * 40 + "\n")

    for column in df.columns:
        file.write(f"{column}\n")

    file.write("\nDATA TYPES\n")
    file.write("-" * 40 + "\n")
    file.write(df.dtypes.to_string())

    file.write("\n\nMISSING VALUES\n")
    file.write("-" * 40 + "\n")
    file.write(missing.to_string())

    file.write("\n\nDUPLICATES\n")
    file.write("-" * 40 + "\n")
    file.write(str(duplicates))

    file.write("\n\nNUMERICAL SUMMARY\n")
    file.write("-" * 40 + "\n")
    file.write(numeric_summary.to_string())

print("\nReport saved:")
print(report_file)

print("\nDATA CHECK COMPLETED")