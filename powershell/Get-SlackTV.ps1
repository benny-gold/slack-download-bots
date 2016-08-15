function Get-SlackTV{
    Param
    (
    [Parameter(Mandatory=$true,Position=0)]
    $tvSearchString
    )

    Import-Module "$psscriptroot\NZB-Powershell" -force
    $operationObject = New-Object System.Object

    $tvdbid = Get-TVDBId -APIKey $TVDBIDKey -show $tvsearchString 
    Write-Verbose "$($IMDBID.title) Is the IMDB Movie"
    if($tvdbid -eq $null)
        {
        $operationObject | Add-Member -type NoteProperty -name output -value  "$tvsearchString wasn't found on the TVDB... Try again." 
        $operationObject | Add-Member -type NoteProperty -name success -value $false
    }     
    else{    
        $SonarrAdd = Add-SonarrSeries -sonarrURL $SonarrURL -sonarrAPIKey $SonarrKey `
                        -tvSeriesTitle $tvdbid.SeriesName `
                        -TVDBID $tvdbid.id -seasons 1,2 -qualityProfileId 2 `
                        -rootFolderPath $rootFolderPath 
                        

        if ($SonarrAdd -eq $false) {
            $operationObject | Add-Member -type NoteProperty -name output -value "$($tvdbid.SeriesName) wasn't added to Sonarr...`n`Details:`n$($couchAdd | ConvertTo-Json)"
            $operationObject | Add-Member -type NoteProperty -name success -value $SonarrAdd
            }
        else {
            $operationObject | Add-Member -type NoteProperty -name output -value "$($tvdbid.SeriesName) has been added to Sonarr...`nhttp://thetvdb.com/banners/$($tvdbid.banner)"
            $operationObject | Add-Member -type NoteProperty -name success -value $true            
        }     
    }
    $operationObject = $operationObject | convertto-Json   
    return $operationObject
}