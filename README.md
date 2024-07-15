# Mikrotik_wifi_on_demand
Tutti gli script Mikrotik necessari ad attivare il Wifi di un Access Point Mikrotik mediante pulsante esterno che si illuminerà grazie all'energia ricavata da una porta POE OUT disponibile sullo stesso dispositivo.

La soluzione proposta in questo branch è stata elaborata dall'AI ChatGPT e poi raffinata e corretta da me.
Rispetto alla versione main, questa risulta più comprensibile nel codice e quindi più personalizzabile, tuttavia necessita di più files e l'attivazione del dispositivo avviene dopo 1 secondi dalla pressione del tasto, questo potrebbe portare ad involontarie doppie pressioni che quindi disattiverebbero il funzionamento creando in questo modo delle anomalie.

Tuttavia, vista la fluidità di organizzazione del codice, viene premiato questo branch che viene adottato e messo in produzione.

La funzione che si vuole ottenere è avere la possibilità di attivare il Wifi di un dispositivo Mikrotik con caratteristiche compatibili (ovvero deve avere il tasto <b>MODE</b> disponibile) in una modalità <b>ON-DEMAND</b>, ovvero attivo solo quando si preme il tasto che, mediante una modifica hardware spiegata nel video di Youtube all'indirizzo..... può anche essere messo esternamente collegando in parallelo un tasto luminoso che si illumina quando il segnale Wifi è operativo e si spegne quando il tempo a disposizione è terminato. La luminosità del tasto viene ricavata dall'energia di una porta <b>POE-OUT</b> che deve essere presente nel dispositivo.<br>
<br>
<b>COME USARE IL PULSANTE</b>
<li> Quando il tasto viene premuto una sola volta si attiva il Wifi e il countdown inizia fino alla fine del tempo a disposizione quando il segnale wifi sarà abbattuto e la luce del pulsante si spegnerà.
</li>
<li> Se si preme il tasto una sola volta mentre il servizio è ancora attivo non succederà nulla e la pressione viene ignorata.
</li>
<li> Se si preme il tasto due volte consecutivamente mentre il servizio è attivo allora il segnale verrà subito abbattuto e il pulsante si spegnerà.
</li>
<li> Se viene premuto il pulsante una sola volta mentre si è nel periodo del Pre abbattimento (cioè quando la luce del pulsante lampeggia), il countdown verrà ripristinato e si ricomincerà nuovamente senza che il segnale wifi venga spento.
</li><br>
<br>
<b>I FILES</b><br>
I files contengono il codice da copiare ed incollare in una finestra terminale di RouterOS per creare gli script necessari. Vediamoli uno ad uno:
<li>
  <b>ModeButtonScript.rsc</b><br>
  Questo è lo script principale che viene messo in esecuzione dopo la pressione del tasto MODE o del pulsante esterno. Al suo interno è presente un semplice algoritmo che riconosce quante volte viene premuto il tasto; se il tasto viene premuto <b>una sola volta</b> entro un secondo, allora viene catturato l'evento di singola pressione e questo attiva lo script <b>ActivateWLAN</b> che a sua volta attiva il Wifi e illumina il pulsante.
  Se invece viene premuto <b>due volte</b> entro un secondo, allora viene catturato l'evento di doppia pressione che corrisponde all'abbattimento immediato del segnale wifi con spegnimento del tasto.
</li>
<li>
  <b>ActivateWLAN.rsc</b><br>
  Questo script accende il sistema Wifi del dispositivo e forza l'uscita POE a on sulla porta predestinata. La configurazione delle porte avviene mediante impostazione di variabili globali come spiegato nello script <b>SetGlobalVariables.rsc</b>.
  Viene anche gestito l'avvio della fase di pre abbattimento del segnale che fa lampeggiare il pulsante luminoso all'approciarsi del termine del tempo a disposizione.
</li>
<li>
  <b>DeactivateWLAN.rsc</b><br>
  Questo script abbatte il segnale Wifi, interrompe il conteggio e spegne l'interfaccia POE per disattivare la luminosità del pulsante. Viene richiamato o quando il tempo a disposizione è esaurito, oppure quando viene fatto un doppio click sul pulsante.  
</li>
<li>
  <b>Predisattivo.rsc</b><br>
  Questo è il codice che serve per far lampeggiare il pulsante quando ormai si è giunti al termine del tempo a disposizione. Lo script viene fatto partire direttamente dallo <b>scheduler</b> "n" secondi o minuti prima della conclusione del tempo.
  Al termine del tempo viene richiamato lo script <b>DeactivateWLAN</b> che spegne tutto.
</li>
<li>
  <b>SetGlobalVariables.rsc</b><br>
  Questo è il codice che serve per impostare le variabili globali ad un valore di default e deve essere considerato come lo <b>Script di Configurazione</b> dell'intera procedura. In esso sono raccolte le variabili che determinano i nomi delle porte Wifi e POE, il tempo di funzionamento della Wifi e il tempo di Pre abbattimento.<br>
  <b>IfPoe</b> -> Nome dell'interfaccia che fornisce l'energia POE<br>
  <b>activationTime</b> -> Tempo che il segnale Wifi rimane attivo prima di essere abbatturo<br>
  <b>predisactivation</b> -> Quanto tempo prima dell'abbattimento del segnale Wifi il pulsante deve iniziare a lampeggiare<br>
  <b>wlaninterfaceName</b> -> Nome dell'interfaccia che fornisce il segnale Wifi<br>
  
  <b>IMPORTANTE</b><br>
  Se non si prevede di riavviare il dispositivo dopo la programmazione è necessario eseguire manualmente questo script dopo aver importato tutti gli altri script nel sistema, in caso contrario verrà lanciato in automatico ad ogni reboot del sistema.
</li>
<li>
  <b>InitGlobalVariables.rsc</b><br>
  Questo è il codice che <b>DEVE</b> essere eseguito al termine della programmazione <b>PRIMA</b> di effettuare un reboot del sistema.
  In questo modo viene automatizzata la creazione delle variabili globali e non sarà necessario riapplicare manualmente nient'altro dopo i successivi riavvii e aggiornamenti del sistema.
</li><br>

Quindi, in breve:<br>
<li>
  1. Importare tutti gli script
</li>
<li>
  2. Lanciare lo script <b>InitGlobalVariables.rsc</b>
</li>
<li>
  3. Eseguire un reboot
</li>
