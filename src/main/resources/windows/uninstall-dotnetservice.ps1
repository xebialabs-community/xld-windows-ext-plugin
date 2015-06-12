##############################################################
#  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
#  FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
##############################################################

$serviceName = if($deployed.serviceName) { $deployed.serviceName } else { $deployed.name }
$displayName = if($deployed.serviceDisplayName) { $deployed.serviceDisplayName } else { $serviceName }
$description = if($deployed.serviceDescription) { $deployed.serviceDescription } else { $serviceName }
 
$installUtil = "c:\windows\microsoft.net\framework\$($deployed.DotNetVersion)\installutil.exe"
$cmd = "$installUtil /u /LogToConsole=true $($deployed.binaryPathName)"
echo "---------------------"
echo "installUtil = $installUtil"
echo "DotNetVer = $($deployed.DotNetVersion)"
echo "PathName  = $($deployed.binaryPathName)"
echo "cmd       = $cmd"
echo "---------------------"
dir $installUtil
$sb = [ScriptBlock]::Create( $cmd )
Invoke-Command -ScriptBlock $sb

# Remove old service content if it's still there
if (Test-Path $deployed.targetPath ) {
	Write-Host "Removing old service content from [$deployed.targetPath]."
	Remove-Item -Recurse -Force $deployed.targetPath
}


