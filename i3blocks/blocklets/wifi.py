# import required functions/modules
from styles import style
from functions.run_shell_command import run_shell_command as run
from functions.block_button import block_button

# load mouse button click handler
block_button("wifi", button=None)

# escaped shell commands
cmd_wifi_signal = "nmcli -f SIGNAL,IN-USE dev wifi | grep '*' | awk '{print $1}' | tr -d '*'"

# collect check data
try:
    wifi_signal = int(run(cmd_wifi_signal))
except:
    wifi_signal = 0


# i3blocks_check function invoked by control script
def i3blocks_check(warning, critical):
    status_color =  f"{style.NONE}" if wifi_signal == 0 else (
                    f"{style.NOK}" if wifi_signal <= int(critical) else
                    f"{style.WARN}" if wifi_signal <= int(warning) else
                    f"{style.OK}")
        
    print(f"<span font='{style.FONT}'>{wifi_signal}%</span> <span font='{style.GLYPHS}' color='{status_color}'>\uf1eb</span>")
