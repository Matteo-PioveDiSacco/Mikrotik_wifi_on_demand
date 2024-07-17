/system scheduler
add name="SetGlobalVariables" on-event=SetGlobalVariables start-time=startup comment="Applica le operazioni preliminari (Si esegue automaticamente ad ogni reboot)"
/system routerboard mode-button
set enabled=yes hold-time=0s..1s on-event=ModeButtonScript
