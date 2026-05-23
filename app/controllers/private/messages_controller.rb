class Private::MessagesController < ApplicationController
  include Messages

  # GET 
  #Φορτώνονται παλαιότερα μηνύματα
  def index
    get_messages('private', 10)
    @user = current_user
    respond_to do |format|
      format.js { render partial: 'private/messages/load_more_messages' }
    end
  end

  # POST
  def create
    #εύρεση συνομιλίας
    conversation = Private::Conversation.find(params[:conversation_id])
    #τελευταίο μήνυμα πριν το νέο (για σωστό rendering)
    previous_message = conversation.messages.last
    #δημιουργία μηνύματος
    message = conversation.messages.new(
      body: params[:body],
      user_id: current_user.id
    )
    if message.save
      #broadcast στον αποστολέα και παραλήπτη μέσω ActionCable
      Private::MessageBroadcastJob.perform_now(message, previous_message)
      #notification στον παραλήπτη
      recipient = conversation.opposed_user(current_user)
      ActionCable.server.broadcast(
        "notifications_#{recipient.id}",
        { notification: 'new-message',
          sender_name: current_user.name || current_user.email }
      )
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to posts_path, notice: 'Message sent!' }
      end
    else
      respond_to do |format|
        format.js { head :unprocessable_entity }
        format.html { redirect_to posts_path, alert: 'Message failed!' }
      end
    end
  end
end