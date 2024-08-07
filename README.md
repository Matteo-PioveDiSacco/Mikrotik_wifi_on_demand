# Mikrotik_wifi_on_demand
Tutti gli script Mikrotik necessari ad attivare il Wifi di un Access Point Mikrotik mediante pulsante esterno

## Introduzione
Questi tre script servono per gestire l'attivazione **ON DEMAND** di un'interfaccia Wifi di un access point Mikrotik tra quelli compatibili
>Nota:
>Necessario RouterOS almeno alla versione 7.14.
>
Per utilizzare questi script è necessario che il dispositivo sia provvisto del tasto "*MODE*", sarà poi necessario modificare l'hardware della scheda madre in modo da collegare un pulsante esterno in parallelo al tasto "*MODE*" così da poter attivare lo script collegato.
Tutta questa parte viene spiegata bene in un video di Youtube all'indirizzo https://youtu.be/XibX0iqkqoo, qui in GitHub vengono solamente mantenuti gli script.

## Script
**Questi file con estensione txt**
  I file che sono presenti qui hanno estensione `TXT` ma in realtà sono dump di script RouterOS, l'uso si deve intendere come copia ed incolla tra il contenuto di questi file e l'interfaccia editor della sessione terminal di RouterOS.

-  **pulsante.txt**
  Questo è lo script che si attiva alla pressione del tasto "*MODE*", è in grado di capire se viene fatto un singolo click o doppio misurando il tempo intercorso tra due pressioni.
  La prima pressione imposta il valore della variabile   **`$premuto`** al timestamp della pressione, contemporaneamente viene avviato anche lo script  **`enablewifiguest`** e  **`resetta`** che vedremo più avanti. 
  Se entro 3 secondi viene ripremuto il pulsante, allora questo viene interpretato come doppio click, la variabile globale **`$RunAll`** viene impostata a 0 e in questo modo viene abbattuto il Wifi e il sistema viene resettato.
  Se si fanno passare più di 3 secondi, il valore della variabile **`pulsante`** viene azzerato pertanto non sarà possibile catturare il secondo click, di fatto la seconda pressione del tasto non cambia nulla.
-  **resetta.txt**
  Questo script semplicemente cattura il timestamp al momento della pressione del tasto e resta in attesa per 3 secondi senza fare nulla, alla fine dei 3 secondi azzera la variabile **`$premuto`** così che la seconda pressione del tasto non venga riconosciuta.
- **enablewifiguest.txt**
  E' lo script che abilita fisicamente l'interfaccia Wifi secondo il valore contenuto nella variabile **`$interfaccia`** dichiarata all'inizio del codice.
  Questo codice viene lanciato dallo script  **`pulsante`** e rimane in esecuzione in loop fino all'azzeramento del tempo impostato (settato nella variabile **`$tempo`**) oppure finchè la variabile globale **`$RunAll`** rimane a 1.
  Viene anche gestito il lampeggio di avviso che si attiva prima dell'abbattimento del segnale wifi (variabile **`$AlertDown`**)
