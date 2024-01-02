# import required functions/modules
from styles import style
from functions.run_shell_command import run_shell_command as run
from functions.block_button import block_button

# load mouse button click handler
block_button("gpu", button=None)

# escaped shell commands
cmd_vram_util = "nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F',' '{{printf \"%.0f\\n\", $1 / $2 * 100}}'"
cmd_gpu_temp = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"
cmd_fan_speed = "nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits"

# collect check data
vram_util = int(run(cmd_vram_util))
gpu_temp = int(run(cmd_gpu_temp))
fan_speed = int(run(cmd_fan_speed))


# i3blocks_check function invoked by control script
def i3blocks_check(warning, critical):
    icon = "\uf2c7" if gpu_temp > 80 else ( # temperature-full
    "\uf2c8" if gpu_temp > 60 else          # temperature-three-quarters
    "\uf2c9" if gpu_temp > 40 else          # temperature-half
    "\uf2ca" if gpu_temp > 20 else          # temperature-quarter
    "\uf2cb" )                              # temperature-empty

    status_color =  f"{style.NOK}" if gpu_temp >= int(critical) else (
                    f"{style.WARN}" if gpu_temp >= int(warning) else 
                    f"{style.OK}")

    fan_color =     f"{style.OK}" if fan_speed >= 40 else (
                    f"{style.ACTIVE}" if fan_speed >= 20 else 
                    f"{style.INACTIVE}" if fan_speed > 0 else 
                    f"{style.NONE}")
    
    print(f"<span font='{style.FONT}'>{vram_util}%</span> <span font='{style.GLYPHS}'><span color='{fan_color}'>\uf863</span> <span color='{status_color}'>{icon}</span></span>")
