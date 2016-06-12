# Get-NimbleVolumeUsage
Get-NimbleVolumeUsage is a powershell function that gathers the compressed and uncompressed usage in GB from volumes within a Nimble Storage Group

Requires the Nimble storage Powershell Module, available from Nimble Infosight

# Parameters
- NimbleGroup - Specify the FQDN or IP address for the management interface of the Nimble Storage Group
- OutputFile - Specify the full path for the OutputFile (CSV)

# Example Usage
The following will get the volumename, uncompressed size (GB) and compressed size (GB) of volumes hosted in the NimbleGroup nimblegroup.lab.allford.id.au and export the information to Nimble_Statistics.csv

Get-NimbleVolumeUsage -NimbleGroup nimblegroup.lab.allford.id.au -Outputfile c:\scripts\Nimble_Statistics.csv

# Change Log
V1.00, 12-06-2016 - Initial Version

#Future ideas
- Allow an input file to be specified that contains specific volume names
- Specify the unit (MB, GB or TB) to be used to calculate the used space