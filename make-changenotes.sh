#!/bin/env bash

if [[ $# -lt 2 ]]; then
        echo "usage: make-changenotes.sh changelist-name previous-tag"
        exit 1
fi

changelist_title=$1
prev_tag=$2
starting_dir=$(pwd)
outfile="changelist.md"

#Update this for whatever repo you want
program_dir="$HOME/programs/st"

cd $program_dir

current_commit=$(git rev-parse HEAD)
changes=$(git log --oneline $prev_tag..HEAD)

message="
## $changelist_title
---
commit hash: $current_commit
---
### Overview
Incremental changes from the past iteration.

### Changes
$changes
"
cd $starting_dir

echo "$message" > $outfile
