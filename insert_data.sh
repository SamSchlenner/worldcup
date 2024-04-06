#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "truncate table games, teams"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip first line of games.csv
  if [[ $YEAR != year ]]
  then
    # If WINNER not in database
    if [[ -z $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") ]]
    then # Add winner
      WINNER_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $WINNER_INSERT
    fi # If WINNER not in database
    # If OPPONENT not in database
    if [[ -z $($PSQL "select team_id from teams where name='$OPPONENT'") ]]
    then # Add opponent
      OPPONENT_INSERT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      echo $OPPONENT_INSERT
    fi # If OPPONENT not in database
    # Get winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    # Get opponent_id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    # Add game
    GAME_INSERT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) \
    values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    echo $GAME_INSERT
  fi  
done

