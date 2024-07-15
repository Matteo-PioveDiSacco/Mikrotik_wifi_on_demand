/system script
add name="SetGlobalVariables" policy=read,write,policy,test source={
    :global activationTime 10m
    :global wlanInterfaceName wlan1
    :global IfPoe ether2
    :global predisactivation 1m
}
