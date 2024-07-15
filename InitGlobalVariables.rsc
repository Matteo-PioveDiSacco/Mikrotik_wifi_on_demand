/system scheduler
add name="InitGlobalVariables" on-event=SetGlobalVariables start-time=startup
/system routerboard mode-button
set enabled=yes hold-time=0s..1s on-event=ModeButtonScript
