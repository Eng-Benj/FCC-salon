#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n<--- Salon Appointment Scheduler --->\n"
echo -e "Welcome to the salon! We offer the following services:"

SELECT_SERVICE() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while IFS=" | " read ID NAME
  do
    echo "$ID) $NAME"
  done
  echo "0) Exit"
  echo -e "\nWhich service number are you interested in?"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    SELECT_SERVICE "Please enter a number 0->3"
  else
    case $SERVICE_ID_SELECTED in
        1) MAKE_APPOINTMENT ;;
        2) MAKE_APPOINTMENT ;;
        3) MAKE_APPOINTMENT ;;
        0) EXIT ;;
        *) SELECT_SERVICE "Please enter a number 0->3" ;;
        esac
  fi
}

MAKE_APPOINTMENT() {
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nAt what time would you like your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  EXIT
}

EXIT() {
  echo -e "\nThanks for stopping by!"
}

SELECT_SERVICE