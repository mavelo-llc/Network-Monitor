<#
.DESCRIPTION
   Monitors internet connectivity.
.EXAMPLE
   networkmonitor.ps1
.EXAMPLE
   networkmonitor.ps1 -destination 1.2.3.4
.EXAMPLE
   networkmonitor.ps1 -destination example.com
.EXAMPLE
   networkmonitor.ps1 -destination example.com -gateway 192.168.1.1
.EXAMPLE
   networkmonitor.ps1 -destination example.com -gateway 192.168.1.1 -delay 5
.EXAMPLE
   networkmonitor.ps1 -d example.com -g 192.168.1.1 -s 5
.NOTES
  Version:        1.0
  Author:         Mavelo <www.mavelo.com>
  Creation Date:  2025-10-30
#>
param (
	[Alias("d","domain","i","ip")][string] $destination = "8.8.8.8",
	[Alias("g","r","router")][string] $gateway = $null,
	[Alias("s","delay")][int] $seconds = 5
)
if ([string]::IsNullOrEmpty($destination)) {
	 $gateway = "8.8.8.8"
}
if ([string]::IsNullOrEmpty($gateway)) {
	 $gateway = (Get-NetRoute | Where-Object { $_.NextHop -ne "::" -and $_.NextHop -ne "0.0.0.0" }).NextHop | Select-Object -First 1
}
if ($seconds -le 0) {
	$seconds = 5
}
if ($destination -and $gateway -and $seconds) {
	Write-Host "Network Monitor 1.0 - Mavelo LLC <mavelo.com>"
	Write-Host "Destination: $destination, Gateway: $gateway, Delay: $seconds"
	while ($true) {
		$timestamp = Get-Date -format "[yyyy-MM-dd HH:mm:ss]"
		if (Test-Connection $destination -Count 1 -Quiet) {
			Write-Host "$timestamp Connected to $destination" -ForegroundColor Green
			$sleep = $seconds
		} elseif (Test-Connection $gateway -Count 1 -Quiet) {
			Write-Host "$timestamp Connected to $gateway (no internet)" -ForegroundColor DarkYellow
			[System.Media.SystemSounds]::Beep.Play()
			$sleep = [Math]::Ceiling($seconds / 2)
		} else {
			Write-Host "$timestamp Connection failed" -ForegroundColor Red
			[System.Media.SystemSounds]::Hand.Play()
			$sleep = [Math]::Ceiling($seconds / 4)
		}
		Start-Sleep -Seconds $sleep
	}
} else {
	Write-Host "Destination, Gateway and Seconds required!" -ForegroundColor Red
	[System.Media.SystemSounds]::Hand.Play()
}
