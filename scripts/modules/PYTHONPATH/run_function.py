""" run_function.py
desc:       module for running a function and returning output
requires:   colorama
usage:      import module run_function
            run_function.run("notify - send", "Sending notification", "wifi manager", "connected")
            command_output = run_function.run(function,message)
            print(command_output)
"""

# import modules
import sys

# import non-standard/custom modules
from colorama import Fore, Style


def run(func, message, *args, **kwargs):
    print(f"{Style.RESET_ALL}=> {message}... ", end="")
    try:
        result = func(*args, **kwargs)
        str_result = f"{Style.RESET_ALL}{Fore.LIGHTGREEN_EX}OK{Style.RESET_ALL} {Style.DIM}{str(result)}{Style.RESET_ALL}"
        print(str_result)
        return result
    except Exception as e:
        str_result = f"{Style.RESET_ALL}{Fore.LIGHTRED_EX}FAIL{Style.RESET_ALL}\n{Style.DIM}==> {str(e)}\n==> Stack trace follows{Style.RESET_ALL}"
        print(str_result)
        return result
