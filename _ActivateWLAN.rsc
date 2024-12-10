/system script
add name="ActivateWLAN" policy=read,write,policy,test comment="Attivazione Wifi" source={
    :global activationTime
    :global predisactivation
    :global wlanInterfaceName
    :global IfPoe
    :global pacchetto
    :log info ("Attivazione " . $wlanInterfaceName . " per " . $activationTime)
    # Esegue il comando usando il contenuto delle variabili global
    :execute ("/interface/".$pacchetto." enable ".$wlanInterfaceName)
    /interface/ethernet/set $IfPoe poe-out=forced-on
    # Esegue il giusto comando a seconda del valore della variabile$pacchetto
    :if ($pacchetto="wireless") do={
        /system scheduler add name=Predisattivo1 start-time=([/system clock get time]+$activationTime-$predisactivation) interval=0 on-event=Predisattivo1 comment="Sequenza di pre abbattimento"
    } else={
        /system scheduler add name=Predisattivo2 start-time=([/system clock get time]+$activationTime-$predisactivation) interval=0 on-event=Predisattivo2 comment="Sequenza di pre abbattimento"
    }
}
