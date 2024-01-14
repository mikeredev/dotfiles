# import required functions/modules
from datetime import datetime
from styles import style

# collect check data
current_datetime = datetime.now()
formatted_date = current_datetime.strftime("%a%d %H:%M").upper()

# i3blocks_check function invoked by control script
def i3blocks_check(warning=None, critical=None):
    print(f"<span font='monospace 9'><span font='{style.FONT}'>{formatted_date}</span></span>")