echo "I run @ {{hour}} on day {{day}} but only {{weekday}}s." >> patching_script_result.txt

New-Item "C:\Users\Administrator\patching_script.ps1"
Set-Content "C:\Users\Administrator\patching_script.ps1" "I run @ {{hour}} on day {{weekday}} but only the {{monthday}}."
