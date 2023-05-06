#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Functions to get info by different inputs
GET_BY_ATOMIC_NUMBER() {
  #Checking that a corresponding element exists
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  if [[ -z $NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    #Getting name and symbol from the elements table
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $NUMBER;")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $NUMBER;")
    GET_INFO
  fi
}

GET_BY_ATOMIC_SYMBOL() {
  #Checking that a corresponding element exists
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1';")
  if [[ -z $SYMBOL ]]
  then
    echo "I could not find that element in the database."
  else
    #Getting name and atomic number from the elements table
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL';")
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL';")
    GET_INFO
  fi
}

GET_BY_NAME() {
  #Checking that a corresponding element exists
  NAME=$($PSQL "SELECT name FROM elements WHERE name ILIKE '$1';")
  if [[ -z $NAME ]]
  then
    echo "I could not find that element in the database."
  else
    #Getting name and atomic number from the elements table
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name ILIKE '$NAME';")
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name ILIKE '$NAME';")
    GET_INFO
  fi
}

GET_INFO(){
    #Getting boiling point, melting point, mass from properties
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER;")
    #Getting type from types
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $NUMBER;")
    PRINT_RESULTS
}

PRINT_RESULTS(){
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

#Checking that an argument was passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #Checking if an atomic number was passed
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_BY_ATOMIC_NUMBER $1
  else
    #Checking if an atomic symbol was passed
    if [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
    then
      GET_BY_ATOMIC_SYMBOL $1
    else
      #Trying to use the argument as an element name
      GET_BY_NAME $1
    fi
  fi
fi