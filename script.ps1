Start-Transcript C:\AdminDir\2007UpdateTo2013\Upgradeto2013.log -force
#
#enter-pssession s29db05



<#  1.
#  ======================    �� ������� SRV-SPQL ������ backup ���� ������ WSS_CONTENT
#
get-date
write-host 1.
write-host �� ������� SRV-SPQL ������ backup ���� ������ WSS_CONTENT
write-host ... 50 �����...
        $gd = get-date
        $timeout = 2800
        $gd = $gd.AddSeconds($timeout)
        write-host ("��������� Backup-� ����������� � "+$gd.hour.ToString("D2")+":"+$gd.Minute.ToString("D2"))

#cd c:\AdminDir\SQLScripts\

remove-item \\s29portaldb.region.cbr.ru\c$\AdminDir\Backup\WSS_CONTENT.BAK

sqlcmd -S srv-spql -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step001.sql

$backfile001=get-item \\s29portaldb.region.cbr.ru\c$\AdminDir\Backup\WSS_CONTENT.BAK | select Name, Length
write-host $(get-date)
write-output $("Backup of SP2007 Completed: " + $backfile001.Name + " File Size: " + $backfile001.Length.ToString("N0")) 

# �� ������ ��������� ���� � ����� readonly

write-host 
write-host 
write-host 



# 2.
# =====================    �� ������� S29SPS-2010 Dismount-SPContentDatabase WSS_CONTENT_2007
#
write-host 2.
write-host =====================    �� ������� S29SPS-2010 Dismount-SPContentDatabase WSS_CONTENT_2007
get-date

psexec \\s29sps-2010  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd -d cmd /c C:\admindir\2007UpgradeTo2013\step002.cmd
type \\s29sps-2010\c$\admindir\2007UpgradeTo2013\step002.log

write-host 
write-host 
write-host 




# 3.
# =====================    �� ������� S29PORTALDB  restore database
#
write-host 3.
write-host =====================    �� ������� S29PORTALDB  restore database
get-date
# start/stop-sql

psexec \\s29portaldb  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd  cmd /c C:\admindir\2007UpgradeTo2013\step003.cmd

# drop db/restore db/grant rights
write-host DROP DATABASE [WSS_CONTENT_2007]
sqlcmd -S s29portaldb -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step003-1.sql
write-host RESTORE DATABASE [WSS_CONTENT_2007] 
sqlcmd -S s29portaldb -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step003-2.sql
write-host Grant Access
sqlcmd -S s29portaldb -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step003-3.sql


write-host 
write-host 
write-host 


# 4.
# =====================    �� ������� S29SPS-2010  Mount-SPContentDatabase
#
write-host 4.
write-host =====================    �� ������� S29SPS-2010  Mount-SPContentDatabase
get-date

psexec \\s29sps-2010  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd -d cmd  /c C:\admindir\2007UpgradeTo2013\step004.cmd


do{
        write-host Waiting file \\s29sps-2010\c$\admindir\2007UpgradeTo2013\step004.log.... 1 hour and 25 minutes seconds
        $gd = get-date
        $timeout = 5100
        $gd = $gd.AddSeconds($timeout)
        write-host ("����� �������� �� "+$gd.hour.ToString("D2")+":"+$gd.Minute.ToString("D2"))
	Start-Sleep ($timeout)   # ������� ������� �������� ���� ����������� �� 2007 � 2010
          
}
until(test-path \\s29sps-2010\c$\admindir\2007UpgradeTo2013\step004.stp)
 

write-host 
write-host 
write-host 


# 5.
# =====================    �� ������� S29SPS-2010  ��������� ������ �� ������� ���������
#
write-host 5.
write-host =====================    �� ������� S29SPS-2010  ��������� ������ �� ������� ���������
get-date
psexec \\s29sps-2010  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd -d cmd  /c C:\admindir\2007UpgradeTo2013\step005.cmd

        $gd = get-date
        $timeout = 4200
        $gd = $gd.AddSeconds($timeout)
        write-host ("����� �������� �� "+$gd.hour.ToString("D2")+":"+$gd.Minute.ToString("D2"))
	Start-Sleep ($timeout)   # ������� ������� �������� ���� �������� ���������

# write-host waiting 1 hour and 10 minutes
# Start-Sleep 4200
# write-host Restart s29sps-2010	
# shutdown /m \\s29sps-2010 /r /t 30
# 

write-host 
write-host 
write-host 
get-date



Start-Sleep 300





# 6.
# =====================    �� ������� S29SPS-2010  ��������� ���������� ���������� ��� ���� ������
#
write-host 6.
write-host =====================    �� ������� S29SPS-2010  ��������� ���������� ���������� ��� ���� ������
get-date
psexec \\s29sps-2010  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd cmd  /c C:\admindir\2007UpgradeTo2013\step006.cmd

write-host 
write-host 
write-host 
#

write-host 6. Passed
read-host



#
# 7.
# =====================    �� ������� s29portaldb  backup ����
#
write-host 7.
write-host =====================    �� ������� s29portaldb  ������ backup ����
get-date
remove-item \\s29db05\c$\AdminDir\Backup\JobPortal.bak
sqlcmd -S s29portaldb -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step007.sql

write-host 
write-host 
write-host 

#
# 8.
# =====================    �� ������� s29sps  Dismount-SPContentDatabase
#
write-host 8.
write-host =====================    �� ������� s29sps  Dismount-SPContentDatabase
get-date

Dismount-SPContentDatabase  WSS_Content-s29sps  -confirm:$false

iisreset /stop


write-host 
write-host 
write-host 

# 9.
# =====================    �� ������� s29db05  restore database
#
write-host 9.
write-host =====================    �� ������� S29DB05  restore database
get-date
# start/stop-sql

psexec \\S29DB05  -u region\29spsfarmadmin -p Ch@ngeP@ssW0rd  cmd /c C:\admindir\2007UpgradeTo2013\step009.cmd
write-host drop Database
sqlcmd -S s29db05 -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step009-1.sql
write-host Restore Database
sqlcmd -S s29db05 -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step009-2.sql
write-host Grant Rights
sqlcmd -S s29db05 -U sa -P Ch@ngeP@ssW0rd -i c:\AdminDir\2007UpdateTo2013\step009-3.sql


iisreset
write-host 
write-host 
write-host 

#>
# 10.
# =====================    �� ������� s29sps  mount database
#
write-host 10.
write-host =====================    �� ������� s29sps  mount database
get-date

Test-SPContentDatabase  -name WSS_Content-s29sps -WebApplication http://s29sps.region.cbr.ru

mount-SPContentDatabase  -name WSS_Content-s29sps -WebApplication http://s29sps.region.cbr.ru


Convert-SPWebApplication �Identity http://s29sps.region.cbr.ru �To Claims -RetainPermissions -Force

write-host 
write-host 
write-host 

# 11. 
# ========================= ������� alerts � ����� ����������� �������
#
write-host 11.
write-host =====================    ������� alerts � ����� ����������� �������
get-date


# �������������� ��� ���������� �� ������ ������������.

#$spweb=Get-SPWeb "http://s29sps.region.cbr.ru/deprts/nadz"
# $spList=$spw.Lists["��������� ����������� ������� �������"]
#$SPuser = $SPweb.EnsureUser('region\29astahovab')

#foreach($alert in $spweb.alerts)
#{
#	$alert.User=$SPuser;
#	$alert.Update()
        
#}
#write-host 
#write-host 
#write-host 



$spsite=get-spsite -Identity http://s29sps.region.cbr.ru

foreach ($spweb in $spsite.allwebs)
{
	if ($spweb.IsRootWeb)
	{
		$sppubweb=[Microsoft.Sharepoint.Publishing.PublishingWeb]::GetPublishingWeb($spweb)
		$sppubweb.Navigation.CurrentDynamicChildLimit=50
		$sppubweb.Update()
	}
        $spweb.SiteLogoUrl="/PublishingImages/gu_logo.gif"
        $spweb.Update()
}





# enable Mail Alerts for WebApp
$webapp=Get-SPWebApplication "http://s29sps.region.cbr.ru"
$webapp.AlertsEnabled=$true
$webapp.Update()
#


get-date
Stop-Transcript

# ����� 

#c:\AdminDir\featureAdmin2013.exe
#������������ �������� ������ � http://s29search.region.cbr.ru/Pages