""" manage-wifi-rofi.py
desc:       rofi wifi connection manager for i3
requires:   rofi
usage:      python manage-wifi-rofi.py
i3:         bindsym $mod+m exec --no-startup-id sh -c 'python manage-wifi-rofi.py'
"""

# import modules
import subprocess

# set constants
custom_theme = "~/.config/rofi/themes/sidebar.rasi"


# function to run a shell command
def run_command(cmd):
    try:
        output = subprocess.run(cmd, shell=True)
    except subprocess.CalledProcessError as e:
        return f"Command execution failed: {e.output.decode().strip()}"


# function to get list of SSIDs
def get_wifi_networks():
    try:
        output = subprocess.check_output(
            ["nmcli", "-t", "-f", "IN-USE,SSID,Signal,Security,Bars", "device", "wifi"]
        )
        networks = output.decode().strip().split("\n")
        wifi_networks = []
        for network in networks:
            in_use, ssid, signal, security, bars = network.split(":")
            if ssid:  # Ignore SSIDs with no name
                bars = bars.rstrip('_')  # Remove trailing underscore
                wifi_networks.append(
                    {
                        "in_use": in_use,
                        "ssid": ssid,
                        "signal": signal,
                        "security": security,
                        "bars": bars,
                    }
                )
        print(wifi_networks)
        return wifi_networks
    except subprocess.CalledProcessError:
        return []


# function to connect to a wifi network
def connect_to_wifi(ssid):
    try:
        run_command(
            f"dunstify -u critical -a manage-wifi 'wifi manager' 'connecting to {ssid}...'")
        subprocess.run(["nmcli", "device", "wifi",
                       "connect", ssid], check=True)
        run_command(
            f"dunstify -a manage-wifi 'wifi manager' '{ssid} connected'"
        )
        run_command("pkill -RTMIN+3 i3blocks")
    except subprocess.CalledProcessError as e:
        run_command(f"dunstify -u critical -a manage-wifi 'wifi manager' 'error: {e}'")


# function to show list of SSIDs in a rofi menu
def show_wifi_menu():
    networks = get_wifi_networks()
    menu_items = []
    for network in networks:
        ssid = network["ssid"]
        signal = network["signal"]
        security = network["security"]
        bars = network["bars"]
        if network["in_use"] == "*":
            ssid += " "
        ssid_menu_item = f"{bars} {signal}% [{security}] {ssid}"
        menu_items.append(ssid_menu_item)

    menu_items_str = "\n".join(menu_items)

    rofi_cmd = [
        "rofi", "-dmenu", "-i", "-p", "  ", "-lines", str(
            len(menu_items)), "-theme", custom_theme
    ]

    process = subprocess.Popen(
        rofi_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, encoding="utf-8"
    )

    run_command(
        "dunstify -a manage-wifi 'wifi manager' 'network scan complete' -t 1")
    selected_network, _ = process.communicate(input=menu_items_str)
    selected_network = selected_network.strip().split(
        " ")[-1]  # Get the last element

    if selected_network:
        connect_to_wifi(selected_network)


def main():
    run_command(
        "dunstify -u critical -a manage-wifi 'wifi manager' 'scanning, please wait...'"
    )
    show_wifi_menu()


# main
if __name__ == "__main__":
    main()
