/system script
add name="SetGlobalVariables" policy=read,write,policy,test comment="Setta a default le variabili Globali" source={
    :global activationTime 1m
    :global pacchetto
     # Controlla quale pacchetto attivare
    :if (([/system package find name="wifi-qcom"] != "") || ([/system package find name="wifi-qcom-ac"] != "")) do={
        :set pacchetto "wifi"
    } else={
        # Se nessuno dei due  presente, controlla il pacchetto "wireless"
        :if ([/system package find name="wireless"] != "") do={
            :set pacchetto "wireless"
        } else={
            :set pacchetto "nessuno"
        }
    }
    :log info ("Il gestore del Wifi e stato impostato a: $pacchetto")
    # ATTENZIONE!!!! Ricordarsi di scrivere il nome della giusta interfaccia:
    # se presente pacchetto wireless allora usare wlan,
    # se presente pacchetto wifi-qcom allora usare wifi.
    :global wlanInterfaceName wifi2
    :global IfPoe ether2
    :global predisactivation 30s
}
