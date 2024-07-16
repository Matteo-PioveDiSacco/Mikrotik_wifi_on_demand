/system script
add name="Predisattivo" policy=read,write,policy,test comment="Lampeggio del pulsante" source={
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :global restart
    :local EndTime ([/system clock get time]+$predisactivation)
    :log info ("Inizio periodo di Pre disattivazione")
    :while (([/system clock get time] < $EndTime)and!([/interface/wireless/get $wlanInterfaceName value-name=disabled])and($restart=0)) do={
        /interface/ethernet/set $IfPoe poe-out=off
        :delay 500ms
        /interface/ethernet/set $IfPoe poe-out=forced-on
        :delay 500ms
    }
    :if ($restart=0) do={/system script run DeactivateWLAN}
    :global restart 0
}
