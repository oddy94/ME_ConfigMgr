$Siteserver = "server fqdn"
$SiteCode = "3 digit site code"
$colID = "collectionID"
$cred = Get-Credential
$me = "device name"

$namespace = “root/SMS/site_$sitecode"

#get the CM Device as an object
$CMDevice = Get-WmiObject -Namespace root\sms\site_$sitecode -ComputerName $siteserver -credential $cred -Query "select * from sms_r_system where Name='$me'"

#get the CM Collection as an object
$CMCollection = Get-WmiObject -Namespace root\sms\site_$sitecode -ComputerName $siteserver -credential $cred -Query "select * from sms_collection where CollectionID='$colID'"

#create the direct membership rule object
$CMRule = ([WMIClass]”\\$siteserver\root\sms\site_$sitecode:SMS_CollectionRuleDirect”).CreateInstance()

#Define the rule properties
$CMRule.ResourceClassName = "SMS_R_System"
$CMRule.RuleName = $CMDevice.Name
$CMRule.ResourceID = $CMDevice.ResourceID

#use Method to add the rule to the collection object
$CMCollection.AddMembershipRule($CMRule)

#commit the rule change to the collection
$CMCollection.Put()

#update the collection membership
$CMCollection.RequestRefresh()
