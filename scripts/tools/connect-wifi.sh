#!/bin/bash
# requires: nmcli, rofi, dunst

# Display an initial notification (scan can take a few seconds)
dunstify -a manage-wifi "scanning 🤔" "this may take a few moments..."

# Run the nmcli command and store the output in an array
readarray -t wifi_info_array < <(nmcli -t -f "Signal,SSID,Security,IN-USE" device wifi)

# Declare an array to store formatted Wi-Fi information
formatted_wifi=()

# Iterate over each line in the output
for line in "${wifi_info_array[@]}"; do
    # Check if the SSID column is empty before formatting
    if [ -n "$(echo "$line" | cut -d':' -f2)" ]; then
        # Extract individual fields
        signal=$(echo "$line" | cut -d':' -f1)
        ssid=$(echo "$line" | cut -d':' -f2)
        security=$(echo "$line" | cut -d':' -f3)
        in_use=$(echo "$line" | cut -d':' -f4)

        # Use text/glyph instead of asterisk for In-Use status
        in_use=$(if [ "$in_use" == "*" ]; then echo "(connected)"; else echo ""; fi)

        # Use a padlock emoji if the Security value is not empty
        security=$(if [ -n "$security" ]; then
            echo ""; # Locked padlock
        else
            echo ""; # Open padlock
        fi)
        
        # Format the output
        formatted_line="$security $signal% $ssid $in_use"

        # Add the formatted line to the array
        formatted_wifi+=("$formatted_line")
    fi
done

dunstify -a manage-wifi "scanning..." "complete" -t 1

# Use rofi to display the formatted Wi-Fi information
selected_wifi=$(printf "%s\n" "${formatted_wifi[@]}" | rofi -dmenu -i -p "ssid" -lines 10 -theme "sidebar")

# Check if a Wi-Fi network was selected
if [ -n "$selected_wifi" ]; then
    # Extract the SSID from the selected Wi-Fi information
    selected_ssid=$(echo "$selected_wifi" | cut -d' ' -f3)

    # Print a message indicating the connection attempt
    dunstify -a manage-wifi "$selected_ssid" "connecting..."

    # Connect to the selected Wi-Fi network
    nmcli device wifi connect "$selected_ssid"

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        # If the command was successful, send a success notification
        dunstify -a manage-wifi "$selected_ssid" "connected successfully :)"

        # Update the i3 block displaying the wifi connection
        pkill -RTMIN+3 i3blocks
    else
        # If there was an error, send an error notification
        dunstify -a manage-wifi "$selected_ssid" "error connecting :(" -u critical
    fi

else
    echo "No Wi-Fi network selected. Exiting..."
fi
