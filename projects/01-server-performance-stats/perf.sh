#!/usr/bin/env bash
set -euo pipefail

# Helper: check if a command exists
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Get CPU usage as a percentage (simple method using top)
cpu_usage() {
  local idle
  idle=$(LC_ALL=C top -bn2 -d 0.5 | awk '/Cpu\(s\)/{u=$8} END{print u}')
  awk -v idle="${idle:-0}" 'BEGIN{printf("%.2f", 100 - idle)}'
}

# Get memory usage percentage from /proc/meminfo
mem_usage() {
  awk '/MemTotal:/ {t=$2} /MemAvailable:/ {a=$2} END{printf("%.2f", (t-a)/t*100)}' /proc/meminfo
}

# Get disk usage of root filesystem (/)
disk_usage() {
  df -P / | awk 'NR==2 {gsub("%","",$5); print $5}'
}

# Get network interface and RX/TX bytes
net_bytes() {
  local ifc
  # Try to detect main interface
  if has_cmd ip; then
    ifc=$(ip route get 1.1.1.1 2>/dev/null | awk '/dev/ {for (i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}')
  fi
  # Fallback: first non-loopback from /proc/net/dev
  if [[ -z "${ifc:-}" ]]; then
    ifc=$(awk -F: '$1 !~ /lo/ && $1 ~ /^[a-zA-Z0-9]/ {gsub(" ", "", $1); print $1; exit}' /proc/net/dev)
  fi

  local rx tx
  rx=$(awk -v i="$ifc" -F'[: ]+' '$1==i {print $3}' /proc/net/dev)
  tx=$(awk -v i="$ifc" -F'[: ]+' '$1==i {print $11}' /proc/net/dev)
  echo "$ifc" "$rx" "$tx"
}

MODE="${1:-human}"  # human | json

CPU="$(cpu_usage)"   || CPU="nan"
MEM="$(mem_usage)"   || MEM="nan"
DISK="$(disk_usage)" || DISK="nan"
read -r IFACE RX TX <<<"$(net_bytes)" || { IFACE="unknown"; RX="0"; TX="0"; }

timestamp="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
host="$(hostname)"

if [[ "$MODE" == "json" ]]; then
  json=$(cat <<EOFJSON
{
  "timestamp": "$timestamp",
  "host": "$host",
  "cpu_usage_percent": $CPU,
  "mem_usage_percent": $MEM,
  "disk_usage_root_percent": $DISK,
  "net": {
    "iface": "$IFACE",
    "rx_bytes": $RX,
    "tx_bytes": $TX
  }
}
EOFJSON
)
  if has_cmd jq; then echo "$json" | jq .; else echo "$json"; fi
else
  cat <<EOFHUMAN
[$timestamp] $host
CPU Usage:  $CPU %
Mem Usage:  $MEM %
Disk /:     $DISK %
Net ($IFACE): RX=$RX bytes  TX=$TX bytes

Tip: ./perf.sh json   # JSON output
EOFHUMAN
fi
