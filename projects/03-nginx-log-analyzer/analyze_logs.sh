# ./analyze_logs.sh access.log

# It prints:
# - total number of requests
# - number of unique IPs
# - top 5 IPs by request count
# - status code counts (e.g. 200, 404, 500)
#  
set -euo pipefail

# Check if the user passed a file name

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 "
  exit 1
fi

logfile="$1"

# Check if the file exists

if [[ ! -f "$logfile" ]]; then
  echo "Error: file '$logfile' does not exist"
  exit 1
fi

echo "Log file: $logfile"
echo

# Total number of requests = number of lines

total_requests=$(wc -l < "$logfile")
echo "Total requests: $total_requests"

# Unique IP count

unique_ips=$(cut -d' ' -f1 "$logfile" | sort | uniq | wc -l)
echo "Unique IPs: $unique_ips"
echo

# Top 5 IPs by request count

echo "Top 5 IPs:"
cut -d' ' -f1 "$logfile" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %s requests\n", $2, $1}'
echo

# Status code counts
# In the standard Nginx format the status code is usually the 9th field

echo "Status code counts:"
awk '{print $9}' "$logfile" | sort | uniq -c | sort -nr | awk '{printf "%s: %s\n", $2, $1}'


