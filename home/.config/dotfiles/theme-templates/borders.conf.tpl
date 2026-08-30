accent='{{ accent }}'
muted='{{ muted }}'
options=(
  style=round
  width=4.0
  hidpi=on
  "active_color=0xff${accent#\#}"
  "inactive_color=0xff${muted#\#}"
)
