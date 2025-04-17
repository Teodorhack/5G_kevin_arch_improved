#!/bin/bash

set -e

echo "⭕️ Starting srsRAN..."

# Prevent Docker from restarting the container
tail -f /dev/null 