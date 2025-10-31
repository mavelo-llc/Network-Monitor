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
   networkmonitor.ps1 -destination example.com -gateway 192.168.1.1 -seconds 4
.EXAMPLE
   networkmonitor.ps1 -d example.com -g 192.168.1.1 -s 4
.NOTES
  Version: 1.1
  Author: Mavelo <www.mavelo.com>
  Creation Date: 2025-10-30
#>
param (
	[Alias("d","domain","i","ip")][String] $destination = "8.8.8.8",
	[Alias("g","r","router")][String] $gateway = $null,
	[Alias("s","delay")][Int] $seconds = 4
)
if ([String]::IsNullOrEmpty($destination)) {
	 $destination = "8.8.8.8"
}
if ([String]::IsNullOrEmpty($gateway)) {
	 $gateway = (Get-NetRoute | Where-Object { $_.NextHop -ne "::" -and $_.NextHop -ne "0.0.0.0" }).NextHop | Select-Object -First 1
}
if (($seconds = [Math]::Ceiling($seconds)) -lt 1) {
	$seconds = 4
}
Clear-Host
Write-Host "Network Monitor 1.1 - Mavelo LLC <mavelo.com>"
if ($destination -and $gateway -and $seconds) {
	Write-Host "Destination: $destination, Gateway: $gateway, Seconds: $seconds"
	$spinner = "⣷⣯⣟⡿⢿⣻⣽⣾".ToCharArray()
	$i = 0
	while ($true) {
		$time = Get-Date -format "[yyyy-MM-dd HH:mm:ss]"
		if (Test-Connection $destination -Count 1 -Quiet) {
			Write-Host -NoNewline -ForegroundColor Green "`r$($spinner[$i])"
			$sleep = $seconds
		} elseif (Test-Connection $gateway -Count 1 -Quiet) {
			Write-Host -NoNewline "`r$time LOST INTERNET" -ForegroundColor DarkYellow
			Write-Host ""
			$sleep = [Math]::Ceiling($seconds / 2)
			[System.Media.SystemSounds]::Beep.Play()
		} else {
			Write-Host -NoNewline "`r$time LOST GATEWAY" -ForegroundColor Red
			Write-Host ""
			$sleep = [Math]::Ceiling($seconds / 4)
			[System.Media.SystemSounds]::Hand.Play()
		}
		$i = ++$i % $spinner.Length
		Start-Sleep -Seconds $sleep
	}
} else {
	throw "Destination, Gateway and Seconds parameters are required!"
}
