# PagoPA SOAP

Ruby Wrapper per pagoPA SOAP API basato sulla gemma [Savon](https://github.com/savonrb/savon)

| Project                | PagoPa Soap Ruby |
| ---------------------- | ------------ |
| Gem name               | pagopa-soap |
| License                | [BSD 3](https://github.com/italia/pagopa-soap-ruby/blob/master/LICENSE) |
| Version                | [![Gem Version](https://badge.fury.io/rb/pagopa-soap.svg)](https://badge.fury.io/rb/pagopa-soap) |
| Continuous integration | [![Build Status](https://secure.travis-ci.org/italia/pagopa-soap-ruby.svg?branch=master)](https://travis-ci.org/italia/pagopa-soap-ruby) |
| Test coverage          | [![Coverage Status](https://coveralls.io/repos/github/italia/pagopa-soap-ruby/badge.svg?branch=master)](https://coveralls.io/github/italia/pagopa-soap-ruby?branch=master) |
| Credits                | [Contributors](https://github.com/italia/pagopa-soap-ruby/graphs/contributors) |

## Installazione

All'interno del Gemfile del progetto inserire questa righa:

```ruby
gem 'pagopa-soap'
```

Quindi eseguire il comando:

    $ bundle

In alternativa è possibile installare la gemma globalbmente lanciando il comando:

    $ gem install pagopa-soap

## Utilizzo

TODO: Write usage instructions here
Inizializzare il wrapper e generare le classi dinamiche in base al WSDL:

```ruby
PagoPA::SOAP.build
```

Dopo aver lanciato la `build`, il sistema genera le nuove classi con il namespace PagoPA.
Ecco la lista delle nuove classi disponibili:

```ruby
PagoPA::NodoChiediStatoRpt
PagoPA::NodoChiediListaPendentiRpt
PagoPA::NodoInviaRpt
PagoPA::NodoInviaCarrelloRpt
PagoPA::NodoChiediCopiaRt
PagoPA::NodoChiediInformativaPsp
PagoPA::NodoPaChiediInformativaPa
PagoPA::NodoChiediElencoQuadraturePa
PagoPA::NodoChiediQuadraturaPa
PagoPA::NodoChiediElencoFlussiRendicontazione
PagoPA::NodoChiediFlussoRendicontazione
PagoPA::NodoInviaRichiestaStorno
PagoPA::NodoInviaRispostaRevoca
PagoPA::NodoChiediSceltaWisp
PagoPA::NodoInviaAvvisoDigitale
```

Ogni classe comprende tre sottoclassi per poter costruire la `request`, inoltrarla al sistema tramite il `client` ed ottenere la `response` corrispondente.
Per pagoPA è possibile specificare WSDL, endpoint e namespace in un blocco di configurazioni:

```ruby
# config/initializers/pagopa_soap.rb
# This is your pagoPA Wrapper setting.
PagoPA::SOAP::Configurable.configure do |config|
  config.namespace = "PagoPA"
  config.wsdl_base = "WSDL with webservice specification"
  config.wsdl_notify = "WSDL with webservice for PUSH notification"
  config.endpoint_base = "https://host-nodo-spc/webservices/"
  config.endpoint_notify = "https://host-nodo-spc-push/webservices/"
end
```

## Features
|[PagoPA regulations](httphttps://www.agid.gov.it/sites/default/files/repository_files/specifiche_attuative_nodo_2_1_0.pdf)||
|:---|:---|
|**List:**||
|Parsing del WSDL base|✓|
|Generazione Wrapper SOAP base|✓|
|Gestione IUV||
|Conversione risposta da Base64 ad HASH||
|Cancellation RT||
|Avvisatura digitale||
|Gestione giornale degli eventi||
|Gestione FaultBean SOAP||
|File Transfer Sicuro||
|Creazione nodoSPC testenv||
|Creazione nodoPSP testenv||


## License

The gem is available as open source under the terms of the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

# Specifiche integrazione RUBY per pagoPA

<img src="https://dm2ue6l6q7ly2.cloudfront.net/wp-content/uploads/2018/03/20092024/pagopa1.png"/>

1. [Premessa](#premessa)
2. [Analisi Attuativa](#analisi-attuativa)
3. [Esempi di connessione](#esempi-di-connessione)
4. [Requisiti del sistema EC](#requisiti-del-sistem-ec)
5. [Implementazioni Future](#implementazioni-future)
6. [Ipotesi di integrazione](#ipotesi-di-integrazione)
6.1. [Wrapper API Ruby](#wrapper-api-ruby)
6.2. [Engine Rack](#engine-rack)
7. [Appendice](#appendice)

## Premessa
Secondo le linee guida emesse dall’**Agenzia per l’Italia Digitale** il **NODO dei pagamenti SPC** (pagoPA) vuole essere il sistema centralizzato di controllo e interoperabilità tra la Pubblica Amministrazione ed i Cittadini.

Il sistema comunica tramite **Web Service SOAP** con un Header di autenticazione e si aspetta un canale TLS con certificati x.509 v3 e che l’EC (Ente Creditore) che effettua le chiamate sia inserito in una white list di IP verificati.

Attraverso l’interfaccia **WISP** (Wizard interattivo di scelta dei PSP - Prestatori di Pagamento) viene demandato al sistema pagoPA l’attuazione delle linee guida in merito ai sistemi di pagamento e alla visualizzazione dei costi aggiuntivi degli stessi, richiedendo l’autenticazione tramite SPID al cittadino e quindi unificando l’UX del processo di pagamento.

<img src="https://raw.githubusercontent.com/cantierecreativo/pagoparb/master/diagrams/diagrammi-wisp.jpg" />
*a. Diagramma pagamento con WISP*

Il Nodo SPC inoltre lavora anche come server di chiamata in quanto anche i metodi normali (bollettino postale, bonifico, etc…) sono controllati e gestiti tramite il suo supporto, di conseguenza l’EC che intende collegarsi al sistema deve predisporre un ambiente anche di ricezione di Request SOAP.

<img src="https://raw.githubusercontent.com/cantierecreativo/pagoparb/master/diagrams/diagrammi-psp.jpg" />
*a. Diagramma pagamento da PSP*


## Analisi attuativa

Attualmente un EC ha un sistema proprietario di gestione dati e rendicontazione di conseguenza si possono immaginare due scenari di integrazione:
-   Integrazione tramite Canale di scambio delle informazioni e dei dati che poi dovranno essere gestiti direttamente nel gestionale del singolo EC
-   Integrazione tramite Repository dati e quindi tramite sync da EC e successivamente gestore delle comunicazioni tra Cittadino e Pagamento

Il portale EC deve inoltre fornire al cittadino delle alternative al pagamento digitale tramite QRCode o bollettino postale di nuova generazione come da linee guida contenute nel documento [Avviso Analogico](https://www.agid.gov.it/sites/default/files/repository_files/guidatecnica_avvisoanalogico_v2.1_con_alleg.pdf)

In ultima analisi, visto che si vorrebbe lasciare la massima libertà di scelta del metodo di integrazione più ottimale direttamente agli EC si sono scorporati al massimo tutte le componenti richieste per collegarsi a pagoPA cosi da consentirne l’ utilizzo anche in maniera separata.


## Esempi di connessione

Viene fornito uno [Startup Kit](https://www.agid.gov.it/it/piattaforme/pagopa/linee-guida-documentazione-tecnica) con cui è possibile visualizzare attraverso il software SOAP UI tutte le chiamate possibili effettuabili da un EC o dal Nodo SPC ed eventualmente scaricando i espositori presenti su GitHub si possono avere i WSDL ed XSD delle relative request sia in ingresso che in uscita.

I WebService attualmente disponibili sono:
-   **nodoInviaCarrelloRPT**
-   **nodoInviaAvvisoDigitali**
-   **nodoChiediElencoFlussiRendicontazione**
-   **nodoChiediFlussoRendicontazione**
-   **nodoChiediListaPendentiRPT**
-   **nodoChiediStatoRPT**
-   **nodoInviaRichiestaStorno**
-   **nodoChiediInformativaPSP**
-   **nodoChiediElencoQuadraturePA**
-   **nodoChiediQuadraturaPA**
-   **paaVerificaRPT**
-   **paaAllegaRPT**
-   **paaChiudiNumeroAvviso**
-   **paaChiediAvvisiDigitali**
-   **paaInviaEsitoStorno**

Come supporto sono stati realizzati degli schemi di integrazione che illustrano i funzionamenti principali del sistema che sono visibili nella rispettiva appendice.


## Requisiti del sistema EC

Per poter iniziare ad utilizzare il sistema pagoPA occorre accreditarsi presso lo stesso e condividere un certificato di autenticazione che dovrà poi essere presente negli Header di ogni request in maniera da permettere al portale di verificare l’attendibilità della fonte.

Visti i futuri sviluppi introdotti dall’Agenzia per l’Italia Digitale che vogliono introdurre una sessione permanente tramite il protocollo di autenticazione SPID (SAML 2.0) ogni EC dovrá permettere ai propri utenti (Cittadini) di poter accedere al sistema tramite l’Identità Unica cosi da velocizzare il processo di pagamento implementato tramite WISP.

Tutti i log delle richieste e relative risposte, anche gli errori, dovranno essere archiviati e mantenuti.


## Implementazioni future

Dalle linee guida [File Transfer](http://pagopa-docs-specws.readthedocs.io/it/latest/interazione_EC_Nodo.html#interfacce-per-il-servizio-di-file-transfer-sicuro) si legge come in futuro il sistema di comunicazione tramite WebService SOAP sarà ridotto in merito al nuovo standard di comunicazione dati tramite SFTP cosi che le comunicazioni XML (risposte ai Web Service) siano depositate direttamente in un aree dedicata dell’EC che lo ha richiesto.

In preparazione di questa nuova metodologia di comunicazione il WRAPPER API dovrebbe permettere l’archiviazione della risposta anche in maniera non diretta e prevedere la posizione ed il nome del file da utilizzare per poter estrapolare tutte le informazioni necessarie all’EC.


## Ipotesi di Integrazione

### Wrapper API Ruby

Si tratta di una gemma che dovrebbe semplificare la gestione delle chiamate e relative risposte tra EC e sistema pagoPA.

Il wrapper dovrebbe gestire tutti i possibili messaggi di errore delle chiamate.
Il sistema dovrebbe automatizzare tutto il processo tramite WISP consentendo una configurazione rapida e di minimo impatto al sistema esistente.

Si rimanda al documento [Specifiche Attuative](https://pagopa-docs-specws.readthedocs.io/it/latest/index.html) in cui sono illustrati tutti i webservice dispomnibili e il loro funzionamento.

Per quanto riguarda i messaggi di errore si rimanda invece al documento [Errori webservice](http://pagopa-specifichepagamenti.readthedocs.io/it/latest/_docs/Capitolo10.html)
Per i codici di versamento [Codici versamento, riversamento e rendicontazione](http://pagopa-codici.readthedocs.io/it/latest/)

In sintesi cosa dovrebbe contenere la gemma:
-   Generatore Header autenticato per inizializzare la request
-   Validatore delle request e response SOAP
-   Implementare tutte le request verso pagoPA
-   Implementare la possibilità di creare degli endpoint per le request da pagoPA
-   Generatore di IUV (Identificativo Univoco Versamento)
-   Generatore di QRCode o Barcode

Per la generazione dello IUV devono essere ovviamente inseriti dei parametri di configurazione a livello di sistema in quanto, come da specifiche, deve essere univoco a livello di sistema e deve seguire delle specifiche chiare ().

##### Come dovrebbe funzionare:
Il sistema dovrebbe contenere il WSDL base attraverso il quale poter effettuare tutte le chiamate e avere le specifiche di riferimento per ognuna di esse.

Deve essere presente un file di configurazione e di seguito un esempio dei parametri necessari:
-   BASE_URI_PAGOPA
-   DOMINIO_ID_EC
-   CODICE_EC
-   ENDPOINTS

Il sistema dovrebbe inoltre prevedere la possibilità tramite activerecord, di archiviare in DB le response sia delle varie richieste che di quelle generate automaticamente da pagoPA, cosi da avere un log e consentire anche in un secondo momento di poter prendere i dati ed utilizzarli.

Si pensava inoltre di poter prevedere che il modello sia configurabile in maniera tale da permettere di utilizzare una struttura e codice più adeguati al sistema a cui si aggiunge l’ integrazione.

##### N.B.
Le chiamate verso i WebService devono prevedere uno User-Agent all'interno degli Header di chiamata altrimenti tornano come status code 302.

### Engine Rack

Si tratta di un sistema completo che dovrebbe operare in supporto al sistema attuale integrato tramite WISP permettendo ad un EC di implementare la procedura completa integrandosi direttamente con i vari PSP supportati.

In questo caso il sistema conterrebbe la gemma precedente ed in più avrebbe la gestione centralizzata di tutto il traffico in uscita ed entrata dal relativo EC.

Come da linee guida dovrebbe inoltre contenere delle viste (di cui sarà possibile fare un override) che permettono la stampa a video di tutti i PSP con il relativo costo aggiuntivo e la gestione dei metodi di pagamento con i relativi redirect di completamento della procedura di pagamento.

In questo modo non servirebbe andare a creare tutto il sistema di controller nell’app principale ma la nuova gemma avrebbe tutte le configurazioni al suo interno comprensive di **ENDPOINT** di chiamata da pagoPA e gestione delle tabelle necessarie al suo corretto funzionamento.

Le tabelle necessarie dovrebbero essere:
-   **responses** -> memorizza tutte le chiamate in ingresso
-   **requests** -> memorizza tutte le chiamate in uscita

Inoltre dovrebbe essere possibile indicare al sistema i nomi delle tabelle o dei modelli che gestiscono le pendenze di pagamento e i dati utente cosi da permettere al sistema di prelevare le informazioni necessarie ad effettuare le transazioni.


#### Appendice:

Grafici di revoca dei pagamenti come da linee guida di AgID
<img src="https://raw.githubusercontent.com/cantierecreativo/pagoparb/master/diagrams/diagrammi-revoca.jpg" />
