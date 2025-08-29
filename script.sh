devports() {
  local filter='node|python|uvicorn|gunicorn|ruby|rails|php|java|gradle|mvn|go|deno|bun|pnpm|vite|next|nuxt|webpack|rollup|parcel'
  [[ "$1" == "all" ]] && { filter='.'; shift; }
  [[ -n "$1" ]] && filter="$1"

  while :; do
    local rows
    rows="$(lsof -nP -iTCP -sTCP:LISTEN -a -u "$USER" -Fpcn \
      | awk 'BEGIN{OFS=" "}
/^p/ {pid=substr($0,2)}
/^c/ {cmd=substr($0,2)}
/^n/ {name=substr($0,2); if (pid && cmd && name) print cmd, pid, name}' \
      | egrep -i "$filter" \
      | sort -u)"

    clear 2>/dev/null || true
    if [[ -z "$rows" ]]; then
      echo "No matching user-owned listeners."
      return 1
    fi

    echo " #  CMD          PID    ADDRESS"
    echo "-----------------------------------------"
    local i=0
    while IFS= read -r line; do
      i=$((i+1))
      printf "%2d  %-12s %-6s %s\n" "$i" "$(awk '{print $1}' <<<"$line")" "$(awk '{print $2}' <<<"$line")" "$(awk '{print $3}' <<<"$line")"
    done <<< "$rows"

    echo
    echo "Actions: [Enter]=exit  k=kill  K=force-kill  r=refresh  f=set filter"
    printf "> "
    read -r action _

    case "$action" in
      "" ) return 0 ;;
      r|R ) continue ;;
      f|F )
        echo "Current filter: $filter"
        printf "New regex (or 'all'): "
        read -r nf
        [[ "$nf" == "all" ]] && filter='.' || [[ -n "$nf" ]] && filter="$nf"
        continue
        ;;
      k|K )
        local sig="-TERM"; [[ "$action" == "K" ]] && sig="-KILL"

        echo "Select targets to kill (indices, PIDs, or ports like :3000 3001)."
        echo "Examples: 1 3  :3000  40520"
        printf "Selection: "
        read -r sel
        [[ -z "$sel" ]] && { echo "No selection."; sleep 1; continue; }

        # Build arrays (avoid name 'LINES' in zsh)
        local -a ENTRIES PIDS ADDRS
        while IFS= read -r line; do
          ENTRIES+=("$line")
          PIDS+=("$(awk '{print $2}' <<<"$line")")
          ADDRS+=("$(awk '{print $3}' <<<"$line")")
        done <<< "$rows"

        # Resolve selection → PID list (no assoc arrays; dedupe manually)
        local -a CHOSEN=()
        add_pid() { # add if not already in CHOSEN
          local p="$1"
          local x
          for x in "${CHOSEN[@]}"; do [[ "$x" == "$p" ]] && return 0; done
          CHOSEN+=("$p")
        }

        local tok
        for tok in $sel; do
          tok="${tok%,}"
          if [[ "$tok" =~ ^[0-9]+$ ]]; then
            local idx="$tok"
            if (( idx>=1 && idx<=${#PIDS[@]} )); then
              add_pid "${PIDS[$((idx-1))]}"; continue
            fi
            # maybe it was a PID
            local p
            for p in "${PIDS[@]}"; do [[ "$p" == "$tok" ]] && add_pid "$p"; done
            continue
          fi
          if [[ "$tok" =~ ^:?[0-9]+$ ]]; then
            local port="${tok#:}"
            local j=0
            local a
            for a in "${ADDRS[@]}"; do
              [[ "$a" == *":$port" ]] && add_pid "${PIDS[$j]}"
              j=$((j+1))
            done
          fi
        done

        if (( ${#CHOSEN[@]} == 0 )); then
          echo "No valid targets resolved."; sleep 1; continue
        fi

        echo
        echo "About to send $sig to:"
        local pid
        for pid in "${CHOSEN[@]}"; do
          awk -v p="$pid" '$2==p{printf "  %-12s %-6s %s\n",$1,$2,$3}' <<<"$rows"
        done
        printf "Proceed? [y/N] "
        read -r yes
        [[ "$yes" =~ ^[Yy]$ ]] || { echo "Aborted."; sleep 1; continue; }

        local rc=0
        for pid in "${CHOSEN[@]}"; do
          if kill "$sig" "$pid" 2>/dev/null; then
            echo "✔ $pid"
          else
            echo "✖ $pid"
            rc=1
          fi
        done
        echo "Press Enter to refresh."
        read -r _
        continue
        ;;
      * )
        echo "Unknown action."; sleep 1; continue ;;
    esac
  done
}

