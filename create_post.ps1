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
date: "$date"
authors:
 -  
---
"@

# Write the content to the file
Set-Content -Path $filePath -Value $yamlContent

Write-Output "Blog post template created at $filePath"