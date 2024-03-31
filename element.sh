#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -X -c"
TYPE="name"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 -ge 1 && $1 -le 118 ]]
  then
    TYPE="atomic_number"
  elif [[ $(echo $1 | wc -m) -le 4 && "$1" != "Tin" ]]
  then
    TYPE="symbol"
  fi
  ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE $TYPE = '$1'")"
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TABLE="elements inner join properties using(atomic_number) inner join types using(type_id)"
    NAME="$($PSQL "SELECT name FROM $TABLE WHERE $TYPE = '$1'")"
    SYMBOL="$($PSQL "SELECT symbol FROM $TABLE WHERE $TYPE = '$1'")"
    ELEMENT_TYPE="$($PSQL "SELECT type FROM $TABLE WHERE $TYPE = '$1'")"
    MASS="$($PSQL "SELECT atomic_mass FROM $TABLE WHERE $TYPE = '$1'")"
    MELTING_POINT="$($PSQL "SELECT melting_point_celsius FROM $TABLE WHERE $TYPE = '$1'")"
    BOILING_POINT="$($PSQL "SELECT boiling_point_celsius FROM $TABLE WHERE $TYPE = '$1'")"

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $ELEMENT_TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
