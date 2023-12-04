""" session-manager-rofi.py
desc:       rofi session manager for i3
requires:   rofi
usage:      session-manager-rofi.py [-h] [--session {lock,suspend,logoff,reboot,poweroff}] [--rofi]
i3 rofi:    bindsym $mod+Shift+l exec --no-startup-id sh -c 'python session-manager-rofi.py --rofi'
i3 lock:    bindsym $mod+l exec --no-startup-id sh -c 'python session-manager-rofi.py --action lock'
"""

# import modules
import subprocess

# set constants
theme = "~/.config/rofi/themes/dmenu.rasi"
lock_background = "~/Pictures/wallpapers/arch_pixel_dark.png"
lock_cmd = f"i3lock -efi {lock_background}"
logoff_cmd = "i3-msg exit"
suspend_cmd = "systemctl suspend"
reboot_cmd = "systemctl reboot"
poweroff_cmd = "systemctl poweroff"
i3_reload_cmd = "i3-msg reload"
i3_restart_cmd = "i3-msg restart"


# function to display options in rofi
def rofi():
    options = ["lock", "suspend", "reload", "restart", "logoff", "reboot", "poweroff"]
    session_cmd = f"rofi -dmenu -i -p i3 -theme {theme}"
    selected_action = subprocess.check_output(session_cmd, input="\n".join(options), text=True, shell=True).strip()

    actions = {
        "lock": lock,
        "suspend": suspend,
        "reload": i3_reload,
        "restart": i3_restart,
        "logoff": logoff,
        "reboot": reboot,
        "poweroff": poweroff,
    }

    if selected_action in actions:
        actions[selected_action]()


# function to confirm user action
def confirm_action(action):
    confirmation_prompt = f"🔒 Are you sure you want to {action}?"
    confirmation_cmd = f"rofi -dmenu -i -p '{confirmation_prompt} [y/n]' -lines 2 -eh 2 -theme {theme}"
    get_confirmation = subprocess.check_output(confirmation_cmd, input="y\nn", text=True, shell=True).strip()
    if get_confirmation.lower() == "y":
        confirmation = True
        return confirmation


def lock():
    subprocess.run(lock_cmd, shell=True)

def suspend():
    confirmation = confirm_action("suspend")
    if confirmation:
        subprocess.run(lock_cmd, shell=True)
        subprocess.run(suspend_cmd, shell=True)

def i3_reload():
    subprocess.run(i3_reload_cmd, shell=True)

def i3_restart():
    subprocess.run(i3_restart_cmd, shell=True)

def logoff():
    confirmation = confirm_action("logoff")
    if confirmation:
        subprocess.run(logoff_cmd, shell=True)

def reboot():
    confirmation = confirm_action("reboot")
    if confirmation:
        subprocess.run(reboot_cmd, shell=True)

def poweroff():
    confirmation = confirm_action("poweroff")
    if confirmation:
        subprocess.run(poweroff_cmd, shell=True)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="i3 session manager")
    parser.add_argument("--action", "-s", choices=["lock", "suspend", "reload", "restart", "logoff", "reboot", "poweroff"], help="select an action")
    parser.add_argument("--rofi", "-r", action="store_true", help="open in rofi")
    args = parser.parse_args()
    if args.rofi:
        rofi()
    elif args.action:
        actions = {
            "lock": lock,
            "suspend": suspend,
            "reload": i3_reload,
            "restart": i3_restart,
            "logoff": logoff,
            "reboot": reboot,
            "poweroff": poweroff,
        }
        selected_action = args.action
        actions[selected_action]()
