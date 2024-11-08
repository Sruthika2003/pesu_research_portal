drop database pesu_research_portal;
create database pesu_research_portal;
use pesu_research_portal;
CREATE TABLE researcher (
    researcher_id varchar(50) PRIMARY KEY,
    email VARCHAR(120) UNIQUE NOT NULL,
    password VARCHAR(300) NOT NULL,
    f_name VARCHAR(50),
    l_name VARCHAR(50),
    expertise VARCHAR(200),
    affiliation VARCHAR(200)
);

CREATE TABLE research_paper (
    paperid varchar(50) PRIMARY KEY ,
    title VARCHAR(200) NOT NULL,
	authors VARCHAR(50),
    abstract TEXT,
    publication_date date,
	file LONGBLOB,
    publication_venueid varchar(50),
    researcher_id Varchar(50),
    citeid varchar(50),
    FOREIGN KEY (citeid) REFERENCES research_paper(paperid),
    keywords VARCHAR(500),
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id)
);

CREATE TABLE dataset (
    dataset_id varchar(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    meta_data TEXT,
    file LONGBLOB
);

CREATE TABLE publication (
    name VARCHAR(200) NOT NULL,
    publication_venue_id VARCHAR(50) primary key,
    publication_type ENUM('journal', 'conference') NOT NULL
);

CREATE TABLE project (
    project_id varchar(50) primary key,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    creator_id Varchar(50),
    FOREIGN KEY (creator_id) REFERENCES researcher(researcher_id)
);

CREATE TABLE collaboration (
    collaboration_id Varchar(50) Primary key,
    role VARCHAR(50),
    join_date DATE,
    project_id Varchar(50),
    FOREIGN KEY (project_id) REFERENCES project(project_id)
    
);

CREATE TABLE reviewer (
    reviewer_id VARCHAR(50) primary key,
    f_name VARCHAR(50),
    l_name VARCHAR(50),
	comments TEXT,
    paper_id varchar(50),
    Foreign key (paper_id) references research_paper(paperid)
    
);

CREATE TABLE funding_source (
	funding_source_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(200),
    organization VARCHAR(200)
   
);

-- Association Tables
CREATE TABLE authored (
    researcher_id varchar(50),
    paper_id varchar(50),
    PRIMARY KEY (researcher_id, paper_id),
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id),
    FOREIGN KEY (paper_id) REFERENCES research_paper(paperid)
);

CREATE TABLE has_dataset (
    paper_id varchar(50),
    dataset_id varchar(50),
    PRIMARY KEY (paper_id, dataset_id),
    FOREIGN KEY (paper_id) REFERENCES research_paper(paperid),
    FOREIGN KEY (dataset_id) REFERENCES dataset(dataset_id)
);

CREATE TABLE project_funding (
    project_id varchar(50),
    funding_source_id varchar(50),
    PRIMARY KEY (project_id, funding_source_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id),
    FOREIGN KEY (funding_source_id) REFERENCES funding_source(funding_source_id)
);

DELIMITER //
CREATE TRIGGER set_registration_date 
BEFORE INSERT ON researcher
FOR EACH ROW
BEGIN
    SET NEW.registration_date = CURRENT_TIMESTAMP;
END//
DELIMITER ;



DELIMITER //

CREATE FUNCTION generate_paper_id() 
RETURNS CHAR(36)
DETERMINISTIC
BEGIN
  RETURN UUID();
END //

DELIMITER ;

select paperid,title, authors, abstract, publication_date, publication_venueid,downloads from research_paper;

ALTER TABLE research_paper
ADD COLUMN downloads INT DEFAULT 0;

desc research_paper;
desc funding_source;

ALTER TABLE collaboration ADD COLUMN researcher_id VARCHAR(50);
ALTER TABLE collaboration ADD COLUMN status ENUM('pending', 'accepted', 'declined') DEFAULT 'pending';
ALTER TABLE collaboration ADD FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id);

select * from funding_source;
desc researcher;
desc dataset;

ALTER TABLE dataset
ADD COLUMN researcher_id VARCHAR(50),
ADD CONSTRAINT fk_researcher
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id);


DELIMITER //

CREATE FUNCTION generate_funding_source_id() 
RETURNS CHAR(36)
DETERMINISTIC
BEGIN
  RETURN UUID();
END //

DELIMITER ;