Write-Host "`n--- Ping Test ---"
Test-Connection google.com -Count 4

Write-Host "`n--- DNS Test ---"
Resolve-DnsName google.com

Write-Host "`n--- System Info ---"
Get-ComputerInfo | Select-Object OsName, OsArchitecture, CsSystemType, WindowsVersion

Write-Host "`n--- CPU and Memory ---"
Get-Counter '\Processor(_Total)\% Processor Time'
Get-Counter '\Memory\Available MBytes'

Write-Host "`n--- Port Scan (22, 80, 443) ---"
$ports = @(22, 80, 443)
foreach ($p in $ports) {
    $socket = New-Object Net.Sockets.TcpClient
    try {
        $socket.Connect("127.0.0.1", $p)
        Write-Host "Port $p is OPEN"
    } catch {
        Write-Host "Port $p is CLOSED"
    }
    $socket.Close()
}