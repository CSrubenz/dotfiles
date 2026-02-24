#!/bin/bash

pwr_path="/sys/class/power_supply/"

total_now=0
total_full=0
state="unknown"

# Get battery in your pc
for bat in "$pwr_path"BAT*; do
    [ ! -d "$bat" ] && continue

    now=$(cat "$bat/energy_now" 2>/dev/null)
    full=$(cat "$bat/energy_full" 2>/dev/null)

    [ -z "$now" ] || [ -z "$full" ] && continue

    thresh=100
    if [ -f "$bat/charge_control_end_threshold" ]; then
        thresh=$(cat "$bat/charge_control_end_threshold")
    fi

    true_full=$(( full * thresh / 100 ))

    total_now=$(( total_now + now ))
    total_full=$(( total_full + true_full ))

    bat_status=$(cat "$bat/status")

    if [ "$bat_status" = "Charging" ]; then
        state="charging"
    elif [ "$bat_status" = "Discharging" ]; then
        state="discharging"
    elif [ "$bat_status" = "Not charging" ] \
		&& [ "$state" != "discharging" ] \
		&& [ "$state" != "charging" ]; then
			state="AC"
    fi
done

if [ "$total_full" -eq 0 ]; then
    echo "{\"text\": \"󰂎 Erreur\", \"class\": \"critical\"}"
    exit 0
fi

# Calcul percentage with the tlp threshold
PERCENT=$(( total_now * 100 / total_full ))

# Limit to 100%
[ "$PERCENT" -gt 100 ] && PERCENT=100

if [ "$state" = "AC" ]; then
    ICON=""
    CLASS="plugged"
elif [ "$state" = "charging" ]; then
    ICON="󰂄"
    CLASS="charging"
else
    CLASS="normal"
    if [ "$PERCENT" -ge 95 ]; then ICON="󰁹"
    elif [ "$PERCENT" -ge 90 ]; then ICON="󰂂"
    elif [ "$PERCENT" -ge 80 ]; then ICON="󰂁"
    elif [ "$PERCENT" -ge 70 ]; then ICON="󰂀"
    elif [ "$PERCENT" -ge 60 ]; then ICON="󰁿"
    elif [ "$PERCENT" -ge 50 ]; then ICON="󰁾"
    elif [ "$PERCENT" -ge 40 ]; then ICON="󰁽"
    elif [ "$PERCENT" -ge 30 ]; then ICON="󰁼"
    elif [ "$PERCENT" -ge 20 ]; then ICON="󰁻"
    elif [ "$PERCENT" -ge 10 ]; then ICON="󰁺"
    else ICON="󰂎"
    fi

	# for CSS couleur
    if [ "$PERCENT" -le 15 ]; then CLASS="critical"
    elif [ "$PERCENT" -le 30 ]; then CLASS="warning"
    fi
fi

echo "{\"text\": \"$ICON  $PERCENT%\", \"class\": \"$CLASS\", \"tooltip\": \"Capacité (Optimisée TLP) : $PERCENT%\"}"
