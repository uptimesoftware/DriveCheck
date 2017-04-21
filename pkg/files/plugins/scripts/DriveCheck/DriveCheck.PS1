$UPT_USERNAME = Get-ChildItem Env:UPTIME_USERNAME | select -expand value;
$UPT_PASSWORD = Get-ChildItem Env:UPTIME_PASSWORD | select -expand value;
$UPT_HOSTNAME = Get-ChildItem Env:UPTIME_HOSTNAME | select -expand value;
$UPT_DRIVECHECK = Get-ChildItem Env:UPTIME_DRIVECHECK | select -expand value; 

#determine if running against localhost
if($UPT_HOSTNAME -eq 'localhost' -Or $UPT_HOSTNAME -eq (Get-ChildItem Env:USERDOMAIN | select -expand value)) {
	#write-host 'running local'
	$runninglocal = "true"
	}

#Retrieve data from WMI using authentication or not depending on choice
If($runninglocal) {
	#write-host "running local and looking for $UPT_DRIVECHECK"
	if ((gwmi -Computername $UPT_HOSTNAME -class Win32_logicaldisk -Property DeviceID, DriveType | ? {($_.DriveType -eq 3) -and ($_.DeviceID -eq $UPT_DRIVECHECK )} | select -expand DeviceID) -eq $UPT_DRIVECHECK) {
		write-host "Status $UPT_DRIVECHECK found on $UPT_HOSTNAME"
	} else {
		write-host "Status $UPT_DRIVECHECK NOT FOUND on $UPT_HOSTNAME"
	}     
} ELSE {
	#write-host "running remote and looking for $UPT_DRIVECHECK"
	$credential = New-Object System.Management.Automation.PsCredential($UPT_USERNAME, (ConvertTo-SecureString $UPT_PASSWORD -AsPlainText -Force))
	if ((gwmi -Computername $UPT_HOSTNAME -Credential $credential -class Win32_logicaldisk -Property DeviceID, DriveType | ? {($_.DriveType -eq 3) -and ($_.DeviceID -eq $UPT_DRIVECHECK )} | select -expand DeviceID) -eq $UPT_DRIVECHECK) {
       write-host "Status $UPT_DRIVECHECK found on $UPT_HOSTNAME"
	} else {
		write-host "Status $UPT_DRIVECHECK NOT FOUND on $UPT_HOSTNAME"
	} 
}