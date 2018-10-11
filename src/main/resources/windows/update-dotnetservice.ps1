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

##############################################################
#  Stop Service Function
function Stop-Service-With-Timeout($serviceName, $timeout) {

    $scriptBlock = {
        param($serviceName)
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $ServiceName

    Write-Host "Waiting for service [$serviceName] to start..."

    # wait until the service becomes responsive
    Wait-Job -Job $job -Timeout $timeout | Out-Null

    # wait until the service transitions Running -> StopPending -> Stopped
    $retries = 0;
    while ((Get-Service -Name $serviceName).Status -ne "Stopped") {
        Start-Sleep -Seconds 1 | Out-Null
        if($retries++ -ge $timeout) {
            $serviceStatus = (Get-Service -Name $serviceName).Status
            Write-Host "Cannot stop service [$ServiceName]. Current state is [$serviceStatus] instead of [Stopped]. Please check the Services control panel and the Event Viewer."
            Exit 1
        }
    }

    # Wait for file handles to be released
    Start-Sleep -Seconds 1

    Write-Host "Service [$serviceName] has successfully been stopped."
}

##############################################################
#  Start Service Function
function Start-Service-With-Timeout($serviceName, $timeout) {

    $scriptBlock = {
        param($serviceName)
        Start-Service -Name $serviceName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $ServiceName

    Write-Host "Waiting for service [$serviceName] to start..."

    # wait until the service becomes responsive
    Wait-Job -Job $job -Timeout $timeout | Out-Null

    # wait until the service transitions Stopped -> StartPending -> Running
    $retries = 0;
    while ((Get-Service -Name $serviceName).Status -ne "Running") {
        Start-Sleep -Seconds 1 | Out-Null
        if($retries++ -ge $timeout) {
            $serviceStatus = (Get-Service -Name $serviceName).Status
            Write-Host "Cannot start service [$ServiceName]. Current state is [$serviceStatus] instead of [Running]. Please check the Services control panel and the Event Viewer."
            Exit 1
        }
    }

    # Wait for file handles to be released
    Start-Sleep -Seconds 1

    Write-Host "Service [$serviceName] has successfully been started."
}

##############################################################
#                     M A I N
##############################################################
Stop-Service-With-Timeout $serviceName $deployed.stopTimeout

# Remove old service content if it's still there
if (Test-Path $deployed.targetPath) {
	Write-Host "Removing old service content from [$($deployed.targetPath)]."
	Remove-Item -Recurse -Force $deployed.targetPath
}

# Copy new web content
Write-Host "Copying service content to [$($deployed.targetPath)]."
Copy-Item -Recurse -Force $deployed.file $deployed.targetPath

if($deployed.startupType -eq "Disabled") {
    Write-Host "Not starting service [$serviceName] because it has been disabled."
} else {
    Write-Host "Starting service [$serviceName]."
    if($deployed.startOnDeploy) {
      Start-Service-With-Timeout $serviceName $deployed.startTimeout
    }
}
