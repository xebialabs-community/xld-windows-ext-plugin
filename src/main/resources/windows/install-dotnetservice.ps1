#
# Copyright 2018 XEBIALABS
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
