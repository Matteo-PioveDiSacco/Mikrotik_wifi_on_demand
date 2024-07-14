/system script
add name="ActivateWLAN" policy=read,write,policy,test source={
    :global activationTime
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :log info ("Attivazione " . $wlanInterfaceName . " per " . $activationTime)
    /interface wireless enable $wlanInterfaceName
    /interface/ethernet/set $IfPoe poe-out=forced-on
    /system scheduler add name=DeactivateWLAN start-time=+($activationTime-$predisactivation) interval=0 on-event=Predisattivo
}
