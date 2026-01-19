#!/bin/sh

DB_ENGINE="mysql" # mysql or postgresql
DB_NAME="imapp_db"

myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")

sudoReq=""
platform=$(uname -a)
if [[ "${platform}" =~ "Linux" ]]; then
  sudoReq="sudo"
fi
if [[ "${platform}" =~ "Darwin" ]]; then
  sudoReq=""
fi

read -p "Do you want to create database (initializing database), type 'YES'. -->" choice
if [ "${choice}" = "YES" ]; then
  if [[ "${DB_ENGINE}" =~ "mysql" ]]; then
    schemaDir="${appRootDir}/lib/MySQL_Schema"
    cd "${schemaDir}"
    ${sudoReq} mysql -uroot <schema_basic.sql
    ${sudoReq} mysql -uroot ${DB_NAME} <schema_views.sql
    ${sudoReq} mysql -uroot ${DB_NAME} <schema_initial_data.sql
  elif [[ "${DB_ENGINE}" =~ "postgresql" ]]; then
    schemaDir="${appRootDir}/lib/PostgreSQL_Schema"
    cd "${schemaDir}"
    ${sudoReq} psql --quiet -c "create database ${DB_NAME};" -h localhost postgres
    ${sudoReq} psql --quiet -f schema_basic.sql -h localhost ${DB_NAME}
    ${sudoReq} psql --quiet -f schema_views.sql -h localhost ${DB_NAME}
    ${sudoReq} psql --quiet -f schema_initial_data.sql -h localhost ${DB_NAME}
  fi
fi
