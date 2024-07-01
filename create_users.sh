#!/bin/bash

# Script: create_users.sh
# Description: Creates users and groups based on input file, sets up home directories, generates random passwords, and logs actions.

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input-file>"
    exit 1
fi

input_file=$1
log_file="/var/log/user_management.log"
password_file="/var/secure/user_passwords.csv"

# Ensure log directory exists
mkdir -p "$(dirname "$log_file")"

# Ensure password file directory exists and set permissions
mkdir -p "$(dirname "$password_file")"
touch "$password_file"
chmod 600 "$password_file"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Function to generate random password
generate_password() {
    tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 12
}

# Read input file and process each line
while IFS=';' read -r username groups || [[ -n "$username" ]]; do
    # Remove leading/trailing whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    # Skip empty lines
    [ -z "$username" ] && continue

    # Create user's personal group
    if ! getent group "$username" > /dev/null 2>&1; then
        groupadd "$username"
        log_action "Created personal group: $username"
    else
        log_action "Personal group already exists: $username"
    fi

    # Create user if not exists
    if ! id "$username" &>/dev/null; then
        password=$(generate_password)
        useradd -m -g "$username" -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        echo "$username,$password" >> "$password_file"
        log_action "Created user: $username"
    else
        log_action "User already exists: $username"
    fi

    # Add user to additional groups
    IFS=',' read -ra group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs)
        if [ -n "$group" ]; then
            if ! getent group "$group" > /dev/null 2>&1; then
                groupadd "$group"
                log_action "Created group: $group"
            fi
            usermod -a -G "$group" "$username"
            log_action "Added $username to group: $group"
        fi
    done

    # Set home directory permissions
    chown -R "$username:$username" "/home/$username"
    chmod 700 "/home/$username"
    log_action "Set permissions for /home/$username"

done < "$input_file"

echo "User creation process completed. Check $log_file for details."
