/system script
add name="DeactivateWLAN" policy=read,write,policy,test comment="Disattivazione del Wifi e spegnimento POE" source={
    :global restart
    :global ModeButtonPressCount
    :global wlanInterfaceName
    :global IfPoe
    :global pacchetto
    :log info ("Disattivazione " . $wlanInterfaceName . " e azzeramento del countdown")
    # Esegue il comando usando il contenuto delle variabili global
    :execute ("/interface/".$pacchetto." disable ".$wlanInterfaceName)
    /interface/ethernet/set $IfPoe poe-out=off
    :if ($pacchetto="wireless") do={
        :if ([/system scheduler/print count-only where name=Predisattivo1]>0) do={
            /system scheduler remove Predisattivo1
        }
    } else={
        :if ([/system scheduler/print count-only where name=Predisattivo2]>0) do={
            /system scheduler remove Predisattivo2
        }
    }
    # Elimina eventuali altri script e variabili 
    :if ([/system scheduler/print count-only where name=CheckDoublePress]>0) do={
        /system/scheduler remove CheckDoublePress
    }
    :if ([:len [:global ModeButtonPressCount]] > 0) do={
        :global ModeButtonPressCount 0
    }
    :if ([:len [:global restart]] > 0) do={
        :global restart 0
    }
}
