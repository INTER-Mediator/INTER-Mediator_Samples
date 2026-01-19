/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using PostgreSQL, encoded by UTF-8.

Example:
$ psql -c 'create database imapp_account;' -h localhost postgres
$ psql -f schema_basic.sql -h localhost imapp_account
$ psql -f schema_views.sql -h localhost imapp_account
$ psql -f schema_initial_data.sql -h localhost imapp_account
*/
DROP USER IF EXISTS im_db_user;
CREATE USER im_db_user PASSWORD 'iex2TahseiLu4Iu5Quoow7sh';
DROP SCHEMA IF EXISTS imapp CASCADE;
CREATE SCHEMA imapp;
SET search_path TO imapp,public;
ALTER USER im_db_user SET search_path TO imapp,public;

GRANT ALL PRIVILEGES ON SCHEMA
imapp TO im_db_user;

CREATE TABLE person
(
    person_id   SERIAL PRIMARY KEY,
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
GRANT ALL PRIVILEGES ON imapp.person TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.person_person_id_seq TO im_db_user;

CREATE INDEX person_family_name
    ON person (family_name);
CREATE INDEX person_given_name
    ON person (given_name);
CREATE INDEX person_zip
    ON person (zip);
CREATE INDEX person_prefecture
    ON person (prefecture);
CREATE INDEX person_city
    ON person (city);
CREATE INDEX person_town
    ON person (town);
CREATE INDEX person_address
    ON person (address);
CREATE INDEX person_place_name
    ON person (place_name);
CREATE INDEX person_tel
    ON person (tel);
CREATE INDEX person_mobile
    ON person (mobile);
CREATE INDEX person_mail
    ON person (mail);

/* Observable */
CREATE TABLE registeredcontext
(
    id           SERIAL PRIMARY KEY,
    clientid     TEXT,
    entity       TEXT,
    conditions   TEXT,
    registereddt TIMESTAMP
);
GRANT ALL PRIVILEGES ON imapp.registeredcontext TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.registeredcontext_id_seq TO im_db_user;

CREATE TABLE registeredpks
(
    context_id INTEGER,
    pk         INTEGER,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
);
GRANT ALL PRIVILEGES ON imapp.registeredpks TO im_db_user;

CREATE INDEX registeredpks_context_id
    ON registeredpks (context_id);
CREATE INDEX registeredpks_pk
    ON registeredpks (pk);


CREATE TABLE authuser
(
    id              SERIAL PRIMARY KEY,
    username        TEXT,
    hashedpasswd    TEXT,
    email           TEXT,
    realname        TEXT,
    limitdt         TIMESTAMP,
    address         TEXT,
    birthdate       CHAR(8),
    gender          CHAR(1),
    sub             TEXT,
    initialPassword TEXT,
    publicKey       TEXT,
    accessToken     TEXT
);
GRANT ALL PRIVILEGES ON imapp.authuser TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.authuser_id_seq TO im_db_user;

CREATE INDEX authuser_username
    ON authuser (username);
CREATE INDEX authuser_email
    ON authuser (email);
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

CREATE TABLE authgroup
(
    id        SERIAL PRIMARY KEY,
    groupname TEXT
);
GRANT ALL PRIVILEGES ON imapp.authgroup TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.authgroup_id_seq TO im_db_user;

CREATE TABLE authcor
(
    id            SERIAL PRIMARY KEY,
    user_id       INTEGER,
    group_id      INTEGER,
    dest_group_id INTEGER,
    privname      TEXT
);
GRANT ALL PRIVILEGES ON imapp.authcor TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.authcor_id_seq TO im_db_user;

CREATE INDEX authcor_user_id
    ON authcor (user_id);
CREATE INDEX authcor_group_id
    ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
    ON authcor (dest_group_id);

CREATE TABLE issuedhash
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER,
    clienthost TEXT,
    hash       TEXT,
    expired    TIMESTAMP
);
GRANT ALL PRIVILEGES ON imapp.issuedhash TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.issuedhash_id_seq TO im_db_user;

CREATE INDEX issuedhash_user_id
    ON issuedhash (user_id);
CREATE INDEX issuedhash_expired
    ON issuedhash (expired);
CREATE INDEX issuedhash_clienthost
    ON issuedhash (clienthost);
CREATE INDEX issuedhash_user_id_clienthost
    ON issuedhash (user_id, clienthost);

/* Operation Log Store */
CREATE TABLE operationlog
(
    id            SERIAL PRIMARY KEY,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "user"        VARCHAR(48),
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
GRANT ALL PRIVILEGES ON imapp.operationlog TO im_db_user;
GRANT ALL PRIVILEGES ON imapp.operationlog_id_seq TO im_db_user;
