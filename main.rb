require 'rubygems'
require 'sinatra'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'asdfqwertyxyz' 

get '/' do
  redirect '/name'
end

get '/restart' do
  session.clear
  redirect '/name'
end

get '/name' do
  if session[:player_name]
    'Welcome Back ' + session[:player_name] + '!'
  else
    erb :"/new_game/set_name"
  end
end

get '/money' do
  erb :"/new_game/set_money"
end

post '/money' do
  session[:player_name] = params[:player_name]
  redirect '/money'
end

get '/bet' do
  erb :"/game/bet"
end

post '/bet' do
  session[:player_money] = params[:player_money]
  redirect '/bet'
end

post '/initial_deal' do
  session[:player_bet] = params[:player_bet]
  session[:player_hand] = []
  session[:dealer_hand] = []
  redirect '/players_turn'
end

get '/players_turn' do
  erb :'/game/players_turn'
end

post '/player_hit' do
  session[:player_hand] << session[:deck].pop
  redirect '/players_turn' 
end

post '/player_stay' do

end