/system script
add name="ModeButtonScript" policy=read,write,policy,test comment="Controlla la pressione del pulsante" source={
    :global ModeButtonPressCount
    :global pacchetto
    :global restart 0
    :local sched
    # Verifica che pacchetto  installato
    :if ($pacchetto="wireless") do={
        :set sched Predisattivo1
    } else={
        :set sched Predisattivo2
    }
    
    :if ([:len $ModeButtonPressCount] = 0) do={
        :set ModeButtonPressCount 0
    }
    
    :set ModeButtonPressCount ($ModeButtonPressCount + 1)
    
    :if ($ModeButtonPressCount = 1) do={
        :log info "Tasto MODE premuto una volta"
        /system scheduler add comment="Cattura il doppio click" name=CheckDoublePress start-time=([/system clock get time]+1s) interval=0 on-event={
            :global ModeButtonPressCount
            :local sched
            :if ($pacchetto="wireless") do={
        :set sched Predisattivo1
    } else={
        :set sched Predisattivo2
    }
            :if ($ModeButtonPressCount = 1) do={
                :if ([/system scheduler/print count-only where name=$sched]=0) do={
                    /system script run ActivateWLAN
                }                 
                :if ([/system/script/job/print count-only where script=$sched]=1) do={
                    :global restart 1
                    :delay 200ms
                    /system scheduler remove $sched
                    /system script run ActivateWLAN
                }
            }
            :set ModeButtonPressCount 0
            /system scheduler remove CheckDoublePress
        }
    } else={
        :log info "Tasto MODE premuto due volte"
        /system script run DeactivateWLAN
        :set ModeButtonPressCount 0
        :if ([/system scheduler/print count-only where name=CheckDoublePress]=1) do={
            /system scheduler remove CheckDoublePress
        }
      }
}
