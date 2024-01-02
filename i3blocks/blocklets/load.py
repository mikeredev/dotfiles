# import required functions/modules
import os
from styles import style
from functions.block_button import block_button

# load mouse button click handler
block_button("load", button=None)

# collect check data
load_avg = os.getloadavg()
total_cores = os.cpu_count()
cpu_load = round(load_avg[0] / total_cores, 1)


# i3blocks_check function invoked by control script
def i3blocks_check(warning, critical):
    status_color =  f"{style.NOK}" if cpu_load >= float(critical) else (
                    f"{style.WARN}" if cpu_load >= float(warning) else 
                    f"{style.OK}")

    print(f"<span font='{style.FONT}'>{cpu_load}</span> <span font='{style.GLYPHS}' color='{status_color}'>\uf625</span>")
