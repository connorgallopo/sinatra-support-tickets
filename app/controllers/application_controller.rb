require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :'/users/login'
  end

  get '/users/new' do
    erb :'/users/new_user'
  end

  post '/users/new' do

  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end
end
