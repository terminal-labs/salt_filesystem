echo "I run @ {{hour}} on {{weekday}} but only the {{monthday}}." >> patching_script_result.txt

New-Item "C:\Users\Administrator\patching_script.ps1"
Set-Content "C:\Users\Administrator\patching_script.ps1" "I run @ {{hour}} on day {{weekday}} but only the {{monthday}}."
