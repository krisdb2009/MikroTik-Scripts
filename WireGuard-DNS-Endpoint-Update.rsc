:local name=peer value=peer1
:local name=hostname value=host.belowaverage.org

:local name=host value=[:resolve $hostname]
/interface/wireguard/peers
:if condition=([get number=[find name=$peer] value-name=endpoint-address] != $host) do={
    set numbers=[find name=$peer] endpoint-address=$host
}
