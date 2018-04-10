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

  get '/tickets/:id/edit' do
    if logged_in?
      @user = current_user
      @ticket = SupportTicket.find_by(id: params[:id])
      if @user.role == "admin" || @ticket.user == current_user
        erb :'/tickets/show'
      end
    else
      redirect to '/login'
    end
  end

  post '/tickets/:id/edit' do
    @ticket = SupportTicket.find_by(id: params[:id])
    @ticket.update(subject: params["subject"], body: params["body"])
    redirect to '/support_tickets'
  end

  post '/users/new' do
    @user = User.create(params)
    @user.role = 'user'
    @user.save
    session[:user_id] = @user.id
    redirect to '/support_tickets'
  end

  post '/tickets/new' do
    @user = current_user
    @ticket = SupportTicket.create(params)
    @ticket.user = @user
    @ticket.save
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
