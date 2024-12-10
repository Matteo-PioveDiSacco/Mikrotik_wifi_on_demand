/system script
add name="SetGlobalVariables" policy=read,write,policy,test comment="Setta a default le variabili Globali" source={
    :global activationTime 1m
    # ATTENZIONE!!!! Ricordarsi di scrivere il nome della giusta interfaccia:
    # se presente pacchetto wireless allora usare wlan,
    # se presente pacchetto wifi-qcom allora usare wifi.
    :global wlanInterfaceName wlan1
    :global IfPoe ether2
    :global predisactivation 30s
}
