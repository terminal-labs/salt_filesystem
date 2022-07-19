echo "I run @ {{hour}} on {{weekday}} but only the {{monthday}}." >> patching_script_result.txt

New-Item "C:\Users\Administrator\patching_script_worked.txt"
Set-Content "C:\Users\Administrator\patching_script_worked.txt" "I run @ {{hour}} on day {{weekday}} but only the {{monthday}}."
