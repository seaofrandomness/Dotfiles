while true; do
        date '+%H:%M' > /tmp/dwm_bar_time
        sleep 60s
done &

while true
do
        LOCALTIME=$(< /tmp/dwm_bar_time)
        BAT0=$(cat /sys/class/power_supply/BAT0/capacity)
	WIFI=$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d':' -f2)
	IP_WIFI=$(ip -o -4 addr show wlp0s20f3 | awk '{print $4}' | cut -d/ -f1)
	IP_IPHONE=$(ip -o -4 addr show enp0s20f0u5c4i2 | awk '{print $4}' | cut -d/ -f1)
        xsetroot -name "$IP_IPHONE $IP_WIFI $WIFI $LOCALTIME $BAT0%" 
        sleep 2
done &

xinput set-prop "Elan Touchpad" 315 1
xinput set-prop "Elan Touchpad" 323 1
setxkbmap -layout fr,ara
setxkbmap -option 'grp:alt_shift_toggle'
sh .fehbg
wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1
nm-applet &
volumeicon &
cbatticon &
picom &
flameshot &
udiskie --tray &
redshift -l 36.64:2.99 -t 6500:3600 & 
keepassxc &
dunst &
exec dwm

