/system script
add name="ActivateWLAN" policy=read,write,policy,test comment="Attivazione Wifi" source={
    :global activationTime
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :log info ("Attivazione " . $wlanInterfaceName . " per " . $activationTime)
    /interface wireless enable $wlanInterfaceName
    /interface/ethernet/set $IfPoe poe-out=forced-on
    /system scheduler add name=Predisattivo start-time=([/system clock get time]+$activationTime-$predisactivation) interval=0 on-event=Predisattivo comment="Sequenza di pre abbattimento"
}
