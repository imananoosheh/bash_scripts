#!/bin/bash

# Create an empty array to store the list of previously logged-in users
declare -a previous_users=()

while true; do
  # Get the current date
  date=$(date +%Y-%m-%d)

  # Get a list of users logged in
  users=$(who | awk '{print $1}')

  # Split the current list of users into an array
  current_users=($users)

  # Compare the current list of users to the previous list of users
  for user in "${current_users[@]}"; do
    found=0
    for prev_user in "${previous_users[@]}"; do
      if [ "$user" == "$prev_user" ]; then
        found=1
        break
      fi
    done

    # If the user is not found in the previous list, log the user
    if [ $found -eq 0 ]; then
      echo "$user logged in on $date" >> output.txt
    fi
  done

  # Store the current list of users as the previous list for the next iteration
  previous_users=("${current_users[@]}")

  # Sleep for a specified number of seconds
  sleep 60
done
