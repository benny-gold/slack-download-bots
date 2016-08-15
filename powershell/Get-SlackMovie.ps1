function Get-SlackMovie{
    Param
    (
    [Parameter(Mandatory=$true,Position=0)]
    $movieSearchString
    )

    Import-Module "$psscriptroot\NZB-Powershell" -force
    $operationObject = New-Object System.Object

    $IMDBID = Get-IMDBId -MovieName $movieSearchString 
    Write-Verbose "$($IMDBID.title) Is the IMDB Movie"
    if($IMDBID.title -eq $null)
        {
        $operationObject | Add-Member -type NoteProperty -name output -value  "$movieSearchString wasn't found on the IMDB... Try again." 
        $operationObject | Add-Member -type NoteProperty -name success -value $false
    }         
    else{
        if($IMDBID -is [System.Array])
            {
            Write-Verbose "Is array"
            $searchID = $IMDBID[0].imdbID 
            }
        else
            {
            Write-Verbose "Is not array"
            $searchID = $IMDBID.imdbID 
            }
            
        $couchAdd = Add-CouchpotatoMovie -CouchURL $CouchURL -CouchAPIKey $CouchAPIKey -MovieID $searchID
        $IMDBLink = "http://www.imdb.com/title/tt$($IMDBID.imdbID)"
        
        if ($couchAdd.Success -eq $true) {
            $operationObject | Add-Member -type NoteProperty -name output -value "$($couchadd.movie.title) has been added to CouchPotato...`n$IMDBLink"
            }
        else {
            $operationObject | Add-Member -type NoteProperty -name output -value "$($couchadd.movie.title) wasn't added to CouchPotato...`n`Details:`n$($couchAdd | ConvertTo-Json)"
        }
        $operationObject | Add-Member -type NoteProperty -name success -value $couchAdd.Success     
        }
    $operationObject = $operationObject | convertto-Json   
    return $operationObject
}