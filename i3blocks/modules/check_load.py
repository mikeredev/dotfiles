# import required functions/modules
import os
from functions.block_button import block_button

# load mouse button click handler
block_button("check_load", button=None)

# collect check data
load_avg        = os.getloadavg()
total_cores     = os.cpu_count()
cpu_load        = round(load_avg[0] / total_cores, 1)


# check and display output
def i3blocks_check(warning,critical):
    status_color = "red" if cpu_load >= float(critical) else (
        "orange" if cpu_load >= float(warning) else 
        "white")

    print(f"{cpu_load} <span color='{status_color}'>\uf625</span>")
