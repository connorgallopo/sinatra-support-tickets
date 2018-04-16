require 'rack-flash'
class TicketController < ApplicationController
  use Rack::Flash

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

    def current_user
      User.find_by(id: session[:user_id])
    end

    def logged_in?
      current_user ? true : false
    end

end
