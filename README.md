# Mikrotik_wifi_on_demand
Tutti gli script Mikrotik necessari ad attivare il Wifi di un Access Point Mikrotik mediante pulsante esterno che si illuminerà grazie all'energia ricavata da una porta POE OUT disponibile sullo stesso dispositivo.

## Introduzione
La soluzione proposta in questo branch è stata elaborata dall'AI ChatGPT e poi raffinata e corretta da me.
Rispetto alla versione main, questa risulta più comprensibile nel codice e quindi più personalizzabile, tuttavia necessita di più files e l'attivazione del dispositivo avviene dopo 1 secondi dalla pressione del tasto, questo potrebbe portare ad involontarie doppie pressioni che quindi disattiverebbero il funzionamento creando in questo modo delle anomalie.
Tuttavia, vista la fluidità di organizzazione del codice, viene premiato questo branch che viene adottato e messo in produzione.
## Scopo del progetto
La funzione che si vuole ottenere è avere la possibilità di attivare il Wifi di un dispositivo Mikrotik con caratteristiche compatibili (ovvero deve avere il tasto *MODE* disponibile) in una modalità **ON-DEMAND**, ovvero attivo solo quando si preme il tasto *MODE* il quale, mediante una modifica hardware spiegata nel video di Youtube all'indirizzo..... può anche essere messo esternamente collegando in parallelo un tasto luminoso che si illumina quando il segnale Wifi è operativo e si spegne quando il tempo a disposizione è terminato. La luminosità del tasto viene ricavata dall'energia di una porta *POE-OUT* che deve essere presente nel dispositivo.

## Come usare il Pulsante
Abbiamo detto che l'attivazione del Wifi avviene premendo il pulsante (che sia quello embedded o quello esterno luminoso aggiunto), tuttavia sono disponibili alcune combinazioni di pressione che producono diverse azioni:
- Quando il tasto viene premuto **una sola volta** si attiva il Wifi e il countdown inizia fino alla fine del tempo a disposizione quando il segnale wifi sarà abbattuto e la luce del pulsante si spegnerà.
- Se si preme il tasto **una sola volta** mentre il Wifi **è attivo** non succederà nulla e la pressione viene ignorata.
- Se si preme il tasto **due volte consecutivamente** mentre il servizio **è attivo** allora il segnale verrà subito abbattuto e il pulsante si spegnerà.
- Se viene premuto il pulsante **una sola volta** mentre si è nel periodo del **pre abbattimento** (cioè quando la luce del pulsante lampeggia), il countdown verrà ripristinato e si ricomincerà nuovamente senza che il segnale Wifi venga spento.

## I Files
I files contengono il codice da copiare ed incollare in una finestra terminale di RouterOS, oppure possono essere trasferiti nella memoria del dispositivo e poi registrati uno ad uno con il comando `/import` (consigliato), in questo modo gli script vengono creati automaticamente.
- Esempio:<br>
    `/import ModeButtonScript.rsc; /import ActivateWLAN.rsc; /import DeactivateWLAN.rsc ... `

Vediamoli uno ad uno:
- **ModeButtonScript.rsc**<br>
  Questo è lo script principale che viene messo in esecuzione dopo la pressione del tasto *MODE* o del pulsante esterno. Al suo interno è presente un semplice algoritmo che riconosce quante volte viene premuto il tasto; se il tasto viene premuto **una sola volta** entro un secondo, allora viene catturato l'evento di singola pressione e questo attiva lo script `ActivateWLAN` che a sua volta attiva il Wifi e illumina il pulsante.
  Se invece viene premuto **due volte** entro un secondo, allora viene catturato l'evento di doppia pressione che avvia lo script `DeactivateWLAN` con conseguente abbattimento immediato del segnale Wifi e spegnimento del tasto.
- **ActivateWLAN.rsc**<br>
  Questo script accende il sistema Wifi del dispositivo e forza l'uscita POE a **on** sulla porta predestinata. La configurazione delle porte avviene mediante impostazione di variabili globali come spiegato nello script `SetGlobalVariables.rsc`.
  Viene anche istanziata la fase di pre abbattimento del segnale Wifi che fa lampeggiare il pulsante luminoso all'approciarsi del termine del tempo a disposizione.
- **DeactivateWLAN.rsc**<br>
  Questo script abbatte il segnale Wifi, interrompe il conteggio e spegne l'interfaccia POE per disattivare la luminosità del pulsante esterno. Viene richiamato o quando il tempo a disposizione è esaurito, oppure quando viene fatto un doppio click sul pulsante.
- **Predisattivo.rsc**<br>
  Questo è il codice che serve per far lampeggiare il pulsante quando manca poco al termine del tempo a disposizione. Lo script viene fatto partire direttamente dallo *scheduler* di RouterOS "n" secondi o minuti prima della conclusione del tempo.
  Questo script si conclude lanciando lo script `DeactivateWLAN` che abbatte il segnale Wifi e spegne tutto come descritto precedentemente.
- **SetGlobalVariables.rsc**<br>
  Questo è il codice che serve per impostare le variabili globali ad un valore di default e deve essere considerato come lo *Script di Configurazione* dell'intera procedura. In esso sono raccolte le variabili che determinano i nomi delle porte Wifi e POE, il tempo di funzionamento del segnale Wifi e il tempo di pre abbattimento. Vediamole tutte:<br>
  `IfPoe` -> Nome dell'interfaccia che fornisce l'energia POE<br>
  `activationTime` -> Tempo che il segnale Wifi rimane attivo prima di essere abbatturo<br>
  `predisactivation` -> Quanto tempo prima dell'abbattimento del segnale Wifi il pulsante deve iniziare a lampeggiare<br>
  `wlaninterfaceName` -> Nome dell'interfaccia che fornisce il segnale Wifi<br>
  > [!IMPORTANT]
  > Dopo aver importato tutti gli script nel sistema, se non si prevede di riavviare il dispositivo, è necessario eseguire manualmente almeno una volta lo script `SetGlobalVariables.rsc` così da settare correttamente le variabili globali, oppure, riavviando il sistema, lo script viene avviato automaticamente. Questo script viene attivato ad ogni reboot del sistema.<br>
- **InitGlobalVariables.rsc**<br>
  Questo file non è uno script ma una raccolta di comandi che imposta l'azione di default del tasto *MODE*, e schedula il settaggio delle variabili di default ad ogni riavvio del dispositivo, può essere considerato l'ultimo comando da dare per concludere la programmazione del sistema. Dopo averlo lanciato una sola volta non è necessario farlo più, nemmeno se si riavvia il dispositivo o si esegue un aggiornamento del firmware.

Quindi, in breve:<br>
  1. Importare tutti gli script.
  2. Lanciare lo script `InitGlobalVariables.rsc`.
  3. Eseguire un reboot.
