DROP TABLE IF EXISTS work CASCADE;
CREATE TABLE work
  ( workID    VARCHAR(32) PRIMARY KEY,
    title     VARCHAR(32) NOT NULL,
    longTitle VARCHAR(64) NOT NULL,
    year      INTEGER NOT NULL,
    genreType VARCHAR(1) NOT NULL,
    notes     TEXT,
    source    VARCHAR(16) NOT NULL,
    totalWords      INTEGER NOT NULL,
    totalParagraphs INTEGER NOT NULL
  );

COPY work FROM '/tmp/opensourceshakespeare/Works.txt'
  WITH (FORMAT csv,
        QUOTE '~');

DROP TABLE IF EXISTS character CASCADE;
CREATE TABLE character 
  ( charID      VARCHAR(32) PRIMARY KEY,
    charName    VARCHAR(64) NOT NULL,
    abbrev      VARCHAR(32),
    works       VARCHAR(256) NOT NULL,
    description VARCHAR(2056),
    speechCount INTEGER NOT NULL
  );
        
COPY character FROM '/tmp/opensourceshakespeare/Characters.txt'
  WITH (FORMAT csv,
        QUOTE '~');

DROP TABLE IF EXISTS character_work;
CREATE TABLE character_work
  ( charID     VARCHAR(32) NOT NULL REFERENCES character (charID),
    workID     VARCHAR(32) NOT NULL REFERENCES work (workID),
    PRIMARY KEY (charID, workID)
  );

INSERT INTO character_work (charID, workID)
SELECT charID,
       regexp_split_to_table(works, ',')
FROM   character;

ALTER TABLE character DROP COLUMN works;

DROP TABLE IF EXISTS chapter;
CREATE TABLE chapter 
  ( workID         VARCHAR(32) NOT NULL REFERENCES work (workID),
    chapterID      INTEGER PRIMARY KEY,
    section        INTEGER NOT NULL,
    chapter        INTEGER NOT NULL,
    description    VARCHAR(256) NOT NULL
  );

COPY chapter FROM '/tmp/opensourceshakespeare/Chapters.txt'
  WITH (FORMAT csv,
        QUOTE '~');

UPDATE chapter SET description = '' WHERE description LIKE '---%';
UPDATE chapter SET description = REPLACE(description, '&#8217;','''');

DROP TABLE IF EXISTS paragraph;
CREATE TABLE paragraph
  ( workID         VARCHAR(32) NOT NULL REFERENCES work (workID), paragraphID    INTEGER PRIMARY KEY NOT NULL,
    paragraphNum   INTEGER NOT NULL,
    charID         VARCHAR(32) NOT NULL REFERENCES character (charID),
    plainText      TEXT NOT NULL,
    phoneticText   TEXT NOT NULL,
    stemText       TEXT NOT NULL,
    paragraphType  VARCHAR(1) NOT NULL,
    section        INTEGER NOT NULL,
    chapter        INTEGER NOT NULL,
    charCount      INTEGER NOT NULL,
    wordCount      INTEGER NOT NULL
  );

COPY paragraph FROM '/tmp/opensourceshakespeare/Paragraphs.txt'
  WITH (FORMAT csv,
        QUOTE '~');

DROP TABLE IF EXISTS wordform;
CREATE TABLE wordform
  ( wordFormID     INTEGER PRIMARY KEY,
    plainText      VARCHAR(64) NOT NULL,
    phoneticText   VARCHAR(64) NOT NULL,
    stemText       VARCHAR(64) NOT NULL,
    occurences     INTEGER NOT NULL
  );

COPY wordform FROM '/tmp/opensourceshakespeare/WordForms.txt'
  WITH (FORMAT csv,
        QUOTE '~');

