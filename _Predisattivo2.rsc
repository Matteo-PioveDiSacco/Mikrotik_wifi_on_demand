/system script
add name="Predisattivo2" policy=read,write,policy,test comment="Lampeggio del pulsante" source={
# Questo script viene attivato solamente in presenza dei pacchetti "Wifi-qcom" o "wifi-qcom-ac"
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :global restart
    :local EndTime ([/system clock get time]+$predisactivation)
    :log info ("Inizio periodo di Pre disattivazione")
    
    :while (([/system clock get time] < $EndTime)and!([/interface/wifi/get $wlanInterfaceName value-name=disabled])and($restart=0)) do={
        /interface/ethernet/set $IfPoe poe-out=off
        :delay 500ms
        /interface/ethernet/set $IfPoe poe-out=forced-on
        :delay 500ms
        }

    :if ($restart=0) do={/system script run DeactivateWLAN}
    :global restart 0
}
