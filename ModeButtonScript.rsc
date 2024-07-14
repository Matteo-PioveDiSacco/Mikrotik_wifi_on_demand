/system script
add name="ModeButtonScript" policy=read,write,policy,test source={
    :global ModeButtonPressCount
    :if ([:len $ModeButtonPressCount] = 0) do={
        :set ModeButtonPressCount 0
    }
    
    :set ModeButtonPressCount ($ModeButtonPressCount + 1)
    
    :if ($ModeButtonPressCount = 1) do={
        :log info "Tasto MODE premuto una volta"
        /system scheduler add name=CheckDoublePress start-time=+2s interval=0 on-event={
            :global ModeButtonPressCount
            :if ($ModeButtonPressCount = 1) do={
                /system script run ActivateWLAN
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