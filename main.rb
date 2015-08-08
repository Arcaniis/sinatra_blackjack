require 'rubygems'
require 'sinatra'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'asdfqwertyxyz' 

helpers do
  VALUE_TABLE = {'|2C|' => 2, '|3C|' => 3, '|4C|' => 4, '|5C|' => 5, '|6C|' => 6,
                '|7C|' => 7, '|8C|' => 8, '|9C|' => 9, '|10C|' => 10,
                '|JC|' => 10, '|QC|' => 10, '|KC|' => 10, '|AC|' => 11, '|2D|' => 2, 
                '|3D|' => 3, '|4D|' => 4, '|5D|' => 5, '|6D|' => 6, '|7D|' => 7, 
                '|8D|' => 8, '|9D|' => 9, '|10D|' => 10, '|JD|' => 10, '|QD|' => 10, 
                '|KD|' => 10, '|AD|' => 11, '|2S|' => 2, '|3S|' => 3, '|4S|' => 4, 
                '|5S|' => 5, '|6S|' => 6, '|7S|' => 7, '|8S|' => 8, '|9S|' => 9, 
                '|10S|' => 10, '|JS|' => 10, '|QS|' => 10, '|KS|' => 10, 
                '|AS|' => 11, '|2H|' => 2, '|3H|' => 3, '|4H|' => 4, '|5H|' => 5, 
                '|6H|' => 6, '|7H|' => 7, '|8H|' => 8, '|9H|' => 9, '|10H|' => 10, 
                '|JH|' => 10, '|QH|' => 10, '|KH|' => 10, '|AH|' => 11}

  def deal(hand)
    session[hand] << session[:deck].pop
  end

  def bust?(hand_value)
    session[hand_value] > 21
  end

  def hand_value(hand)
    value = 0
    session[hand].each do |card|
      value += VALUE_TABLE[card]
    end
    if value > 21
      session[hand].each do |card|
        if card =~ /\|A.\|/
          value -= 10
          if value < 22
            break
          end  
        end
      end
    end
    value
  end

  def blackjack?(value)
    session[value] == 21
  end

end

get '/' do
  if session[:player_name]
    'Welcome Back ' + session[:player_name] + '!'
  else
    redirect '/name'
  end
end

get '/restart' do
  session.clear
  redirect '/name'
end

get '/name' do
  deck = ["|2","|3","|4","|5","|6","|7","|8","|9","|10","|J","|Q","|K","|A"]\
            .product(["H|", "S|", "D|", "C|"]).map {|x| x.join}
  shoe = deck * 6
  session[:deck] = shoe.shuffle!
  erb :"/new_game/set_name"
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
  2.times do
    deal(:dealer_hand)
    deal(:player_hand)
  end
  session[:player_value] = hand_value(:player_hand)
  session[:dealer_value] = hand_value(:dealer_hand)
  redirect '/players_turn'
end

get '/players_turn' do
  if blackjack?(:player_value)
    redirect '/results'
  else
    erb :'/game/players_turn'
  end
end

post '/player_hit' do
  deal(:player_hand)
  session[:player_value] = hand_value(:player_hand)
  if bust?(:player_value)
    redirect '/results'
  else
    redirect '/players_turn'
  end
end

post '/player_stay' do
  redirect '/dealers_turn'
end

get '/dealers_turn' do
  erb :'/game/dealers_turn'
end

post '/dealers_turn' do
  if session[:dealer_value] < 17
    deal(:dealer_hand)
    session[:dealer_value] = hand_value(:dealer_hand)
    redirect '/dealers_turn'
  else
    redirect '/results'
  end
end

get '/results' do
  erb :'/game/results'
end