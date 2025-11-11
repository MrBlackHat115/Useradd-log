#!/usr/bin/env bash
# useradd-log: Logs user creation and notifies admin

LOGFILE="/var/log/user_creation.log" # Path to the log file where all user creation events will be stored
REAL_USERADD="/usr/sbin/useradd.real" # Path to the real 'useradd' binary (used because this script replaces 'useradd')
ADMIN_USER="mrblackhat"  # Change to your username or email 
# Username of the admin to notify; can be replaced with an email address

# If the real binary isn't renamed yet, point to default
if [ ! -x "$REAL_USERADD" ]; then   
    REAL_USERADD="/usr/sbin/useradd"
fi
# Checks if REAL_USERADD exists and is executable
# If not, fall back to default system 'useradd' binary

# Run the real useradd command with all original arguments
"$REAL_USERADD" "$@"
RESULT=$?
# "$@" passes all arguments exactly as typed (username, options, etc.)
# RESULT stores the exit status of the command (0=success, non-zero=failure)

if [ $RESULT -eq 0 ]; then # Only execute logging/notification if user creation succeeded
    USER_CREATED="${@: -1}" # Gets the last argument passed to the command (usually the new username)
    RUNBY="$(whoami)" # Captures the username of the person running the script
    TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')" # Stores the current date and time in a readable format
    echo "$TIMESTAMP | User created: $USER_CREATED by $RUNBY" >> "$LOGFILE" # Appends a log entry to LOGFILE with timestamp, username, and who ran it

    # Notify admin in real-time
    if command -v wall &>/dev/null; then
        echo "[ALERT] User '$USER_CREATED' was created by $RUNBY at $TIMESTAMP" | wall
    fi
    # Checks if 'wall' command exists
    # Sends a broadcast message to all logged-in users (or admin) with alert

    # Optional: Email notification if mail is configured
    # echo "User '$USER_CREATED' created by $RUNBY on $(hostname) at $TIMESTAMP" | mail -s "New User Created" $ADMIN_USER
    # Uncomment this line if system mail is configured to send email alerts to admin
fi

exit $RESULT
# Exits the script with the same status as the original 'useradd'
# Ensures normal behavior: if user creation fails, the wrapper fails too
