require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash
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
    redirect to '/login' unless logged_in?
    @user = current_user
    erb :'/tickets/tickets'
  end

  get '/support_tickets/new' do
    redirect to '/login' unless logged_in?
    erb :'/tickets/new_ticket'
  end

  get '/support_tickets/:id' do
    if logged_in?
      @user = current_user
      @ticket = SupportTicket.find_by(id: params[:id])
      if @user.role == 'admin' || @ticket.user == current_user
        erb :'/tickets/show'
      end
    else
      flash[:error] = 'ACCESS DENIED'
      redirect to '/support_tickets'
    end
  end

  get '/support_tickets/:id/edit' do
  @user = current_user
    @ticket = SupportTicket.find_by(id: params[:id])
    binding.pry
    if @user.role == 'admin' || @ticket.user == current_user
      binding.pry
      erb :'/tickets/edit'
  else
    flash[:error] = 'ACCESS DENIED'
    redirect to '/login'
  end
end

  patch '/tickets/:id/edit' do
    @ticket = SupportTicket.find_by(id: params[:id])
    @ticket.update(subject: params['subject'], body: params['body'])
    flash[:message] = 'Ticket sucessfully edited.'
    redirect to '/support_tickets'
  end

  post '/users/new' do
    @user = User.find_by(email: params['email'])
    if @user.nil?
      if valid_email?(params['email'])
        @user = User.create(params)
        @user.role = 'user'
        @user.save
        session[:user_id] = @user.id
        redirect to '/support_tickets'
      else
        flash[:error] = 'Please enter a valid email address.'
        redirect to '/users/new'
      end
    else
      flash[:error] = 'Account already exists, please Log In.'
      redirect to '/login'
    end
  end

  post '/tickets/new' do
    if params['subject'] != '' && params['body'] != ''
      @user = current_user
      @ticket = SupportTicket.create(params)
      @ticket.user = @user
      @ticket.save
      flash[:message] = 'Ticket sucessfully created.'
      redirect to '/support_tickets'
    else
      flash[:error] = 'Both Fields must be filled out'
      redirect to '/support_tickets/new'
    end
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

  delete '/tickets/:id/delete' do
    if logged_in?
      @user = current_user
      @ticket = SupportTicket.find_by(id: params[:id])
      if @user.role == 'admin' || @ticket.user == current_user
        @ticket.delete
        flash[:message] = 'Ticket Deleted.'
        redirect to '/support_tickets'
      end
    else
      flash[:error] = 'You must be logged in to do that.'
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear if logged_in?
    flash[:message] = 'Logged Out'
    redirect to '/login'
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end

  def valid_email?(email)
    /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i === email
  end
end
