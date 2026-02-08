#Setup
:global InterfaceName WAN
:global CFAPI "https://api.cloudflare.com/client/v4"
:global CFToken ""
:global CFZoneID ""
:global CFRecord "asdf.com"
:global CFZAPI ($CFAPI."/zones/".$CFZoneID)
:global CFIDLength 32

#Get address from interface.
:global WANIP [/ip/address/get value-name=address number=[find interface=$InterfaceName]]
:set WANIP [:pick $WANIP 0 [:find $WANIP "/"]]

/log/info ("CF-Update-DNS: Found IP address from ".$InterfaceName." interface: ".$WANIP)

#Get record ID from CF
:global CFSearchResult [/tool/fetch url=($CFZAPI."/dns_records?name=".$CFRecord) http-header-field=("Authorization:Bearer ".$CFToken.",Content-Type:application/json") output=user as-value]

#Parse record ID
:set CFSearchResult ($CFSearchResult->"data")
:global IDIndex [:find $CFSearchResult "\"id\":\""]
:set IDIndex ($IDIndex+6)
:global CFRecordID [:pick $CFSearchResult $IDIndex ($CFIDLength+$IDIndex)]

/log/info ("CF-Update-DNS: Found Record ID from ".$CFRecord." record: ".$CFRecordID)

#Commit to CF
/log/info ("CF-Update-DNS: Sent to CF: ".[/tool/fetch url=($CFZAPI."/dns_records/".$CFRecordID) http-header-field=("Authorization:Bearer ".$CFToken.",Content-Type:application/json") output=user as-value http-method=put http-data=("{\"type\":\"A\",\"name\":\"".$CFRecord."\",\"content\":\"".$WANIP."\",\"ttl\":1}")]->"data")
