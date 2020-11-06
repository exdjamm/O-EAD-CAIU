# Dentro de String faça " #{nome_var ou qualquer outro valor} 
require 'twitter'
require 'net/http'

# Class so pq sim
# Na verdade pra fazer mais sentido na hora de implementar

class EAD
	def initialize
		@uri = URI("https://ead.ifms.edu.br")
	end

	def is_on?

		response = Net::HTTP.get_response(@uri)

		if response.is_a?(Net::HTTPSuccess)
			return true
		else
			return false
		end

	end
end 

# CONSTANTES
MINUTES = 60
TIME_WAIT = 5*MINUTES

# Define the 'vars'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end

ead = EAD.new

previous_state = true

# Funções 

def what_is_the_message?(previous_state, actual_state)
	if previous_state and actual_state
		return "Continua online\nDa pra continuar fazendo atividade :("

	elsif (not previous_state) and actual_state
		return "O EAD voltou\n\nNão sei se isso é bom ou ruim"
	
	elsif previous_state and (not actual_state)
		return "O EAD CAIU!"

	elsif (not previous_state) and (not actual_state)
		return "Continua caido.\nVolte a tomar o terere tranquilamente"
	end
end

# Loop

while true
	actual_state = ead.is_on?

	the_message = what_is_the_message? previous_state , actual_state
	client.update( the_message )

	# Espera por 5 minutos antes de verificar novamente
	sleep TIME_WAIT

	previous_state = actual_state
end