# Windows PowerShell Network Monitor
Monitors internet connectivity.

## How It Works
* Automatic `$gateway` detection.
* Tests `$destination` connection at `$seconds` intervals.
* If `$destination` fails, display warning, play `Beep` sound, halve `$seconds`.
* If `$destination` and `$gateway` fail, display error, play `Hand` sound, quarter `$seconds`.

Default Windows 11 `System.Media.SystemSounds` are identical except `Hand` making it our preferred _error_ sound.

### Usage
`.\networkmonitor.ps1 -destination example.com -gateway 192.168.1.1 -seconds 5`

All parameters optional.

### Shortcut
`powershell -NoProfile -ExecutionPolicy Bypass -File ".\networkmonitor.ps1"`

Runs script without loading user profiles and bypasses execution policy restrictions.
