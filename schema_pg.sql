DROP TABLE IF EXISTS works_raw CASCADE;
CREATE TABLE works_raw
  ( workID    VARCHAR(32) PRIMARY KEY,
    title     VARCHAR(200) NOT NULL,
    longTitle VARCHAR(1000),
    year      INTEGER,
    genreType VARCHAR(10),
    notes     TEXT,
    source    VARCHAR(100),
    totalWords      INTEGER,
    totalParagraphs INTEGER
  );

COPY works_raw FROM '/tmp/opensourceshakespeare/Works.txt'
  WITH (FORMAT csv,
        QUOTE '~');

