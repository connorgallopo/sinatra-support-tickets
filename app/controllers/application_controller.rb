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
    redirect to '/support_tickets' if logged_in?
    erb :'/users/login'
  end

  get '/users/new' do
    redirect to '/support_tickets' if logged_in?
    erb :'/users/new_user'
  end

  get '/support_tickets' do
    redirect to '/login' if !logged_in?
    erb :'/tickets/tickets'
  end

  get '/support_tickets/new' do
    erb :'/tickets/new_ticket'
  end

  post '/users/new' do
    @user = User.create(params)
    session[:user_id] = @user.id
    redirect to '/support_tickets'
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end
end
