# Spotify Music Analytics Project

This project is a full end-to-end analytics workflow built around Spotify track metadata. It follows the structure a senior analyst would use to turn raw data into business-ready insight: data validation, cleaning, exploratory analysis, SQL-based questions, and stakeholder-friendly outputs.

## Project Objective

The goal is to understand music consumption and performance patterns by analyzing a Spotify music dataset. The analysis focuses on:

- track popularity distribution
- artist and genre performance
- audio feature patterns (energy, danceability, valence, tempo, etc.)
- explicit vs non-explicit content behavior
- business questions that can drive recommendation and content strategy

## Business Context

The dataset contains track-level music metadata including popularity scores, artist names, genres, and audio attributes. From a business perspective, the project answers questions such as:

- Which artists and genres are most represented?
- Which genres have the strongest popularity?
- What audio characteristics are associated with highly popular tracks?
- How do explicit tracks differ from non-explicit tracks?
- Which songs and genres are worth prioritizing for promotion, playlisting, or catalog decisions?

This is a classic analyst workflow: convert raw data into trustworthy insights that can inform product, content, and audience strategy.

## Data Pipeline Overview

The project follows a disciplined analytics pipeline:

1. Data audit and validation
2. Data cleaning and standardization
3. Exploratory data analysis
4. KPI and insight generation
5. SQLite database creation
6. Business-query analysis
7. Reporting and dashboard-ready outputs

## Folder Structure

- `Data/` – raw source dataset
- `Python/` – ETL, EDA, and reporting scripts
- `SQL/` – database schema and business SQL queries
- `Output/` – cleaned data, summary files, charts, and Excel outputs
- `Power BI/` – Power BI dashboard file

## Data Source

The original dataset is stored in:

- `Data/spotify-tracks-dataset-detailed.csv`

The project is built to evaluate the quality, consistency, and business meaning of the track-level data before producing analytical outputs.

## How a Senior Analyst Would Approach This

A strong analyst mindset for this project would look like this:

### 1) Define the analytical questions
Before building visuals or reports, the first step is to define what success looks like:

- Which tracks are strong performers?
- Which genres are growing or more commercially attractive?
- What features drive popularity?
- What patterns help prioritize content investment?

### 2) Validate the dataset before analysis
The first Python script checks:

- row and column counts
- missing values
- duplicate records
- data types
- numerical ranges

This is critical because bad data creates misleading conclusions. In analytics, trust in the dataset is the foundation of every recommendation.

### 3) Clean and normalize the dataset
The cleaning script addresses:

- inconsistent column names
- empty columns
- duplicate rows
- whitespace issues
- missing values
- invalid numeric values
- feature engineering such as `duration_minutes` and `explicit_flag`

This step ensures that the dataset is reliable and ready for downstream analysis.

### 4) Explore patterns with visual analysis
The EDA stage creates charts such as:

- top genres by count
- popularity distribution
- energy distribution
- danceability distribution
- energy vs danceability relationship
- valence vs popularity relationship
- top artists by frequency

These charts help analysts identify structure and relationships in the music catalog.

### 5) Turn the data into business insight
Instead of only reporting raw numbers, the project converts findings into concise business statements, including:

- Total tracks analyzed
- Average popularity
- Most popular track
- Most frequent artist
- Most represented genre
- Highest-performing genre by popularity
- Average energy, danceability, valence, and tempo
- Share of explicit tracks

### 6) Store the results in SQL for business queries
The database creation and SQL query stage adds repeatability. Analysts can interrogate the cleaned dataset using SQL to answer business questions repeatedly, without reprocessing raw files.

### 7) Package outputs for stakeholders
The project exports:

- cleaned CSV
- summary CSV
- insight text report
- generated charts
- SQLite database
- Excel workbook with business query results
- Power BI dashboard

This makes the work usable for both technical and non-technical stakeholders.

## Main Scripts

### 1. Data Check
File: `Python/01_data_check.py`

Purpose:
- load the raw dataset
- inspect structure, quality, and completeness
- save a text-based validation report

### 2. Data Cleaning
File: `Python/02_data_cleaning.py`

Purpose:
- standardize dataset schema
- remove duplicates and invalid rows
- handle missing values
- create additional derived fields
- save cleaned output

### 3. Exploratory Data Analysis
File: `Python/03_eda.py`

Purpose:
- visualize key distributions and relationships
- produce charts for analysis and presentation

### 4. Insight Generation
File: `Python/04_insights.py`

Purpose:
- summarize the dataset into KPI-style insights
- write a business summary report

### 5. Database Creation
File: `Python/05_create_database.py`

Purpose:
- load the cleaned CSV into SQLite
- create indexes for efficient SQL analysis
- validate table integrity

### 6. Business Queries Runner
File: `Python/06_run_business_queries.py`

Purpose:
- execute SQL business questions
- export results to Excel

## SQL Files

- `SQL/01_create_database.sql` – initializes the database table and indexes
- `SQL/02_data_exploration.sql` – initial descriptive analytics
- `SQL/03_business_queries.sql` – advanced business analysis queries

## Output Files

- `Output/spotify_cleaned.csv` – cleaned and standardized dataset
- `Output/data_summary.csv` – high-level data quality summary
- `Output/insights.txt` – KPI and insight narrative
- `Output/genre_summary.csv` – genre-level popularity summary
- `Output/Charts/` – visualization exports
- `Output/SQL_Business_Results.xlsx` – SQL query results in Excel format
- `SQL/spotify_analysis.db` – SQLite database used for analytics

## Key Findings from the Current Analysis

The project already reveals several meaningful patterns:

- Total tracks analyzed: 113,550
- Average track popularity: 33.32
- Highest popularity track: Unholy (feat. Kim Petras)
- Most frequent artist in the dataset: The Beatles (279 tracks)
- Most represented genre: acoustic (1,000 tracks)
- Best average popularity by genre: pop-film (59.28)
- Average energy: 0.642
- Average danceability: 0.567
- Average valence: 0.474
- Average tempo: 122.18 BPM
- Explicit tracks: 8.56% of the catalog

These findings are useful for understanding not only music trends but also how catalog characteristics influence listener appeal.

## How to Run the Project

From the project root, run the scripts in order:

```bash
python .\Python\01_data_check.py
python .\Python\02_data_cleaning.py
python .\Python\03_eda.py
python .\Python\04_insights.py
python .\Python\05_create_database.py
python .\Python\06_run_business_queries.py
```

## Dependencies

This project uses Python libraries such as:

- pandas
- matplotlib
- sqlite3 (built into Python)
- openpyxl

## Final Reflection

This project demonstrates a strong end-to-end analytics workflow: the analyst identifies the business question, verifies data integrity, cleans data with discipline, explores the signal in the dataset, and delivers clear, decision-oriented findings. The result is not just raw technical output—it is a structured analytical story that can inform content strategy, audience understanding, and business decisions.

## Dashboard

The repository also includes a Power BI dashboard in:

- `Power BI/SPOTIFY DASHBOARD.pbix`

This visual layer extends the analysis into a stakeholder-friendly summary format, suitable for presentation and decision-making.
#   S p o t i f y _ D a t a _ A n a l y s i s  
 