/system script
add name="ModeButtonScript" policy=read,write,policy,test comment="Controlla la pressione del pulsante" source={
    :global ModeButtonPressCount
    :global restart 0
    :if ([:len $ModeButtonPressCount] = 0) do={
        :set ModeButtonPressCount 0
    }
    
    :set ModeButtonPressCount ($ModeButtonPressCount + 1)
    
    :if ($ModeButtonPressCount = 1) do={
        :log info "Tasto MODE premuto una volta"
        /system scheduler add name=CheckDoublePress start-time=([/system clock get time]+1s) interval=0 on-event={
            :global ModeButtonPressCount
            :if ($ModeButtonPressCount = 1) do={
                :if ([/system scheduler/print count-only where name=Predisattivo]=0) do={
                    /system script run ActivateWLAN
                }                 
                :if ([/system/script/job/print count-only where script=Predisattivo]=1) do={
                    :global restart 1
                    /system scheduler remove Predisattivo
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
        /system scheduler remove CheckDoublePress
      }
}
