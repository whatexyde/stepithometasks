#!/usr/bin/env bash
# Полоска заполненности контекста (памяти) чата Claude Code.
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used=$(echo "$input" | jq -r '
  .context_window as $c
  | if $c.used_percentage != null then $c.used_percentage
    elif $c.current_usage != null and ($c.context_window_size // 0) > 0 then
      (($c.current_usage.input_tokens // 0)
       + ($c.current_usage.cache_creation_input_tokens // 0)
       + ($c.current_usage.cache_read_input_tokens // 0)) * 100 / $c.context_window_size
    else 0 end
  | floor')

[ "$used" -gt 100 ] 2>/dev/null && used=100
left=$((100 - used))

width=20
filled=$((used * width / 100))
bar=""
for ((i = 0; i < width; i++)); do
  if [ "$i" -lt "$filled" ]; then bar+="█"; else bar+="░"; fi
done

# Зелёный — много места, жёлтый — больше половины занято, красный — почти кончилось
if [ "$used" -ge 80 ]; then color='\033[31m'
elif [ "$used" -ge 50 ]; then color='\033[33m'
else color='\033[32m'; fi
reset='\033[0m'

printf "%s │ ${color}%s${reset} %d%% занято · осталось %d%%" "$model" "$bar" "$used" "$left"
