DROP SCHEMA IF EXISTS shakespeare CASCADE;
CREATE SCHEMA shakespeare;
SET search_path TO shakespeare, public;

CREATE TABLE work
  ( id    VARCHAR(32) PRIMARY KEY,
    title     VARCHAR(32) NOT NULL,
    long_title VARCHAR(64) NOT NULL,
    year      INTEGER NOT NULL,
    genre_type VARCHAR(1) NOT NULL,
    notes     TEXT,
    source    VARCHAR(16) NOT NULL,
    total_words      INTEGER NOT NULL,
    total_paragraphs INTEGER NOT NULL
  );

\copy work FROM 'opensourceshakespeare/Works.txt' WITH (FORMAT csv, QUOTE '~')


CREATE TABLE character 
  ( id      VARCHAR(32) PRIMARY KEY,
    name    VARCHAR(64) NOT NULL,
    abbrev      VARCHAR(32),
    work_ids_string       VARCHAR(256) NOT NULL,
    description VARCHAR(2056),
    speech_count INTEGER NOT NULL
  );

\copy character FROM 'opensourceshakespeare/Characters.txt' WITH (FORMAT csv, QUOTE '~')

CREATE TABLE character_work
  ( character_id     VARCHAR(32) NOT NULL REFERENCES character,
    work_id     VARCHAR(32) NOT NULL REFERENCES work,
    PRIMARY KEY (character_id, work_id)
  );

INSERT INTO character_work (character_id, work_id)
SELECT id,
       regexp_split_to_table(work_ids_string, ',')
FROM   character;

ALTER TABLE character DROP COLUMN work_ids_string;

CREATE TABLE chapter 
  ( id      INTEGER PRIMARY KEY,
    work_id         VARCHAR(32) NOT NULL REFERENCES work,
    section_number        INTEGER NOT NULL,
    chapter_number        INTEGER NOT NULL,
    description    VARCHAR(256) NOT NULL,
    unique (work_id, section_number, chapter_number)
  );

\copy chapter (work_id, id, section_number, chapter_number, description) FROM 'opensourceshakespeare/Chapters.txt' WITH (FORMAT csv, QUOTE '~')

UPDATE chapter SET description = '' WHERE description LIKE '---%';
UPDATE chapter SET description = REPLACE(description, '&#8217;','''');

CREATE TABLE paragraph
  ( id    INTEGER PRIMARY KEY NOT NULL,
    work_id         VARCHAR(32) NOT NULL REFERENCES work,
    paragraph_num   INTEGER NOT NULL,
    character_id         VARCHAR(32) NOT NULL REFERENCES character,
    plain_text      TEXT NOT NULL,
    phonetic_text   TEXT NOT NULL,
    stem_text       TEXT NOT NULL,
    paragraph_type  VARCHAR(1) NOT NULL,
    section_number        INTEGER NOT NULL,
    chapter_number        INTEGER NOT NULL,
    char_count      INTEGER NOT NULL,
    word_count      INTEGER NOT NULL,
    constraint paragraph_chapter_fkey foreign key (work_id, section_number, chapter_number) references chapter (work_id, section_number, chapter_number)
  );


\copy paragraph (work_id, id, paragraph_num, character_id, plain_text, phonetic_text, stem_text, paragraph_type, section_number, chapter_number, char_count, word_count) FROM 'opensourceshakespeare/Paragraphs.txt' WITH (FORMAT csv, QUOTE '~')

CREATE TABLE wordform
  ( id     INTEGER PRIMARY KEY,
    plain_text      VARCHAR(64) NOT NULL,
    phonetic_text   VARCHAR(64) NOT NULL,
    stem_text       VARCHAR(64) NOT NULL,
    occurences     INTEGER NOT NULL
  );

\copy wordform FROM 'opensourceshakespeare/WordForms.txt' WITH (FORMAT csv, QUOTE '~')

-- PostGraphile customisations
comment on constraint paragraph_chapter_fkey on paragraph is E'@fieldName chapter\n@foreignFieldName paragraphs';
