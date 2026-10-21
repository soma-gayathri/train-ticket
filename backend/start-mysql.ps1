param(
    [string]$DbUser = 'root',
    [string]$DbHost = 'localhost',
    [int]$DbPort = 3306,
    [string]$DbName = 'railway'
)
$ErrorActionPreference = 'Stop'
if ($DbHost -notmatch '^[a-zA-Z0-9.-]+$' -or $DbName -notmatch '^[a-zA-Z0-9_]+$' -or $DbPort -lt 1 -or $DbPort -gt 65535) {
    throw 'Use a valid database host, port, and database name.'
}
$savedUrl = $env:DB_URL
$savedUser = $env:DB_USERNAME
$savedPassword = $env:DB_PASSWORD
$savedMysqlPassword = $env:MYSQL_PWD
Push-Location $PSScriptRoot
try {
    $env:DB_URL = "jdbc:mysql://${DbHost}:${DbPort}/${DbName}"
    $env:DB_USERNAME = $DbUser
    if (-not $env:DB_PASSWORD) {
        $secret = Read-Host "MySQL password for $DbUser (hidden)" -AsSecureString
        $env:DB_PASSWORD = [System.Net.NetworkCredential]::new('', $secret).Password
        $secret.Dispose()
    }
    $mysqlCommand = Get-Command mysql -ErrorAction SilentlyContinue
    $mysqlClient = if ($mysqlCommand) { $mysqlCommand.Source } else {
        Get-ChildItem -Path "$env:ProgramFiles/MySQL/*/bin/mysql.exe" -File -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
    }
    if (-not $mysqlClient) { throw 'MySQL client not found. Add its bin folder to PATH, then retry.' }
    $env:MYSQL_PWD = $env:DB_PASSWORD
    $createDatabase = 'CREATE DATABASE IF NOT EXISTS `' + $DbName + '` CHARACTER SET utf8mb4'
    & $mysqlClient --protocol=TCP --host=$DbHost --port=$DbPort --user=$DbUser --execute=$createDatabase
    $setupExit = $LASTEXITCODE
    $env:MYSQL_PWD = $savedMysqlPassword
    if ($setupExit -ne 0) { throw 'MySQL connection/setup failed. Check the username, password, and server.' }
    & .\mvnw.cmd verify
    if ($LASTEXITCODE -ne 0) { throw 'Build failed. MySQL application was not started.' }
    & java -jar target/railway-api-0.0.1-SNAPSHOT.jar
    if ($LASTEXITCODE -ne 0) { throw 'Server stopped with an error. Check MySQL credentials and database setup.' }
} finally {
    $env:DB_URL = $savedUrl
    $env:DB_USERNAME = $savedUser
    $env:DB_PASSWORD = $savedPassword
    $env:MYSQL_PWD = $savedMysqlPassword
    Pop-Location
}
