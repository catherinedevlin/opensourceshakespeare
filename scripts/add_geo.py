# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pandas>=3.0.5",
# ]
# ///

# Creates a SQLite dump of the Postgres database. 

import pandas as pd
import csv
from pathlib import Path 
import sqlite3

SCHEMA = 'shakespeare'
DB_PATH=Path("shakespeare.db")

CHAPTER_GEO_DDL = """


    CREATE TABLE IF NOT EXISTS geo (
        name TEXT PRIMARY KEY,
        latitude NUMERIC,
        longitude NUMERIC
        );



    CREATE TABLE IF NOT EXISTS chapter_geo (
        geo_name TEXT,
        chapter_id BIGINT,
        FOREIGN KEY (geo_name) REFERENCES geo (name),
        FOREIGN KEY (chapter_id) REFERENCES chapter (id)
        );

"""

cities_csv = pd.read_csv("european_cities.csv")


with sqlite3.connect(DB_PATH) as con:
    curs = con.cursor()
    inner_curs = con.cursor()
    curs.executescript(CHAPTER_GEO_DDL) 
    for (id, description) in curs.execute("SELECT id, description FROM chapter"):
        try:
            city_name = description.split()[0]
        except IndexError:
            continue
        if not city_name.endswith('.'):
            continue 
        city_name = city_name[:-1]
        try:
            city = cities_csv[cities_csv.city == city_name].iloc[0]
        except IndexError:
            continue 
        inner_curs.execute("SELECT * FROM geo WHERE name = :name", {'name': city_name})
        if not (geo := inner_curs.fetchone()):
            inner_curs.execute("""
                INSERT INTO geo (name, latitude, longitude)
                VALUES (:name, :latitude, :longitude)
            """, {'name': city_name, "latitude": city.latitude, "longitude": city.longitude})
        inner_curs.execute("""INSERT INTO chapter_geo (geo_name, chapter_id)
        VALUES (:geo_name, :chapter_id)
        """, {"geo_name": city_name, "chapter_id": id})


