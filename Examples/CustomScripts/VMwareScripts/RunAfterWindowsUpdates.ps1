# Copyright 2016 Cloudbase Solutions Srl

function Install-VMwareTools {
    # Install VMWare Tools
    $tempDir = Join-Path $env:TEMP "vmware-tools"
    mkdir $tempDir
    Push-Location $tempDir

    # VMware tools prerequisites
    Start-BitsTransfer "http://balutoiu.com/ionut/vmware-tools/vcredist_x86.exe"
    $p = Start-Process -Wait -PassThru -FilePath "$tempDir\vcredist_x86.exe" -ArgumentList @("/q")
    if ($p.ExitCode -ne 0) {
        throw "Failed to install vcredist_x86"
    }

    Start-BitsTransfer "http://balutoiu.com/ionut/vmware-tools/vcredist_x64.exe"
    $p = Start-Process -Wait -PassThru -FilePath "$tempDir\vcredist_x64.exe" -ArgumentList @("/q")
    if ($p.ExitCode -ne 0) {
        throw "Failed to install vcredist_x64"
    }

    Start-BitsTransfer "http://balutoiu.com/ionut/vmware-tools/VMware-Tools64.msi"
    $p = Start-Process -Wait -PassThru -FilePath "$tempDir\VMware-Tools64.msi" -ArgumentList @("/passive", "REBOOT=R", "ADDLOCAL=ALL")
    # Exit code 3010 -> ERROR_SUCCESS_REBOOT_REQUIRED, A restart is required to complete the install. This message is indicative of a success.
    if (($p.ExitCode -ne 3010) -and ($p.ExitCode -ne 0)) {
        throw "Failed to install vmware tools"
    }

    Pop-Location
    Remove-Item -Recurse -Force $tempDir
}

Install-VMwareTools
