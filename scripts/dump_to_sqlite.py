# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pandas>=3.0.5",
#     "psycopg2>=2.9.12",
#     "sqlalchemy>=2.0.51",
# ]
# ///

# Creates a SQLite dump of the Postgres database. 

import pandas as pd
from pathlib import Path 
import sqlite3

SCHEMA = 'shakespeare'
DB_PATH=Path("shakespeare.db")
DB_PATH.unlink(missing_ok=True)
SCHEMA_PATH=Path("schema_sqlite.sql")

with sqlite3.connect(DB_PATH) as con:
    curs = con.cursor()
    curs.executescript(SCHEMA_PATH.read_text())

tables = """chapter
character
character_work
paragraph 
wordform 
work""".split()

for table in tables:
    df = pd.read_sql(f"SELECT * FROM {SCHEMA}.{table}", 'postgresql://postgres:longliveliz@127.0.0.1/shakes')
    df.to_sql(table, 'sqlite:///shakespeare.db', if_exists='append')

