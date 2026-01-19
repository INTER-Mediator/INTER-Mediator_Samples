/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using MySQL, encoded by UTF-8.

Example:
$ mysql -u root -p < schema_basic.sql
Enter password:
mysql -uroot imapp_db < schema_views.sql
mysql -uroot imapp_db < schema_initial_data.sql

*/
SET NAMES 'utf8mb4';

DROP
USER IF EXISTS 'im_db_user'@'localhost';
CREATE
USER 'im_db_user'@'localhost' IDENTIFIED BY 'iex2TahseiLu4Iu5Quoow7sh';

# Grant to All operations for all objects with web account
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE imapp_db.* TO 'im_db_user'@'localhost';
GRANT SHOW VIEW ON TABLE imapp_db.* TO 'im_db_user'@'localhost';
# For mysqldump, the SHOW VIEW privilege is just required, and use options --single-transaction and --no-tablespaces.

DROP DATABASE IF EXISTS imapp_db;
CREATE DATABASE imapp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE imapp_db;

CREATE TABLE person
(
    person_id   INTEGER PRIMARY KEY AUTO_INCREMENT,
    family_name TEXT,
    given_name  TEXT,
    zip         TEXT,
    prefecture  TEXT,
    city        TEXT,
    town        TEXT,
    address     TEXT,
    place_name  TEXT,
    tel         TEXT,
    mobile      TEXT,
    mail        TEXT,
    photo       TEXT
);

CREATE INDEX person_family_name
    ON person (family_name(100));
CREATE INDEX person_given_name
    ON person (given_name(100));
CREATE INDEX person_zip
    ON person (zip(100));
CREATE INDEX person_prefecture
    ON person (prefecture(100));
CREATE INDEX person_city
    ON person (city(100));
CREATE INDEX person_town
    ON person (town(100));
CREATE INDEX person_address
    ON person (address(100));
CREATE INDEX person_place_name
    ON person (place_name(100));
CREATE INDEX person_tel
    ON person (tel(100));
CREATE INDEX person_mobile
    ON person (mobile(100));
CREATE INDEX person_mail
    ON person (mail(100));

/* INTER-Mediator managed tables */
/* Observable */
CREATE TABLE registeredcontext
(
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    clientid     TEXT,
    entity       TEXT,
    conditions   TEXT,
    registereddt DATETIME
);

CREATE TABLE registeredpks
(
    context_id INTEGER,
    pk         INTEGER,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX registeredpks_context_id
    ON registeredpks (context_id);
CREATE INDEX registeredpks_pk
    ON registeredpks (pk);

/* Authentication */
CREATE TABLE authuser
(
    id              INTEGER PRIMARY KEY AUTO_INCREMENT,
    username        TEXT,
    hashedpasswd    TEXT,
    email           TEXT,
    realname        TEXT,
    limitdt         DateTime,
    address         TEXT,
    birthdate       CHAR(8),
    gender          CHAR(1),
    sub             TEXT,
    initialPassword TEXT,
    publicKey       TEXT,
    accessToken     TEXT
);

CREATE INDEX authuser_username
    ON authuser (username(100));
CREATE INDEX authuser_email
    ON authuser (email(100));
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

CREATE TABLE authgroup
(
    id        INTEGER PRIMARY KEY AUTO_INCREMENT,
    groupname TEXT
);

CREATE TABLE authcor
(
    id            INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id       INTEGER,
    group_id      INTEGER,
    dest_group_id INTEGER,
    privname      TEXT
);

CREATE INDEX authcor_user_id
    ON authcor (user_id);
CREATE INDEX authcor_group_id
    ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
    ON authcor (dest_group_id);

CREATE TABLE issuedhash
(
    id         INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id    INTEGER,
    clienthost TEXT,
    hash       TEXT,
    expired    DateTime
);

CREATE INDEX issuedhash_user_id
    ON issuedhash (user_id);
CREATE INDEX issuedhash_expired
    ON issuedhash (expired);
CREATE INDEX issuedhash_clienthost
    ON issuedhash (clienthost(100));
CREATE INDEX issuedhash_user_id_clienthost
    ON issuedhash (user_id, clienthost(100));

/* Operation Log Store */
CREATE TABLE operationlog
(
    id            INTEGER PRIMARY KEY AUTO_INCREMENT,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user          VARCHAR(48),
    client_id_in  VARCHAR(48),
    client_id_out VARCHAR(48),
    require_auth  BIT(1),
    set_auth      BIT(1),
    client_ip     VARCHAR(60),
    path          VARCHAR(256),
    access        VARCHAR(20),
    context       VARCHAR(50),
    get_data      TEXT,
    post_data     TEXT,
    result        TEXT,
    error         TEXT,
    key_value     INTEGER,
    edit_field    VARCHAR(20),
    edit_value    TEXT
);
