import sqlite3
import os
import pandas as pd

# ============================================================
# SPOTIFY BUSINESS QUERIES RUNNER
# ============================================================

BASE_PATH = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

DB_PATH = os.path.join(
    BASE_PATH,
    "SQL",
    "spotify_analysis.db"
)

SQL_PATH = os.path.join(
    BASE_PATH,
    "SQL",
    "03_business_queries.sql"
)

OUTPUT_PATH = os.path.join(
    BASE_PATH,
    "Output",
    "SQL_Business_Results.xlsx"
)

# Create output folder if it does not exist
os.makedirs(
    os.path.join(BASE_PATH, "Output"),
    exist_ok=True
)

print("=" * 60)
print("SPOTIFY BUSINESS QUERIES")
print("=" * 60)

# Check database
if not os.path.exists(DB_PATH):
    print("ERROR: Database file not found!")
    print(DB_PATH)
    raise SystemExit

# Check SQL file
if not os.path.exists(SQL_PATH):
    print("ERROR: SQL file not found!")
    print(SQL_PATH)
    raise SystemExit

# Connect database
connection = sqlite3.connect(DB_PATH)

# Read SQL file
with open(SQL_PATH, "r", encoding="utf-8") as file:
    sql_script = file.read()

# Split SQL statements
queries = []

for query in sql_script.split(";"):
    query = query.strip()

    if query:
        # Ignore comment-only sections
        lines = []

        for line in query.splitlines():
            if not line.strip().startswith("--"):
                lines.append(line)

        clean_query = "\n".join(lines).strip()

        if clean_query:
            queries.append(clean_query)

print(f"\nTotal SQL queries found: {len(queries)}")

results = {}

# Execute every query
for i, query in enumerate(queries, start=1):

    try:
        df = pd.read_sql_query(query, connection)

        sheet_name = f"Query_{i}"

        # Excel sheet name maximum = 31 characters
        results[sheet_name] = df

        print(f"Query {i:02d}: SUCCESS | Rows = {len(df)}")

    except Exception as error:

        print(f"Query {i:02d}: ERROR")
        print(error)

connection.close()

# Save all results into Excel
with pd.ExcelWriter(
    OUTPUT_PATH,
    engine="openpyxl"
) as writer:

    for sheet_name, df in results.items():

        df.to_excel(
            writer,
            sheet_name=sheet_name,
            index=False
        )

print("\n" + "=" * 60)
print("ALL BUSINESS QUERIES COMPLETED")
print("=" * 60)

print("\nResults saved here:")
print(OUTPUT_PATH)

print(f"\nSuccessful queries: {len(results)}")