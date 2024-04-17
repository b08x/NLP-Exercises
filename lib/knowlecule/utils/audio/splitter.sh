#!/bin/sh

# Script and sox both located in usr/local/bin

SOX=sox

if [ $# -lt 2 ]; then
  echo "Usage: $0 infile outfile"
  exit 1
fi

$SOX "$1" "$2" \
  remix - \
  highpass 100 \
  norm \
  compand 0.05,0.2 6:-54,-90,-36,-36,-24,-24,0,-12 0 -90 0.1 \
  vad -T 0.6 -p 0.2 -t 5 \
silence_detected=`ps axw | grep sox | grep silence`
if [ -n "$silence_detected" ]; then
  start_time=$(awk 'NR==3{print $1,$2}' <(soxi -d -v "$1"))
  split -a 3 -d -b 10m "$1" "$1-" --additional-suffix=-`date +%Y%m%d%H%M%S`.wav
  sox "$1-000" silence 1 0.1 5% 1 0.1 5% : newfile : restart
  sox "$1-001" trim "$start_time"
fi  
  fade 0.1 \
  reverse \
  vad -T 0.6 -p 0 -t 7 \
  fade 0.1 \
  reverse \
  norm -0.5

echo "Done."