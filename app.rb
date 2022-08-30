require 'yaml/store'
require 'sinatra'
get '/' do
  @title = 'Welcome to the Suffragist!'
  erb :index
end

post '/cast' do
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['food'] ||= {} 
    #to samo co wyżej: @store[food] = @store[food] || {}
    @store['food'][@vote] ||= 0
    @store['food'][@vote] += 1
  end
  redirect '/results'
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['food'] }
  @votes_days = @store.transaction { @store['days'] }
  erb :results
end

post '/reset' do
 @title = 'Your results are gone'
 @store = YAML::Store.new 'votes.yml'
 @store.transaction do
    @store['food'].clear
 end
 redirect '/results'
end

Choices = {
  'HAM' => 'Hamburger',
  'PIZ' => 'Pizza',
  'CUR' => 'Curry',
  'NOO' => 'Noodles',
}

Days = {
  'MON' => 'Monday',
  'TUE' => 'Tuesday',
  'WED' => 'Wednesday',
  'THU' => 'Thursday',
  'FRI' => 'Friday',
  'SAT' => 'Saturday',
  'SUN' => 'Sunday',
}

get '/days' do
  @title = 'What day is your favourite?'
  erb :days
end

post '/chosen_days' do
  @vote_day  = params['vote_day']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['days'] ||= {} 
    @store['days'][@vote_day] ||= 0 #to days nie jestem pewna czy wiem czego to dotyczy, czy tego pliku yml?
    @store['days'][@vote_day] += 1
  end
  redirect '/results'
end

post '/reset_days' do
  @title = 'Your results are gone'
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
     @store['days'].clear
  end
  redirect '/results'
 end

 post '/reset_all' do
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
     @store['days'].clear
     @store['food'].clear
  end
  redirect '/results'
 end