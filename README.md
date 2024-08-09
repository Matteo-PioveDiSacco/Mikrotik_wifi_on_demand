# Mikrotik_wifi_on_demand
Tutti gli script Mikrotik necessari ad attivare il Wifi di un Access Point Mikrotik mediante pulsante esterno che si illuminerà grazie all'energia ricavata da una porta POE OUT disponibile sullo stesso dispositivo.

1. [Introduzione](#Introduzione)
2. [Scopo del progetto](#Scopo_del_progetto)
3. [Come usare il Pulsante](#Come_usare_il_Pulsante)
4. [I Files](#I_Files)
   4.1 [_ModeButtonScript.rsc](#_ModeButtonScript.rsc)
   4.2 [_ActivateWLAN.rsc](#_ActivateWLAN.rsc)
   4.3 [_DeactivateWLAN.rsc](#_DeactivateWLAN.rsc)
   4.4 [_Predisattivo.rsc](#_Predisattivo.rsc)
   4.5 [_SetGlobalVariables.rsc](#_SetGlobalVariables.rsc)
   4.6 [_SetGlobalVariables.rsc](#_SetGlobalVariables.rsc)
   4.7 [_Init.rsc](#_Init.rsc)
5. [Quindi, in breve](#Quindi_in_breve)
6. [Altre Considerazioni](#Altre_Considerazioni)
   


## Introduzione <a name="introduzione"></a>
La soluzione proposta in questo branch è stata elaborata dall'AI ChatGPT e poi raffinata e corretta da me.
Rispetto alla versione main, questa risulta più comprensibile nel codice e quindi più personalizzabile, tuttavia necessita di più files e l'attivazione del dispositivo avviene dopo 1 secondi dalla pressione del tasto, questo potrebbe portare ad involontarie doppie pressioni che quindi disattiverebbero il funzionamento creando in questo modo delle anomalie.
Tuttavia, vista la fluidità di organizzazione del codice, viene premiato questo branch che viene adottato e messo in produzione.
## Scopo del progetto <a name="Scopo_del_progetto"></a>
La funzione che si vuole ottenere è avere la possibilità di attivare il Wifi di un dispositivo Mikrotik con caratteristiche compatibili (ovvero deve avere il tasto *MODE* disponibile) in una modalità **ON-DEMAND**, ovvero attivo solo quando si preme il tasto *MODE* il quale, mediante una modifica hardware spiegata nel video di Youtube all'indirizzo https://youtu.be/XibX0iqkqoo , può anche essere messo esternamente collegando in parallelo un tasto luminoso che si illumina quando il segnale Wifi è operativo e si spegne quando il tempo a disposizione è terminato. La luminosità del tasto viene ricavata dall'energia di una porta *POE-OUT* che deve essere presente nel dispositivo.

## Come usare il Pulsante <a name="Come_usare_il_Pulsante"></a>
Abbiamo detto che l'attivazione del Wifi avviene premendo il pulsante (che sia quello embedded o quello esterno luminoso aggiunto), tuttavia sono disponibili alcune combinazioni di pressione che producono diverse azioni:
- Quando il tasto viene premuto **una sola volta** si attiva il Wifi e il countdown inizia fino alla fine del tempo a disposizione quando il segnale wifi sarà abbattuto e la luce del pulsante si spegnerà.
- Se si preme il tasto **una sola volta** mentre il Wifi **è attivo** non succederà nulla e la pressione viene ignorata.
- Se si preme il tasto **due volte consecutivamente** mentre il servizio **è attivo** allora il segnale verrà subito abbattuto e il pulsante si spegnerà.
- Se viene premuto il pulsante **una sola volta** mentre si è nel periodo del **pre abbattimento** (cioè quando la luce del pulsante lampeggia), il countdown verrà ripristinato e si ricomincerà nuovamente senza che il segnale Wifi venga spento.

## I Files <a name="I_Files"></a>
I files contengono il codice da copiare ed incollare in una finestra terminale di RouterOS, oppure possono essere trasferiti nella memoria del dispositivo e poi registrati uno ad uno con il comando `/import` (consigliato), in questo modo gli script vengono creati automaticamente.
- Esempio:<br>
    `/import _ModeButtonScript.rsc; /import _ActivateWLAN.rsc; /import _DeactivateWLAN.rsc ... `

  
> [:bulb: Consiglio]
> Se avete scaricato il file ZIP del progetto mediante il tasto `Code` -> `Clone` o dalla pagina delle release, è possibile accelerare il processo di importazione creando un unico file *\.rsc* contenente tutti gli script del progetto.<br>
> Aprire una shell di DOS nella cartella dove avete estratto il file ZIP (usando `shift`->`tasto destro del mouse`->`Apri finestra shell qui`) e digitare il seguente comando:<br>
> `type _*.rsc >> unico.rsc`<br>
> Verrà creato il file chiamato `unico.rsc` che conterrà tutti gli altri script, sarà quindi sufficiente trasferire nell'Access Point solo questo e importarlo nel sistema con il comando:<br>
> `/import unico.rsc`

Vediamoli uno ad uno:
- **_ModeButtonScript.rsc** <a name="_ModeButtonScript.rsc"></a><br>
  Questo è lo script principale che viene messo in esecuzione dopo la pressione del tasto *MODE* o del pulsante esterno. Al suo interno è presente un semplice algoritmo che riconosce quante volte viene premuto il tasto; se il tasto viene premuto **una sola volta** entro un secondo, allora viene catturato l'evento di singola pressione e questo attiva lo script `ActivateWLAN` che a sua volta attiva il Wifi e illumina il pulsante.
  Se invece viene premuto **due volte** entro un secondo, allora viene catturato l'evento di doppia pressione che avvia lo script `DeactivateWLAN` con conseguente abbattimento immediato del segnale Wifi e spegnimento del tasto.
- **_ActivateWLAN.rsc** <a name="_ActivateWLAN.rsc"></a><br>
  Questo script accende il sistema Wifi del dispositivo e forza l'uscita POE a **on** sulla porta predestinata. La configurazione delle porte avviene mediante impostazione di variabili globali come spiegato nello script `SetGlobalVariables.rsc`.
  Viene anche istanziata la fase di pre abbattimento del segnale Wifi che fa lampeggiare il pulsante luminoso all'approciarsi del termine del tempo a disposizione.
- **_DeactivateWLAN.rsc** <a name="_DeactivateWLAN.rsc"></a><br>
  Questo script abbatte il segnale Wifi, interrompe il conteggio e spegne l'interfaccia POE per disattivare la luminosità del pulsante esterno. Viene richiamato o quando il tempo a disposizione è esaurito, oppure quando viene fatto un doppio click sul pulsante.
- **_Predisattivo.rsc** <a name="_Predisattivo.rsc"></a><br>
  Questo è il codice che serve per far lampeggiare il pulsante quando manca poco al termine del tempo a disposizione. Lo script viene fatto partire direttamente dallo *scheduler* di RouterOS "n" secondi o minuti prima della conclusione del tempo.
  Questo script si conclude lanciando lo script `DeactivateWLAN` che abbatte il segnale Wifi e spegne tutto come descritto precedentemente.
- **_SetGlobalVariables.rsc** <a name="_SetGlobalVariables.rsc"></a><br>
  Questo è il codice che serve per impostare le variabili globali ad un valore di default e deve essere considerato come lo *Script di Configurazione* dell'intera procedura. In esso sono raccolte le variabili che determinano i nomi delle porte Wifi e POE, il tempo di funzionamento del segnale Wifi e il tempo di pre abbattimento. Vediamole tutte:<br>
  `IfPoe` -> Nome dell'interfaccia che fornisce l'energia POE<br>
  `activationTime` -> Tempo che il segnale Wifi rimane attivo prima di essere abbatturo<br>
  `predisactivation` -> Quanto tempo prima dell'abbattimento del segnale Wifi il pulsante deve iniziare a lampeggiare<br>
  `wlaninterfaceName` -> Nome dell'interfaccia che fornisce il segnale Wifi<br>
  
  >:warning: **IMPORTANTE!**
  > Dopo aver importato tutti gli script nel sistema, se non si prevede di riavviare il dispositivo, è necessario eseguire manualmente almeno una volta lo script `SetGlobalVariables.rsc` così da settare correttamente le variabili globali, oppure, riavviando il sistema, lo script viene avviato automaticamente. Questo script viene attivato ad ogni reboot del sistema.<br>
  
- **_Init.rsc** <a name="_Init.rsc"></a><br>
  Questo file non è uno script ma una raccolta di comandi che imposta l'azione di default del tasto *MODE*, e schedula il settaggio delle variabili di default ad ogni riavvio del dispositivo, può essere considerato l'ultimo comando da dare per concludere la programmazione del sistema. Dopo averlo lanciato una sola volta non è necessario farlo più, nemmeno se si riavvia il dispositivo o si esegue un aggiornamento del firmware.

## Quindi, in breve <a name="Quindi_in_breve"></a>
Se avete trasferito i singoli files:
  1. Importare tutti gli script.
  2. Lanciare lo script `_Init.rsc`.
  3. Eseguire un reboot.

Se avete trasferito un unico file *rsc*:
  1. Importare il file *rsc*
  2. Eseguire un reboot.

# Altre Considerazioni
Alcuni particolari non sono stati menzionati nel video di Youtube per non dilungare ulteriormente i filmati, tuttavia ci sono alcune cose da sapere per fare in modo che il progetto funzioni a meraviglia.

1. [Luce fantasma nel pulsante](#lucefantasma)




## Luce fantasma nel pulsante <a name="lucefantasma"></a>
Purtroppo, prendere la tensione dall'uscita POE del Mikrotik introduce uno scomodo contrattempo che riguarda la tensione a vuoto della porta POE che non è a 0 volt.
Questa caratteristica infatti fa si che il LED del pulsante rimanga leggermente illuminato anche se la porta del dispositivo è settata logicamente ad *Off*, tuttavia questa anomalia si può facilmente correggere ma sono necessari alcuni componenti elettronici discreti.
La soluzione al problema è inserire un trigger in serie al pulsante, questo dispositivo consente di mantenere a 0 la corrente in uscita fino al raggiungimento di una determinata soglia in entrata, in questo modo viene garantito che solo quando l'access point porta il segnale POE ad *On*, il LED del pulsante viene pienamente alimentato e quindi illuminato. 
Il trigger si può realizzare in due modi, entrambi semplici ed economici:
- [1](#lm311) Mediante circuito integrato LM 311 [DataSheet](https://www.ti.com/lit/ds/symlink/lm311.pdf), [Acquisto](https://amzn.eu/d/3Qrb7ls)
- [2](#2n2222) Mediante transistor BJT NPN 2N2222 [DataSheet](https://pdf1.alldatasheetit.com/datasheet-pdf/view/21675/STMICROELECTRONICS/2N2222.html), [Acquisto](https://amzn.eu/d/9IYCCg6)

### Soluzione con circuito integrato LM311 <a name="lm311"></a>

### Soluzione con transistor 2N2222 <a name="2n2222"></a>
