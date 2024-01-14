# import required functions/modules
from styles import style
from functions.run_shell_command import run_shell_command as run
from functions.block_button import block_button

# load mouse button click handler
block_button("volume", button=None)

# escaped shell commands
cmd_volume_level = "amixer -D pulse sget Master | grep -oP '\d+%' | head -n1 | tr -d '%'"
cmd_audio_status = "amixer -D pulse get Master | grep -oP '\[o[nf]*\]' | head -n1"

# collect check data
volume_level = int(run(cmd_volume_level))
audio_status = run(cmd_audio_status)


# i3blocks_check function invoked by control script
def i3blocks_check(warning, critical):
    icon = "\uf6a9" if audio_status=="[off]" else ( # volume-xmark
    "\uf028" if volume_level >=70 else              # volume-high
    "\uf027" if volume_level >=10 else              # volume-low
    "\uf026")                                       # volume-off

    status_color =  f"{style.INACTIVE}" if audio_status=="[off]" else (
                    f"{style.NOK}" if volume_level >= int(critical) else
                    f"{style.WARN}" if volume_level >= int(warning) else
                    f"{style.OK}")
    
    print(f"<span font='monospace 9'><span font='{style.FONT}'>{volume_level}%</span> <span font='{style.GLYPHS}' color='{status_color}'>{icon}</span></span>")
