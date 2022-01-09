#!/bin/bash

bool_lbp=0
bool_clbp=0

addr="/home/jayantapandit/libcode/import/winxp-cue/*"
addr2="$addr"

for (( i=0 ; ; i++ ));
do
  acpi_str=$(acpi -V | grep "..\%,")
  charge_state="$(grep "Discharging" <<< ${acpi_str})"
  if [ ! -z "$charge_state" ]
  then

# python3 script to extract ACPI hardware 'Battery 0' charge level using RegEx   
battery="$(ACPI="$acpi_str" python3 <<END
import re
from os import environ
print(re.search(r"[0-9]*%", environ.get('ACPI'))[0][0:-1])
END
)"
# end

  if [ $bool_lbp -eq 0 -a $battery -lt 26 -a $battery -ge 16 ]
    then
      $(zenity --warning --title="$battery%: Low battery!" --text="Plug in your charger ASAP... ︵{ •̃_•̃ }︵" --width=250 2>&1 | mplayer $addr >/dev/null 2>&1)
      bool_lbp=1
    elif [ $bool_clbp -eq 0 -a $battery -lt 16 ]
    then
      $(zenity --error --title="$battery%: Critically low battery!" --text="Plug in your charger now! (╯°□°)╯︵ ┻━┻" --width=250 >/dev/null 2>&1 | mplayer $addr2 >/dev/null 2>&1)
      bool_clbp=1
   fi
  else
    bool_lbp=0
    bool_clbp=0
  fi
  $(sleep 15)
done
