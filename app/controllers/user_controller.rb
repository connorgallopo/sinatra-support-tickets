  require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash
  get '/login' do
    redirect to '/support_tickets' if logged_in?
    erb :'/users/login'
  end

  get '/users/new' do
    redirect to '/support_tickets' if logged_in?
    erb :'/users/new_user'
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
