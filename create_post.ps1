# GitHub Copilot prompt I used to generate this script:
#     Write a Powershell script to create a starting point for a blog post.  
#     The post is stored in folder "docs/posts/{year}/{month}/{day}" .  
#     Create the folder, then in that folder create a markdown file called "index.md". 
#     At the top of the file create a yaml block with title and date.  

# I needed to unquote the date, and add the Out-Null to the New-Item command.
# update... use the current date to get the next Tuesday, and create the folder for that date.


# Get the current date
$currentDate = Get-Date
# Calculate days to Tuesday (Tuesday is 2 in DayOfWeek enum, 0-6 for Sunday-Saturday)
$daysToTuesday = (2 - [int]$currentDate.DayOfWeek + 7) % 7
# If today is Tuesday, we want same day, so adjust if result is 7
if ($daysToTuesday -eq 7) { $daysToTuesday = 0 }
# Get Tuesday's date
$tuesdayDate = $currentDate.AddDays($daysToTuesday)
$year = $tuesdayDate.Year
$month = $tuesdayDate.Month.ToString("D2")
$day = $tuesdayDate.Day.ToString("D2")



# Define the folder path
$folderPath = "docs/posts/$year/$month/$day"

# Create the folder if it doesn't exist
if (-Not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
}

# Define the file path
$filePath = "$folderPath/index.md"

# Create the markdown file with YAML front matter
$title = "Your Blog Post Title"
$date = $tuesdayDate.ToString("yyyy-MM-dd")

$yamlContent = @"
---
title: "$title"
date: $date
authors:
 - chris | norm | omar
categories:
  - CATEGORY_HERE (use existing categories when possible)
tags:
  - TAG_HERE (use existing tags when possible)
---

TOPIC_INTRODUCTION_HERE

Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

![alt text](${date}_image_filename.webp)
"@

# Write the content to the file
Set-Content -Path $filePath -Value $yamlContent

Write-Output "Blog post template created at $filePath"
Write-Output ""
Write-Output "Reminder: Use existing categories and tags when possible."