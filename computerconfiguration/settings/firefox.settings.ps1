Write-Output "### Firefox"

# Enable SSO for Firefox
Write-Output "Enabling Azure AD SSO"
$manifestPath = Join-Path -Path $env:ProgramFiles -ChildPath "Windows Security\BrowserCore\manifest-firefox.json"
$manifest = @"
{
    "name": "com.microsoft.browsercore",
    "description": "BrowserCore",
    "path": "BrowserCore.exe",
    "type": "stdio",
    "allowed_extensions": [
        "{d4a5b766-4831-43f0-9d38-0fec359491e7}"
    ]
}
"@

Set-Content -Path $manifestPath -Value $manifest

$messagingHostsPath = "HKCU:\Software\Mozilla\NativeMessagingHosts\com.microsoft.browsercore"
if (-not (Test-Path $messagingHostsPath)) {
    New-Item -Path $messagingHostsPath -ItemType String -Value $manifestPath -Force
}
else {
    Set-Item -Path $messagingHostsPath -Value $manifestPath -Force
}

