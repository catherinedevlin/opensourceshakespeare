
CREATE TABLE work (
	id TEXT PRIMARY KEY, 
	title TEXT, 
	long_title TEXT, 
	year BIGINT, 
	genre_type TEXT, 
	notes TEXT, 
	source TEXT, 
	total_words BIGINT, 
	total_paragraphs BIGINT
);

CREATE TABLE chapter (
	id BIGINT PRIMARY KEY, 
	work_id TEXT, 
	section_number BIGINT, 
	chapter_number BIGINT, 
	description TEXT,
    FOREIGN KEY (work_id) REFERENCES work (id)
);
CREATE INDEX ix_chapter_index ON chapter ("index");

CREATE TABLE character (
	id TEXT PRIMARY KEY, 
	name TEXT, 
	abbrev TEXT, 
	description TEXT, 
	speech_count BIGINT
);
CREATE INDEX ix_character_index ON character ("index");

CREATE TABLE character_work (
	character_id TEXT, 
	work_id TEXT,
    FOREIGN KEY (character_id) REFERENCES character (id),
    FOREIGN KEY (work_id) REFERENCES work (id)
);
CREATE INDEX ix_character_work_index ON character_work ("index");

CREATE TABLE paragraph (
	id BIGINT PRIMARY KEY, 
	work_id TEXT, 
	paragraph_num BIGINT, 
	character_id TEXT, 
	plain_text TEXT, 
	phonetic_text TEXT, 
	stem_text TEXT, 
	paragraph_type TEXT, 
	section_number BIGINT, 
	chapter_number BIGINT, 
	char_count BIGINT, 
	word_count BIGINT,
    FOREIGN KEY (character_id) REFERENCES character (id),
    FOREIGN KEY (work_id) REFERENCES work (id)
);
CREATE INDEX ix_paragraph_index ON paragraph ("index");

CREATE TABLE wordform (
	id BIGINT PRIMARY KEY, 
	plain_text TEXT, 
	phonetic_text TEXT, 
	stem_text TEXT, 
	occurences BIGINT
);
CREATE INDEX ix_wordform_index ON wordform ("index");

