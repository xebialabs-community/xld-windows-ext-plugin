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
      $shell.Namespace($destination).copyhere($item)
   }
}

Write-Host 'Expand-ZIPFile $deployed.file $deployed.targetPath'

if( -not (Test-Path $deployed.targetPath ) ) {
    Write-Host "Create directory $deployed.targetPath"
    mkdir $deployed.targetPath
}

Expand-ZIPFile $deployed.file $deployed.targetPath

Write-Host "Installing service [$serviceName]"

if( $($deployed.username) ) {
    $securePassword = $null
    if( $($deployed.password) ) {
        $securePassword = $($deployed.password) | ConvertTo-SecureString -asPlainText -Force
    } else {
        $securePassword = (new-object System.Security.SecureString)
    }
    $cred = New-Object System.Management.Automation.PSCredential($deployed.username, $securePassword)
    echo "New-Service -Name $serviceName -BinaryPathName $($deployed.binaryPathName) -DependsOn $($deployed.dependsOn) -Description $description -DisplayName $displayName -StartupType $($deployed.startupType) -Credential $cred"
    New-Service -Name $serviceName -BinaryPathName $($deployed.binaryPathName) -DependsOn $($deployed.dependsOn) -Description $description -DisplayName $displayName -StartupType $($deployed.startupType) -Credential $cred
} else {
    echo "New-Service -Name $serviceName -BinaryPathName $($deployed.binaryPathName) -DependsOn $($deployed.dependsOn) -Description $description -DisplayName $($displayName) -StartupType $($deployed.startupType) | Out-Null"
    New-Service -Name $serviceName -BinaryPathName $($deployed.binaryPathName) -DependsOn $($deployed.dependsOn) -Description $description -DisplayName $($displayName) -StartupType $($deployed.startupType) | Out-Null
    #New-Service -Name $serviceName -BinaryPathName $deployed.binaryPathName -DependsOn $deployed.dependsOn -Description $description -DisplayName $displayName -StartupType $deployed.startupType | Out-Null
}

