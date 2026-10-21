param([string]$StatusFile)
$ErrorActionPreference = 'Stop'

function Set-ResetStatus([string]$State) {
    if ($StatusFile) { [IO.File]::WriteAllText($StatusFile, $State) }
}

function Test-RootPassword([string]$Client, [string]$Password) {
    $info = New-Object Diagnostics.ProcessStartInfo
    $info.FileName = $Client
    $info.Arguments = '--protocol=TCP --host=127.0.0.1 --port=3306 --connect-timeout=2 --user=root --batch --execute="SELECT 1"'
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.EnvironmentVariables['MYSQL_PWD'] = $Password
    $clientProcess = [Diagnostics.Process]::Start($info)
    try {
        if (-not $clientProcess.WaitForExit(5000)) { $clientProcess.Kill(); return $false }
        return $clientProcess.ExitCode -eq 0
    } finally { $clientProcess.Dispose() }
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Set-ResetStatus 'administrator-required'
    throw 'Run this script in an Administrator PowerShell window.'
}

$privateFolder = $null
$configChanged = $false
$configRestored = $false
$originalConfig = $null
$password = $null
$confirmation = $null
$phase = 'service-check'
try {
    $service = Get-CimInstance Win32_Service -Filter "Name='MySQL80'"
    if (-not $service -or $service.PathName -notmatch '^"([^\"]+)"\s+--defaults-file="([^\"]+)"\s+MySQL80\s*$') {
        throw 'The MySQL80 service configuration differs from the expected installation.'
    }
    $server = $Matches[1]
    $configFile = $Matches[2]
    $client = Join-Path (Split-Path $server) 'mysql.exe'
    if (-not (Test-Path -LiteralPath $client)) { throw 'MySQL client was not found.' }
    $originalConfig = [IO.File]::ReadAllBytes($configFile)
    if ([Text.Encoding]::UTF8.GetString($originalConfig) -match '(?im)^\s*init[-_]file\s*=') {
        throw 'An init-file setting already exists. No configuration changes were made.'
    }

    Set-ResetStatus 'waiting-for-password'
    $phase = 'password-prompt'
    Write-Host 'Reset the MySQL root password. Your databases will be preserved.'
    Write-Host 'Choose a password you will remember. Do not share it in chat.'
    while ($true) {
        $secret = Read-Host 'New MySQL root password (at least 8 characters)' -AsSecureString
        $repeat = Read-Host 'Enter the new password again' -AsSecureString
        $password = [Net.NetworkCredential]::new('', $secret).Password
        $confirmation = [Net.NetworkCredential]::new('', $repeat).Password
        $secret.Dispose(); $repeat.Dispose()
        if ($password.Length -ge 8 -and $password -ceq $confirmation -and $password -notmatch '[\x00\r\n]') { break }
        Write-Host 'Passwords must match and contain at least 8 characters. Please retry.'
    }
    $confirmation = $null

    # Keep the temporary SQL outside the repository and OneDrive. Only the
    # current user, administrators, SYSTEM, and the service identity can read it.
    $privateFolder = Join-Path $env:ProgramData ('RailwayMySQLReset-' + [Guid]::NewGuid().ToString('N'))
    $phase = 'private-file-setup'
    New-Item -ItemType Directory -Path $privateFolder | Out-Null
    $acl = New-Object Security.AccessControl.DirectorySecurity
    $acl.SetAccessRuleProtection($true, $false)
    foreach ($sid in @($identity.User.Value, 'S-1-5-32-544', 'S-1-5-18')) {
        $rule = [Security.AccessControl.FileSystemAccessRule]::new([Security.Principal.SecurityIdentifier]::new($sid), 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        $acl.AddAccessRule($rule)
    }
    $serviceSid = ([Security.Principal.NTAccount]::new($service.StartName)).Translate([Security.Principal.SecurityIdentifier])
    $acl.AddAccessRule([Security.AccessControl.FileSystemAccessRule]::new($serviceSid, 'ReadAndExecute', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))
    Set-Acl -LiteralPath $privateFolder -AclObject $acl
    $initFile = Join-Path $privateFolder 'reset.sql'
    $backupFile = Join-Path $privateFolder 'my.ini.original'
    [IO.File]::WriteAllBytes($backupFile, $originalConfig)
    $escapedPassword = $password.Replace('\', '\\').Replace("'", "\'")
    $sql = "SET SESSION sql_mode = '';`nALTER USER 'root'@'localhost' IDENTIFIED BY '$escapedPassword';`n"
    [IO.File]::WriteAllText($initFile, $sql, [Text.UTF8Encoding]::new($false))
    $sql = $null; $escapedPassword = $null

    Set-ResetStatus 'resetting-password'
    $phase = 'password-reset'
    Write-Host 'Restarting MySQL to reset the password...'
    Stop-Service -Name MySQL80
    (Get-Service MySQL80).WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60))
    $initPath = $initFile.Replace('\','/')
    $addition = [Text.Encoding]::UTF8.GetBytes("`r`n[mysqld]`r`ninit-file=`"$initPath`"`r`n")
    $configChanged = $true
    [IO.File]::WriteAllBytes($configFile, [byte[]]($originalConfig + $addition))
    Start-Service -Name MySQL80
    $verified = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if (Test-RootPassword $client $password) { $verified = $true; break }
        Start-Sleep -Seconds 2
    }
    if (-not $verified) { throw 'The new password could not be verified. Original server settings will be restored.' }

    # Remove the password SQL before restoring normal service operation.
    Remove-Item -LiteralPath $initFile -Force
    $phase = 'normal-restart'
    Stop-Service -Name MySQL80
    (Get-Service MySQL80).WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60))
    [IO.File]::WriteAllBytes($configFile, $originalConfig)
    $configRestored = $true
    Start-Service -Name MySQL80
    $verified = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if (Test-RootPassword $client $password) { $verified = $true; break }
        Start-Sleep -Seconds 2
    }
    if (-not $verified) { throw 'MySQL restarted but the new login could not be verified.' }
    Set-ResetStatus 'success'
    Write-Host 'Success: MySQL root password reset and normal service restarted.' -ForegroundColor Green
    Write-Host 'Use your NEW password with start-mysql.ps1.'
} catch {
    Set-ResetStatus "failed:$phase"
    # Avoid printing server logs, SQL, or exceptions that could include a password.
    Write-Host 'Reset did not finish. Restoring the original MySQL configuration.' -ForegroundColor Red
} finally {
    $password = $null; $confirmation = $null
    if ($configChanged -and -not $configRestored) {
        try {
            Stop-Service -Name MySQL80 -ErrorAction SilentlyContinue
            (Get-Service MySQL80).WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60))
            [IO.File]::WriteAllBytes($configFile, $originalConfig)
            $configRestored = $true
            Start-Service -Name MySQL80
        } catch { Set-ResetStatus 'restore-needs-attention' }
    } elseif ($configChanged -and (Get-Service MySQL80).Status -eq 'Stopped') {
        try { Start-Service -Name MySQL80 } catch { Set-ResetStatus 'restore-needs-attention' }
    }
    if ($privateFolder) {
        $secretSql = Join-Path $privateFolder 'reset.sql'
        if (Test-Path -LiteralPath $secretSql) { Remove-Item -LiteralPath $secretSql -Force }
        if ((-not $configChanged) -or $configRestored) {
            # Only the exact freshly created recovery folder can be removed.
            $expectedParent = [IO.Path]::GetFullPath($env:ProgramData).TrimEnd('\')
            if ((Split-Path $privateFolder) -eq $expectedParent -and (Split-Path $privateFolder -Leaf) -match '^RailwayMySQLReset-[a-f0-9]{32}$') {
                Remove-Item -LiteralPath $privateFolder -Recurse -Force
            }
        }
    }
}
Read-Host 'Press Enter to close' | Out-Null
