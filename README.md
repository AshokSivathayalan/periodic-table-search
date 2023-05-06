# periodic-table-search

A PostgreSQL database containing elements and information regarding them, and a Bash script that allows users to view this information.

Created for freeCodeCamp's Relational Databases course.

## Database

Elements - stores atomic number, atomic symbol, and name of elements
Properties - stores boiling point, melting point, atomic mass, and a type foreign key for each atomic number
Types - stores the names of the three types of elements (metal, metalloid, nonmetal)

To create database, run 'psql -U postgres < periodic_table.sql'

## Script

Bash script that allows users to query for element information

Takes in a name, atomic number, or atomic symbol as an argument, and displays all data stored in the properties and elements tables for that element.

To use, run './element.sh [element]'
 
