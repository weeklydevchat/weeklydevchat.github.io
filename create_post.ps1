# GitHub Copilot prompt I used to generate this script:
#     Write a Powershell script to create a starting point for a blog post.  
#     The post is stored in folder "docs/posts/{year}/{month}/{day}" .  
#     Create the folder, then in that folder create a markdown file called "index.md". 
#     At the top of the file create a yaml block with title and date.  

# I needed to unquote the date, and add the Out-Null to the New-Item command.

# Get the current date
$currentDate = Get-Date
$year = $currentDate.Year
$month = $currentDate.Month.ToString("D2")
$day = $currentDate.Day.ToString("D2")

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
$date = $currentDate.ToString("yyyy-MM-dd")

$yamlContent = @"
---
title: "$title"
date: $date
authors:
 -  
---
"@

# Write the content to the file
Set-Content -Path $filePath -Value $yamlContent

Write-Output "Blog post template created at $filePath"