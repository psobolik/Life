$cwd = Get-Location | %{"$_"} 

processing cli --force --sketch="${cwd}/Life" --output="${cwd}/out" --run

