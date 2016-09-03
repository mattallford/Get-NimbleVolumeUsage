
function Get-NimbleVolumeUsage{
<#
.Synopsis
   Gathers the compressed and uncompressed usage in GB from volumes on a Nimble Storage Array

.EXAMPLE
    Get-NimbleVolumeUsage -NimbleGroup nimblegroup.lab.allford.id.au -Outputfile c:\scripts\Nimble_Statistics.csv

.PARAMETER NimbleGroup
    Specify the FQDN or IP address for the management interface of the Nimble Storage Group

.PARAMETER OutputFile
    Specify the full path for the OutputFile (CSV)

.LINK
http://blog.allford.id.au/2016/esxi-and-nimble-storage-unmap-scsi-blocks/ ‎

.NOTES
Written By: Matt Allford
Website:	http://blog.allford.id.au
Twitter:	http://twitter.com/mattallford

Change Log
V1.00, 11/06/2016 - Initial version
#>

    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $NimbleGroup,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $Outputfile

    )

#Create an emptry array to store the data in
$Report = @()

#Import Nimble Powershell Module
try
{
    Import-Module NimblePowershellToolkit
    Write-Verbose "Importing NimblePowershellToolkit Module"
}
Catch
{
    write-host “Exception Message: $($_.Exception.Message)” -ForegroundColor Red
    Write-Verbose "Issue importing the NimblePowershellToolkit Module"
    break
}

#Connect to Nimble Storage Array
$NSGroupCreds = get-credential -Message "Enter the username and password for a user account on the Nimble Storage array"
Write-Verbose "Connecting to NSGroup"
Connect-NSGroup -group $NimbleGroup -credential $NSGroupCreds

$Volumes = get-NSVolume

    #Iterate through the volumes and store the usage (compressed and uncompressed) in GB in variables
    foreach ($Volume in $Volumes){
        Write-Verbose "Gathering data from $($Volume.Name)"

        $CompressedGB = $Volume.vol_usage_compressed_bytes / 1GB
        $UnCompressedGB = $Volume.vol_usage_uncompressed_bytes / 1GB

        #Write the data to a new object
        $hash = [Ordered]@{            
            VolumeName = $Volume.name                 
            CompressedGB = $CompressedGB
            UnCompressedGB = $UnCompressedGB
        }                                
        $Object = New-Object PSObject -Property $hash
        #Add the data to the array
        $Report += $Object

    }

#After data for all volumes has been gathered, export the information to the CSV file specified in the $OutputFile variable
Write-Verbose "Exporting Data to Output File"
$Report | Export-Csv $OutputFile -NoTypeInformation

}