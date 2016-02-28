# IATAreportbot v0.1
# Copyright (c) 2016, Italian Administrators Telegram Alliance
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are those
# of the authors and should not be interpreted as representing official policies, 
# either expressed or implied, of the project itself.

require 'telegram_bot'
require 'yaml'

# Configuration
bot = TelegramBot.new(token: 'INSERIRE IL TOKEN QUI')
channellink = "INSERIRE IL LINK AL CANALE NEWS QUI"
# End configuration

channel = YAML.load(File.read('channel.conf')) rescue nil
admins = YAML.load(File.read('admins.conf')) rescue nil
status = Hash.new

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)
  if status[message.from.id] == nil then
	status[message.from.id] = Hash.new
  end
  
  if message.from.username == nil then
    status[message.from.id]["username"] = message.from.first_name + " " + message.from.last_name + " [" + message.from.id.to_s + "]" 
  else
    status[message.from.id]["username"] = message.from.username + " [" + message.from.id.to_s + "]"
  end
  
  message.reply do |reply|
    case command
	when /\/start/i
	  reply.text = %{Benvenuto, i comandi che puoi usare con questo bot sono:
/report - Segnala l'abuso di una persona/bot/chat
/iscriviti - Proponi il tuo gruppo per essere incluso nello IATA
/canale - Ottieni il link con le ultime news}

	when /\/addadmin/i
	  if admins == nil then
	    admins = Hash.new
		admins[message.from.id] = true
		reply.text = "Lista degli admin inizializzata. Sei stato aggiunto come primo admin."
		File.open('admins.conf', 'w') {|f| f.write(YAML.dump(admins))}
	  else
	    begin
	      if admins[message.from.id] == true then
		    status[message.from.id]["addadmin"] = true
		    reply.text = "Inserisci l'ID dell'amministratore da aggiungere."
		  else
		    reply.text = "Non sei autorizzato ad usare questo comando."
		  end
		rescue
		  reply.text = "La struttura degli admin non è ancora stata inizializzata."
		end
	  end
	  
	when /\/setchan/i
	  begin
	    if admins[message.from.id] = true then
	      File.open('channel.conf', 'w') {|f| f.write(YAML.dump(message.chat))}
	      channel = message.chat
	      reply.text = "Fatto."
	    else
	      reply.text = "Non sei autorizzato ad usare questo comando."
	    end
	  rescue
		reply.text = "La struttura degli admin non è ancora stata inizializzata."
	  end
	  
    when /\/report/i
	  if status[message.from.id]["report"] == true or
	     status[message.from.id]["reportname"] == true or
		 status[message.from.id]["subscribe"] == true or
	     status[message.from.id]["subscribelink"] == true or
		 status[message.from.id]["subscribeadm"] == true or
		 status[message.from.id]["subscribeval"] == true or
		 status[message.from.id]["subscribereason"] == true then
		 
	    reply.text = "C'è un'altra tua segnalazione in corso. Completa l'altra prima."
	  else
        reply.text = %{Ciao, #{message.from.first_name}!
Invia l'username, il nome o l'ID della persona o del gruppo che vuoi segnalare}
        status[message.from.id]["report"] = true
		
	  end
	  
	when /\/canale/i
	  reply.text = %{Questo è il canale con le ultime nostre news:
#{channellink}}

	when /\/iscriviti/i
	  if status[message.from.id]["subscribe"] == true or
	     status[message.from.id]["subscribelink"] == true or
		 status[message.from.id]["subscribeadm"] == true or
		 status[message.from.id]["subscribeval"] == true or
		 status[message.from.id]["subscribereason"] == true or
		 status[message.from.id]["report"] == true or
	     status[message.from.id]["reportname"] == true then
		 
	    reply.text = "C'è un'altra tua segnalazione in corso. Completa l'altra prima."
	  else
		  reply.text = %{Ciao, #{message.from.first_name}!
Invia il nome del gruppo che vuoi proporre all'attenzione dello IATA.}
		  status[message.from.id]["subscribe"] = true
	  end
	  
	when /\//i
	  reply.text = "Comando sconosciuto."
	  
    else
	  ## ADDADMIN ##
	  if status[message.from.id]["addadmin"] == true then
	    begin
	      admins[message.text.to_i] = true
		  File.open('admins.conf', 'w') {|f| f.write(YAML.dump(admins))}
		  reply.text = "Aggiunto l'id #{message.text} agli amministratori."
		  status[message.from.id]["addadmin"] = false
		rescue 
		  reply.text = "L'ID non è valido! Riprova ad inviarlo."
		end
	  end
	  ## END ADDADMIN ##
	
	  ## REPORT ##
	  if status[message.from.id]["reportname"] == true then
	    status[message.from.id]["reportedreason"] = message.text
		status[message.from.id]["reportname"] = false
		
		reply.text = "Abbiamo preso in carico la tua segnalazione, un admin provvederà a verificarla manualmente."
		bot.send_message(TelegramBot::OutMessage.new(chat: channel, text: %{Nome: @#{status[message.from.id]["username"]}
Segnalato: #{status[message.from.id]["reportedname"]}
Motivazione: #{status[message.from.id]["reportedreason"]}}))

		status[message.from.id]["report"] = false
	  end
	  
	  if status[message.from.id]["report"] == true then
	    status[message.from.id]["reportedname"] = message.text
		status[message.from.id]["report"] = false
		status[message.from.id]["reportname"] = true
		
		reply.text = "Esponi il motivo della segnalazione."
	  end
	  ## END REPORT ## 
	  
	  ## SUBSCRIPTION ##
	  if status[message.from.id]["subscribereason"] == true then
	    status[message.from.id]["subscribedreason"] = message.text
		status[message.from.id]["subscribereason"] = false
		reply.text = "Abbiamo preso in carico la tua richiesta, un admin provvederà a verificarla manualmente."
		
		bot.send_message(TelegramBot::OutMessage.new(chat: channel, text: %{Nome: @#{status[message.from.id]["username"]}
Nome del gruppo proposto: #{status[message.from.id]["subscribedname"]}
Link: #{status[message.from.id]["subscribedlink"]}
Admin aggiuntivi: #{status[message.from.id]["subscribedadm"]}
Autovalutazione: #{status[message.from.id]["subscribedval"]}
Descrizione: #{status[message.from.id]["subscribedreason"]}}))

		status[message.from.id]["subscribe"] = false
	  end
	  
	  if status[message.from.id]["subscribeval"] == true then
	    status[message.from.id]["subscribedval"] = message.text
		status[message.from.id]["subscribeval"] = false
		status[message.from.id]["subscribereason"] = true
		
		reply.text = "Descrivi in poche parole il tuo gruppo."
	  end
	  
	  if status[message.from.id]["subscribeadm"] == true then
	    status[message.from.id]["subscribedadm"] = message.text
		status[message.from.id]["subscribeadm"] = false
		status[message.from.id]["subscribeval"] = true
		
		reply.text = "Per favore, fornisci un autovalutazione da 1 a 10 riguardo libertà (L=) e sicurezza (S=)."
	  end
	  
	  if status[message.from.id]["subscribelink"] == true then
	    status[message.from.id]["subscribedlink"] = message.text
		status[message.from.id]["subscribelink"] = false
		status[message.from.id]["subscribeadm"] = true
		
		reply.text = "Per favore, elenca eventuali altri admin (ND se non ce ne sono altri oltre a te)."
	  end
	  
	  if status[message.from.id]["subscribe"] == true then
	    status[message.from.id]["subscribedname"] = message.text
		status[message.from.id]["subscribe"] = false
		status[message.from.id]["subscribelink"] = true
		
		reply.text = "Per favore, fornisci un link al gruppo che vuoi proporre."
	  end
	  ## END SUBSCRIPTION ##
	  
    end
	
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
