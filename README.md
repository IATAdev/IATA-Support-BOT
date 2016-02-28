#IATAreportbot
Questo bot è stato creato per ovviare a delle funzioni amministrative all'interno dello IATA.

Questo software è coperto da licenza BSD semplificata (a-là FreeBSD) consultabile dal sorgente del bot stesso: [iatabot.rb](https://github.com/IATAdev/IATAreportbot/blob/master/iatabot.rb).

##A cosa serve?
IATAreportbot è un bot Telegram API scritto in Ruby. Tiene conto delle segnalazioni degli utenti in caso di abuso, richiesta di aggiunta di un gruppo oppure per ottenere il link del canale delle notizie.

* * *

##Comandi previsti
Questa è la lista:

| Comando | Funzione |
|---------|----------|
| /start | Mostra la lista di comandi disponibili all'utente normale. |
| /addadmin | Inizializza la struttura degli amministratori oppure chiede l'ID dell'amministratore da aggiungere. |
| /setchan | Imposta la chat/canale/supergruppo dove riversare le richieste. |
| /report | Inizia una segnalazione. |
| /iscriviti | Inizia una richiesta d'iscrizione di un gruppo. |
| /canale | Restituisce il link del canale d'informazione pubblico (configurabile). |

* * *

##Prerequisiti
**Devi** avere una versione di Ruby recente (testato su 2.1.5).
**Devi** aver installato le gems [telegram_bot](https://github.com/eljojo/telegram_bot) e YAML.

**Prima di eseguirlo:**

> • Imposta il token con quello ricevuto da [BotFather](http://telegram.me/BotFather).
>
> • Esegui il bot, contattalo subito in privato e dai il comando `/setadmin`.
>
> • Configura il gruppo dove riversare le richieste invitando il bot e dando il comando `/setchan`.

Per eseguire il bot, avvia `./iatabot.sh`. Per fermarlo, dai due volte CTRL+C.

Puoi anche eseguirlo con `ruby iatabot.rb`, ma in caso di errore non si riavvierà da solo.

##Sviluppatori
Chiunque può contribuire a questo progetto.

Il bot è sviluppato da [LucentW](https://github.com/LucentW). Puoi conttarlo via [Telegram](https://telegram.me/LucentW), [Twitter](https://twitter.com/lucentw), o su IRC (irc.darkspirit.org, irc.azzurra.org) dove lo troverai con il nick Lucent.

Per altre informazioni, contattare il responsabile del progetto [lollofra](https://github.com/lollofra) via [Telegram](https://telegram.me/lollofra) o [Twitter](https://twitter.com/Lorenzo_Fiocco).