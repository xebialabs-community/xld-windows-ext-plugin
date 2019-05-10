#
# Copyright 2019 XEBIALABS
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

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
