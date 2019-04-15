# stolen from https://gist.github.com/Meidor/a5b3661bc3208f33261d4ff9b04a68ce

$slackBaseDir = "$env:LocalAppData\Slack"
$installations = Get-ChildItem $slackBaseDir -Directory | Where-Object { $_.Name.StartsWith("app-") }
$version = $installations | Sort-Object { [version]$_.Name.Substring(4) } | Select-Object -Last 1
Write-Output "Select highest intalled Slack version: $version";

$modAdded = $false;
$customContent = @'

// slack-dARK-mode |-)

document.addEventListener('DOMContentLoaded', function() {
 $.ajax({
   url: 'https://raw.githubusercontent.com/Unrooted/Slack-Black/master/index.css',
   success: function(css) {
     $("<style></style>").appendTo('head').html(css);
   }
 });
});
'@

if ((Get-Content "$($version.FullName)\resources\app.asar.unpacked\src\static\index.js" | %{$_ -match "// laCour - slack-night-mode"}) -notcontains $true) {
    Add-Content "$($version.FullName)\resources\app.asar.unpacked\src\static\index.js" $customContent
    Write-Host "Mod Added To index.js";
    $modAdded = $true;
} else {
    Write-Host "Mod Detected In index.js - Skipping";
}

if ((Get-Content "$($version.FullName)\resources\app.asar.unpacked\src\static\ssb-interop.js" | %{$_ -match "// laCour - slack-night-mode"}) -notcontains $true) {
    Add-Content "$($version.FullName)\resources\app.asar.unpacked\src\static\ssb-interop.js" $customContent
    Write-Host "Mod Added To ssb-interop.js";
    $modAdded = $true;
} else {
    Write-Host "Mod Detected In ssb-interop.js - Skipping";
}

if ($modAdded -eq $true) {
    if((Get-Process "slack" -ErrorAction SilentlyContinue) -ne $null) {
        Write-Host "Mod Complete - Mod Will Take Effect After Slack Is Restarted";
    } else {
        Write-Host "Mod Complete";
    }
} else {
    Write-Host "Mod Already Active - No Further Action Is Needed.";
}
