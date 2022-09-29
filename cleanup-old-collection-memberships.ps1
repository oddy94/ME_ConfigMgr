# Site configuration
$SiteCode = "BE0" # Site code 
$ProviderMachineName = "z3012scm200.infra.be.ch" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

$collection = 'OSD-PRD-W10-ReInstall-kt.be.ch'

$rules = Get-CMDeviceCollectionDirectMembershipRule -CollectionName $collection
$yup = 'yup'
$nope = 'nope'
$counter = 0
foreach ($rule in $rules){
    $rulename = $rule.RuleName
    $resourceid = $rule.ResourceID

    # Get Device by ID from the membership rule
    $device = Get-CMDevice -ResourceId $resourceid -fast

    # when device is created before last 14 days
$creationdate = (Get-Date $device.creationdate)
$enddate = $timestamp.adddays(-14)

if($creationdate -le $enddate){
    Write-Output "Run script"
        $timestamp = Get-Date
        $counter++

        # ... delete Membership Rule
        Write-Host 'Removing Collection Membership for'${rulename}' at '${timestamp}'| Deletion Number:' ${counter}
        Remove-CMDeviceCollectionDirectMembershipRule -CollectionName $collection -ResourceId $resourceid -force
        Write-Output "Date in range"
        $device.creationdate
    }
 else{
    Write-Output "Date out of range"
    $device.CreationDate
}


   $creationdate = ''
   $rulename = ''
   $resourceid = ''
   $device = ''
}

