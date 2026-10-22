#!/usr/bin/env bash
# Полоска заполненности контекста (памяти) чата Claude Code.
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
read -r used size tokens < <(echo "$input" | jq -r '
  .context_window as $c
  | ($c.context_window_size // 200000) as $size
  | (($c.current_usage // {}) | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)) as $tok
  | (if $c.used_percentage != null then $c.used_percentage
     elif $size > 0 then $tok * 100 / $size
     else 0 end) as $pct
  | [($pct | floor), $size, (if $tok > 0 then $tok else ($pct * $size / 100 | floor) end)]
  | @tsv')

used=${used:-0}; size=${size:-200000}; tokens=${tokens:-0}
((used > 100)) && used=100
((used < 0)) && used=0
left_k=$(( (size - tokens) / 1000 )); ((left_k < 0)) && left_k=0

# Цвет по шкале 0–100: зелёный → жёлтый → красный
rgb() {
  local p=$1 r g b
  if ((p < 50)); then
    r=$((110 + p * 120 / 50)); g=$((205 - p * 5 / 50)); b=$((130 - p * 50 / 50))
  else
    r=$((230 + (p - 50) * 10 / 50)); g=$((200 - (p - 50) * 110 / 50)); b=$((80 + (p - 50) * 10 / 50))
  fi
  printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

dim='\033[38;2;75;80;90m'
muted='\033[38;2;140;145;155m'
bold='\033[1m'
reset='\033[0m'

# Полоска из 20 клеток с точностью до половины клетки
width=20
halves=$((used * width * 2 / 100))
bar=""
for ((i = 0; i < width; i++)); do
  if ((i * 2 + 2 <= halves)); then
    bar+="$(rgb $((i * 100 / width)))━"
  elif ((i * 2 + 1 == halves)); then
    bar+="$(rgb $((i * 100 / width)))╸"
  else
    bar+="${dim}━"
  fi
done

printf "${muted}%s${reset}  %b${reset}  %b${bold}%d%%${reset} ${muted}· осталось %dk${reset}" \
  "$model" "$bar" "$(rgb "$used")" "$used" "$left_k"
