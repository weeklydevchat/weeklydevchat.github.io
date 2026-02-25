#!/bin/bash

# Calculate the next Tuesday (or today if it's Tuesday)
current_weekday=$(date +%w)              # 0=Sun ... 6=Sat
days_to_tuesday=$(( (2 - current_weekday + 7) % 7 ))

# Add the calculated days (compatible with both macOS and Linux)
if date -v +0d &>/dev/null; then
  # macOS (BSD date)
  tuesday=$(date -v "+${days_to_tuesday}d" +%Y-%m-%d)
else
  # Linux (GNU date)
  tuesday=$(date -d "+${days_to_tuesday} days" +%Y-%m-%d)
fi

year=${tuesday%%-*}                       # 2026
month=${tuesday#*-}; month=${month%-*}    # 02
day=${tuesday##*-}                        # 24

# Define paths
folder_path="docs/posts/$year/$month/$day"
file_path="$folder_path/index.md"

# Create the directory (including parents) if it doesn't exist
mkdir -p "$folder_path"

# YAML frontmatter
cat << EOF > "$file_path"
---
title: "Your Blog Post Title"
date: $tuesday
authors:
 - chris | norm | omar
categories:
    # use existing categories when possible, in YAML list format.
  - CATEGORY_ONE
  - CATEGORY_TWO
tags:
    # use existing tags when possible, in YAML list format.
  - TAG_ONE
  - TAG_TWO
---

TOPIC_INTRODUCTION_HERE

Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

![alt text](${tuesday}_image_filename.webp)
EOF

echo "Blog post template created at $file_path"
echo ""
echo "Reminder: Use existing categories and tags when possible."