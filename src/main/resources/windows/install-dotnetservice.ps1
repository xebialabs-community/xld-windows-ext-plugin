##############################################################
#  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
#  FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
##############################################################

$serviceName = if($deployed.serviceName) { $deployed.serviceName } else { $deployed.name }
$displayName = if($deployed.serviceDisplayName) { $deployed.serviceDisplayName } else { $serviceName }
$description = if($deployed.serviceDescription) { $deployed.serviceDescription } else { $serviceName }

function Expand-ZIPFile($file, $destination) {
   Write-Host 'unzip $deployed.file to $deployed.targetPath'
   $shell = new-object -com shell.application
   $zip = $shell.NameSpace($file)
   foreach($item in $zip.items()) {
      $shell.Namespace($destination).copyhere($item, 0x14)
   }
}

Write-Host 'Expand-ZIPFile $deployed.file $deployed.targetPath'

if( -not (Test-Path $deployed.targetPath ) ) {
    Write-Host "Create directory $deployed.targetPath"
    mkdir $deployed.targetPath
}

Expand-ZIPFile $deployed.file $deployed.targetPath

Write-Host "Installing service [$serviceName]"


$installUtil = "c:\windows\microsoft.net\framework\$($deployed.DotNetVersion)\installutil.exe"
$cmd = "$installUtil /LogToConsole=true $($deployed.binaryPathName)"
echo "---------------------"
echo "installUtil = $installUtil"
echo "DotNetVer = $($deployed.DotNetVersion)"
echo "PathName  = $($deployed.binaryPathName)"
echo "cmd       = $cmd"
echo "---------------------"
dir $installUtil
$sb = [ScriptBlock]::Create( $cmd )
Invoke-Command -ScriptBlock $sb
Set-Service -name $serviceName -Description $deployed.ServiceDescription
Set-Service -name $serviceName -DisplayName $deployed.ServiceDisplayName


if( $deployed.username ) {
    $securePassword = $null
    if($deployed.password) {
        $securePassword = $deployed.password | ConvertTo-SecureString -asPlainText -Force
    } else {
        $securePassword = (new-object System.Security.SecureString)
    }
    $cred = New-Object System.Management.Automation.PSCredential($deployed.username, $securePassword)

}
