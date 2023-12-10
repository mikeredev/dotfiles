# import required functions/modules
from functions.block_button import block_button
from functions.run_shell_command import run_shell_command as run

# load mouse button click handler
block_button("check_gpu", button=None)

# escaped shell commands
cmd_vram_util   = "nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F',' '{{printf \"%.0f\\n\", $1 / $2 * 100}}'"
cmd_gpu_temp    = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"
cmd_fan_speed   = "nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits"

# collect check data
vram_util       = int(run(cmd_vram_util))
gpu_temp        = int(run(cmd_gpu_temp))
fan_speed       = int(run(cmd_fan_speed))


# check and display output
def i3blocks_check(warning, critical):
    icon = "\uf2c7" if gpu_temp > 80 else ( # thermometer full
    "\uf2c8" if gpu_temp > 60 else          # thermometer 3/4
    "\uf2c9" if gpu_temp > 40 else          # thermometer 1/2
    "\uf2ca" if gpu_temp > 20 else          # thermometer 1/4
    "\uf2cb" )                              # thermometer empty

    status_color = "red" if gpu_temp >= int(critical) else (
        "orange" if gpu_temp >= int(warning) else 
        "white")

    fan_color = "white" if fan_speed >= 40 else (
        "darkgrey" if fan_speed >= 20 else 
        "#666666" if fan_speed >0 else 
        "#444444")
        
    print(f"{vram_util}% <span color='{fan_color}'>\uf863</span> <span color='{status_color}'>{icon}</span>")
