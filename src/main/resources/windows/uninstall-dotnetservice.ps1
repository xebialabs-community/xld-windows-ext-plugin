##############################################################
#  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
#  FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
##############################################################

$serviceName = if($deployed.serviceName) { $deployed.serviceName } else { $deployed.name }
$displayName = if($deployed.serviceDisplayName) { $deployed.serviceDisplayName } else { $serviceName }
$description = if($deployed.serviceDescription) { $deployed.serviceDescription } else { $serviceName }
 
$installUtil = "c:\windows\microsoft.net\framework\$($deployed.DotNetVersion)\installutil.exe"
Invoke-Command -ScriptBlock {$installUtil /u /LogToConsole=true $deployed.binaryPathName}


<# if($deployed.username) {
    $securePassword = $null
    if($deployed.password) {
        $securePassword = $deployed.password | ConvertTo-SecureString -asPlainText -Force
    } else {
        $securePassword = (new-object System.Security.SecureString)
    }
    $cred = New-Object System.Management.Automation.PSCredential($deployed.username, $securePassword) #>

<# }  else {

} #>

