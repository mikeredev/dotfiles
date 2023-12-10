# import required functions/modules
from functions.run_shell_command import run_shell_command as run
from functions.block_button import block_button

# load mouse button click handler
block_button("check_wifi", button=None)

# escaped shell commands
cmd_wifi_signal     = "nmcli -f SIGNAL,IN-USE dev wifi | grep '*' | awk '{print $1}' | tr -d '*'"

# collect check data
try:
    wifi_signal     = int(run(cmd_wifi_signal))
except:
    wifi_signal = 0


# check and display output
def i3blocks_check(warning,critical):
    status_color = "#444444" if wifi_signal == 0 else (
        "red" if wifi_signal <= int(critical) else
        "orange" if wifi_signal <= int(warning) else
        "white")
        
    print(f"{wifi_signal}% <span color='{status_color}'>\uf1eb</span>")
