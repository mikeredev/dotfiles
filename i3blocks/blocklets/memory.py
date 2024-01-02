# import required functions/modules
import psutil
from styles import style
from functions.block_button import block_button

# load mouse button click handler
block_button("memory", button=None)

# collect check data
memory_util = round(psutil.virtual_memory().percent)


# i3blocks_check function invoked by control script
def i3blocks_check(warning, critical):
    status_color =  f"{style.NOK}" if memory_util >= int(critical) else (
                    f"{style.WARN}" if memory_util >= int(warning) else
                    f"{style.OK}")

    print(f"<span font='{style.FONT}'>{memory_util}%</span> <span font='{style.GLYPHS}' color='{status_color}'>\uf201</span>")
