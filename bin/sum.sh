#!/bin/bash
# presumes list of numbers, one per line, via stdin

set -euo pipefail

awk '{s+=$1} END {print s}'
