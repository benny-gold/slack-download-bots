function Update-PoshBot 
    {
    [OutputType([Object])]
    Param
        (
        [Parameter(Mandatory=$True,Position=1)]
        [string]
        $botConfigPath
        )

    $botConfig = Get-Content $botConfigPath | convertfrom-json

    try {
        (gci $PSScriptRoot\coffee)+(gci $PSScriptRoot\powershell) | % {Copy-Item $_.FullName -destination "$($botConfig.BotPath)\scripts" -ErrorAction Stop}
        Copy-Item $PSScriptRoot\NZB-Powershell\ -Destination "$($botConfig.BotPath)\scripts" -Recurse -Container -force -ErrorAction Stop
    }
    catch [System.Exception] {
       write-warning "Unable to copy scripts to bot path" 
       
       
       return  $_.Exception.GetType().FullName, $_.Exception.Message      
    }
    Restart-Hubot -ConfigPath $botConfigPath
    }
