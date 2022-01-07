# Creates a SQLite dump of the Postgres database. 

import pandas as pd

tables = """chapter
character
character_work
paragraph 
wordform 
work""".split()

for table in tables:
    df = pd.read_sql(table, 'postgresql://postgres:longliveliz@127.0.0.1/shakes')
    df.to_sql(table, 'sqlite:///shakespeare.db', if_exists='replace')

