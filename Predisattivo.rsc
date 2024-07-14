/system script
add name="Predisattivo" policy=read,write,policy,test source={
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :local EndTime ([/system clock get time]+$predisactivation)
    :log info ("Inizio periodo di Pre disattivazione")
    :while (([/system clock get time] < $EndTime)and!([/interface/wireless/get $wlanInterfaceName value-name=disabled])) do={
        /interface/ethernet/set $IfPoe poe-out=off
        :delay 500ms
        /interface/ethernet/set $IfPoe poe-out=forced-on
        :delay 500ms
    }
    /system script DeactivateWLAN
}
