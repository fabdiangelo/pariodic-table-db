#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ ! $1 ]] 
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1") 
  else
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
    if [[ -z $ELEMENT ]] 
    then
      ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
    fi
  fi
  if [[ $ELEMENT ]] 
  then  
    echo "$ELEMENT" | while read ATOMIC_NUMBER bar SYMBOL bar NAME bar  TYPE_ID bar MASS bar MELTING bar BOILING
    do
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") 
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi