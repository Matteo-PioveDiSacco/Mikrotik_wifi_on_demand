/system script
add name="DeactivateWLAN" policy=read,write,policy,test comment="Disattivazione del Wifi e spegnimento POE" source={
    :global wlanInterfaceName
    :global IfPoe
    :log info ("Disattivazione " . $wlanInterfaceName . " e azzeramento del countdown")
    /interface wireless disable $wlanInterfaceName
    /interface/ethernet/set $IfPoe poe-out=off
    /system scheduler remove Predisattivo
}
