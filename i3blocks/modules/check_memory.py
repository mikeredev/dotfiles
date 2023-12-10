# import required functions/modules
import psutil
from functions.block_button import block_button

# load mouse button click handler
block_button("check_memory", button=None)

# collect check data
memory_util = round(psutil.virtual_memory().percent)


# check and display output
def i3blocks_check(warning,critical):
    status_color = "red" if memory_util >= int(critical) else (
        "orange" if memory_util >= int(warning) else
        "white")

    print(f"{memory_util}% <span color='{status_color}'>\uf201</span>")
