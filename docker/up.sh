#!/bin/bash
set -e

pushd . > /dev/null

# The following line ensure we run from the script folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
eval cd $DIR

export EXTERNAL_VOLUME=~/subsocial_data/archive-pg

export POSTGRES_DB="archive"
export POSTGRES_USER="dev"
export POSTGRES_PASSWORD="123"

while :; do
  case $1 in
    --down)
      time docker-compose kill
      if [[ $2 == 'clean' ]]; then
        echo "Cleaning volumes..."
        docker-compose down -v
        sudo rm -rf $EXTERNAL_VOLUME
      fi
      exit 0
      ;;
    --db-name)
      if [[ -z $2 ]]; then
        echo "Postgres DB value left empty, leaving defaults"
      else
        POSTGRES_DB=$2
        shift
      fi
      ;;
    --db-user)
      if [[ -z $2 ]]; then
        echo "Postgres user value left empty, leaving defaults"
      else
        POSTGRES_USER=$2
        shift
      fi
      ;;
    --db-password)
      if [[ -z $2 ]]; then
        echo "Postgres password value left empty, leaving defaults"
      else
        POSTGRES_PASSWORD=$2
        shift
      fi
      ;;
    -?*)
      printf "Invalid argument provided: "$1"\n\n"

      exit 1
      ;;
    --)
      shift
      break
      ;;
    *)
      time (
        printf "Starting PostgreSQL in background, hang on!\n\n"
        docker-compose up -d $UTILS
      )

      break
      ;;
  esac
  shift
done

echo "PostgreSQL is ready."

popd > /dev/null
