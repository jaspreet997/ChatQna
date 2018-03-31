require 'httparty'
require 'certified'
require 'json'

class ChatsController < ApplicationController

def create

	@chat=Chat.new(chat_params)
	@chat.username='User'
	@chat.save

   

response = HTTParty.post("https://westus.api.cognitive.microsoft.com/qnamaker/v2.0/knowledgebases/67cc71c0-ee37-4345-abe8-f7ec497080a3/generateAnswer", 
    	headers: {"Ocp-Apim-Subscription-Key" => "e0a4be5cf96f44338356d5f117d91ab4","Content-Type"=>"application/json"},body: {"question"=>@chat.message}.to_json)

    puts response.body, response.code, response.message, response.headers.inspect

 puts response.parsed_response['answers'][0]['answer']


    puts response.body, response.code, response.message, response.headers.inspect

	@BotReply=Chat.new
	@BotReply.username='Bot'
	@BotReply.message=response.parsed_response['answers'][0]['answer']
	@BotReply.save
	redirect_to chats_path
end

def index
	#@chats=Chat.all
	@chats=Chat.order(id: :desc)
end

def show
	@chats=Chat.all
	end

	private def chat_params
	#params.require(:chat).permit(:username,:message)
	params.require(:chat).permit(:message)
		
	end
end
