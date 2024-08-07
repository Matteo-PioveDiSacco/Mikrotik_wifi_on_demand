# Mikrotik_wifi_on_demand
Tutti gli script Mikrotik necessari ad attivare il Wifi di un Access Point Mikrotik mediante pulsante esterno

Questi tre script servono per gestire l'attivazione <b>ON DEMAND</b> di un'interfaccia Wifi di un access point Mikrotik tra quelli compatibili (necessario RouterOS almeno alla versione 7.14).
Per utilizzare questi script è necessario che il dispositivo sia provvisto del tasto "MODE", sarà poi necessario modificare l'hardware della scheda madre in modo da collegare un pulsante esterno in parallelo al tasto "MODE" così da poter attivare lo script collegato.
Tutta questa parte viene spiegata bene in un video di Youtube all'indirizzo....., qui in GitHub vengono solamente mantenuti gli script.
<li>
  <b>Questi file con estensione txt</b><br>
  I file che sono presenti qui hanno estensione TXT ma in realtà sono dump di script RouterOS, l'uso si deve intendere come copia ed incolla tra il contenuto di questi file e l'interfaccia editor della sessione terminal di RouterOS.
</li>
<li>
  <b>pulsante</b><br>
  Questo è lo script che si attiva alla pressione del tasto "MODE", è in grado di capire se viene fatto un singolo click o doppio misurando il tempo intercorso tra due pressioni.
  La prima pressione imposta il valore della variabile <b>$premuto</b> al timestamp della pressione, contemporaneamente viene avviato anche lo script <b>enablewifiguest</b> e <b>resetta</b> che vedremo più avanti. 
  Se entro 3 secondi viene ripremuto il pulsante, allora questo viene interpretato come doppio click, la variabile globale <b>$RunAll</b> viene impostata a 0 e in questo modo viene abbattuto il Wifi e il sistema viene resettato.
  Se si fanno passare più di 3 secondi, il valore della variabile <b>pulsante</b> viene azzerato pertanto non sarà possibile catturare il secondo click, di fatto la seconda pressione del tasto non cambia nulla.
</li>
<li>
  <b>resetta</b><br>
  Questo script semplicemente cattura il timestamp al momento della pressione del tasto e resta in attesa per 3 secondi senza fare nulla, alla fine dei 3 secondi azzera la variabile <b>$premuto</b> così che la seconda pressione del tasto non venga riconosciuta.
</li>
<li>
  <b>enablewifiguest</b><br>
  E' lo script che abilita fisicamente l'interfaccia Wifi secondo il valore contenuto nella variabile "interfaccia" dichiarata all'inizio del codice.
  Questo codice viene lanciato dallo script "pulsante" e rimane in esecuzione in loop fino all'azzeramento del tempo impostato (settato nella variabile "tempo") oppure finchè la variabile globale "$RunAll" rimane a 1.
  Viene anche gestito il lampeggio di avviso che si attiva prima dell'abbattimento del segnale wifi (variabile "$AlertDown")
  
</li>
