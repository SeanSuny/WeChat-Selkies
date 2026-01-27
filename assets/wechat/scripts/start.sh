#!/bin/bash

# configure openbox dock mode for stalonetray
if [ ! -f /config/.config/openbox/rc.xml ] || grep -A20 "<dock>" /config/.config/openbox/rc.xml | grep -q "<noStrut>no</noStrut>"; then
    mkdir -p /config/.config/openbox
    [ ! -f /config/.config/openbox/rc.xml ] && cp /etc/xdg/openbox/rc.xml /config/.config/openbox/
    sed -i '/<dock>/,/<\/dock>/s/<noStrut>no<\/noStrut>/<noStrut>yes<\/noStrut>/' /config/.config/openbox/rc.xml
    openbox --reconfigure
fi

# update openbox menu if differs from default
if [ ! -f /config/.config/openbox/menu.xml ] || ! cmp /defaults/menu.xml /config/.config/openbox/menu.xml; then
    mkdir -p /config/.config/openbox
    cp /defaults/menu.xml /config/.config/openbox/menu.xml
    openbox --reconfigure
fi

nohup stalonetray --dockapp-mode simple > /dev/null 2>&1 &

# start WeChat application in the background if exists and auto-start enabled
if [ "$AUTO_START_WECHAT" = "true" ]; then
    if [ -f /usr/bin/wechat ]; then nohup /usr/bin/wechat > /dev/null 2>&1 & fi
fi

# !deprecated: start window switcher application in the background
# start window switcher application in the background
# nohup sleep 2 && python /scripts/window_switcher.py > /dev/null 2>&1 &
