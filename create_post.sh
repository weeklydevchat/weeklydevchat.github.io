#!/bin/bash

# Calculate the next Tuesday (or today if it's Tuesday)
# In Linux date, weekday: 0=Sunday, 1=Monday, ..., 6=Saturday
current_weekday=$(date +%w)              # 0=Sun ... 6=Sat
days_to_tuesday=$(( (2 - current_weekday + 7) % 7 ))

# If today is Tuesday, days_to_tuesday will be 0 → perfect
# Add the calculated days
tuesday=$(date -d "+${days_to_tuesday} days" +%Y-%m-%d)

year=$(date -d "$tuesday" +%Y)
month=$(date -d "$tuesday" +%02m)
day=$(date -d "$tuesday" +%02d)

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
  - CATEGORY_HERE
tags:
  - TAG_HERE
---

TOPIC_INTRODUCTION_HERE

Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

![alt text](${tuesday}_image_filename.webp)
EOF

echo "Blog post template created at $file_path"
echo ""
echo "Reminder: Use existing categories and tags when possible."