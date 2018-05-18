# ==========================================================================
# 
# 	Script Name:  	    Get-Time Difference
#   Author     :        Medini M
#  Last modified:       05/18/18
# 
# =========================================================================

function Get-TimeDiff {
    <#
    .SYNOPSIS
    Gets the time difference between two windows servers/clients.
 
    .DESCRIPTION
    Uses WMI to get the time of a remote server
 
    .PARAMETER  Server
    The Server to get the date and time from
    .EXAMPLE
    Get-TimeDiff -Server server01.domain.local
 
    .EXAMPLE
    Get-TimeDiff server01.domain.local -Credential (Get-Credential)
 
    #>
    [CmdletBinding()]
    param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$True)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $ServerName,
 
    $Credential
 
    )
    begin {
        Write-Host "Starting script"
    }

    Process {
   
        if (Test-Connection -ComputerName $serverName -quiet -count 1){
 
            try {
 
                If ($Credential) {
                $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $serverName -Credential $Credential
                } Else {
                $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $serverName
                }
            }
            catch {
                throw
            }
 
            $Times = New-Object PSObject -Property @{
            ServerName = $DT.__Server
            DateTime = (Get-Date -Day $DT.Day -Month $DT.Month -Year $DT.Year -Minute $DT.Minute -Hour $DT.Hour -Second $DT.Second)
            Difference = (New-TimeSpan -Start (get-date) -End  (Get-Date -Day $DT.Day -Month $DT.Month -Year $DT.Year -Minute $DT.Minute -Hour $DT.Hour -Second $DT.Second))
            }
        } else {
        $Times = New-Object PSObject -Property @{
        ServerName = $serverName
        DateTime = "Offline"
        Difference = "Offline"
        }
        }
        $Times
   }
   end {
        Write-Host "ending script"
   } 
}

