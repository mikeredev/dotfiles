#!/bin/bash
# call directly or via ./script.sh -option [ID|display name]

# define the directory path for saved images
screenshot_directory=~/pictures/screenshots

# define the timestamp string for filenames
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# declare an associative array with ID and friendly display name pairs
declare -A options
options=([1]="copy area" [2]="copy full" [3]="save area" [4]="save full")


# function to perform an action based on the selected ID
action() {
    case $1 in
        1) # copy area of screen, don't save
            if scrot -s /tmp/screenshot.png; then
                xclip -selection clipboard -t image/png /tmp/screenshot.png
                rm /tmp/screenshot.png
                dunstify -a manage-screenshot "screenshot copied 📷" "selected area copied to clipboard"
            else
                exit 0
            fi
            ;;
        2) # copy fullscreen image, don't save
            killall -q rofi  # close rofi so it isn't in the screenshot
            sleep 0.4        # add a short delay to allow rofi to close
            if scrot /tmp/screenshot.png; then
                xclip -selection clipboard -t image/png /tmp/screenshot.png
                rm /tmp/screenshot.png
                dunstify -a manage-screenshot "screenshot copied 📷" "fullscreen image copied to clipboard"
            else
                exit 0
            fi
            ;;
        3) # copy area of screen and save to user screenshots folder
            if scrot -s /tmp/screenshot.png; then
                xclip -selection clipboard -t image/png /tmp/screenshot.png
                mv /tmp/screenshot.png "$screenshot_directory/screenshot_${timestamp}.png"
                dunstify -a manage-screenshot "screenshot saved 📷" "$screenshot_directory/screenshot_${timestamp}.png"
            else
                exit 0
            fi
            ;;
        4) # copy fullscreen image and save to user screenshots folder
            killall -q rofi
            sleep 0.4
            if scrot /tmp/screenshot.png; then
                xclip -selection clipboard -t image/png /tmp/screenshot.png
                mv /tmp/screenshot.png "$screenshot_directory/screenshot_${timestamp}.png"
                dunstify -a manage-screenshot "screenshot saved 📷" "$screenshot_directory/screenshot_${timestamp}.png"
            else
                exit 0
            fi
            ;;
        *)
            echo "Invalid option selected."
            ;;
    esac
}


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -option)
            shift
            selected_option=$1
            
            # Check if the provided option is a valid ID or friendly name
            found=false
            for id in "${!options[@]}"; do
                if [[ "$selected_option" == "$id" || "$selected_option" == "${options[$id]}" ]]; then
                    action "$id"
                    found=true
                    break
                fi
            done

            if [[ "$found" != true ]]; then
                echo "Invalid option: $selected_option"
            fi
            ;;
        *)
            echo "Invalid argument: $1"
            ;;
    esac
    shift
done


# if no arguments were provided, display options using rofi
if [[ ! -n "$selected_option" ]]; then
    # create a string containing the friendly display names in order of ID
    options_str=""
    total_options=${#options[@]}
    for id in $(seq 1 $total_options); do
        options_str+="$id: ${options[$id]}"
        if [ "$id" -lt "$total_options" ]; then
            options_str+="\n"
        fi
    done

    # use rofi to display the options and store the selected ID in the variable 'selected_id'
    selected_id=$(echo -e "$options_str" | rofi -dmenu -p "screenshot" | cut -d ':' -f 1)

    # check if a valid option was selected
    if [[ -n "$selected_id" && "${options[$selected_id]}" ]]; then
        selected_display_name="${options[$selected_id]}"
        echo "You selected: ID=$selected_id, Display Name=$selected_display_name"
        action "$selected_id"
    else
        echo "No option selected."
    fi
fi
