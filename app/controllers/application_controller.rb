require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, 'secret'
  end

  get '/' do
    erb :index
  end

  get '/login' do
    binding.pry
    redirect to '/support_tickets' if logged_in?
    erb :'/users/login'
  end

  get '/users/new' do
    redirect to '/support_tickets' if logged_in?
    erb :'/users/new_user'
  end

  get '/support_tickets' do
    redirect to '/login' if !logged_in?
    @user = current_user
    erb :'/tickets/tickets'
  end

  get '/support_tickets/new' do
    erb :'/tickets/new_ticket'
  end

  post '/users/new' do
    @user = User.create(params)
    @user.role = 'user'
    @user.save
    session[:user_id] = @user.id
    redirect to '/support_tickets'
  end

  post '/login' do
    @user = User.find_by(email: params['email'])
    if @user && @user.authenticate(params['password'])
      session[:user_id] = @user.id
      redirect '/support_tickets'
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect to '/login'
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end
end
