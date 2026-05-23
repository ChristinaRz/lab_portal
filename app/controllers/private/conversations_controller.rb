class Private::ConversationsController < ApplicationController
  before_action :authenticate_user!
 
  # POST 
  # Δημιουργία νέας ιδιωτικής συνομιλίας από post
  def create
    #βρίσκεται ο αποδέκτης από τον συγγραφέα του post
    recipient_id = Post.find(params[:post_id]).user.id
    #έλεγχος αν υπάρχει ήδη συνομιλία μεταξύ των δύο χρηστών
    @conversation = Private::Conversation
                      .between_users(current_user.id, recipient_id)
                      .first
 
    if @conversation.nil?
      #δημιουργία νέας συνομιλίας αν δεν υπάρχει
      @conversation = Private::Conversation.create!(
        sender_id: current_user.id,
        recipient_id: recipient_id
      )
    end
 
    #μήνυμα στη συνομιλία (υπάρχουσα ή νέα)
    Private::Message.create(
      user_id: current_user.id,
      conversation_id: @conversation.id,
      body: params[:message_body]
    )
 
    add_to_conversations unless already_added?
 
    #αντί για redirect, ανοίγει popup με JS
    respond_to do |format|
      format.js { render partial: 'private/conversations/open' }
      format.html { redirect_to posts_path, notice: 'Message sent!' }
    end
  end
 
  #ανοιγμα παραθύρου ιδιωτικής συνομιλίας
  def open
    @conversation = Private::Conversation.find(params[:id])
    add_to_conversations unless already_added?
    respond_to do |format|
      format.js { render partial: 'private/conversations/open' }
    end
  end
 
  #κλείσιμο παραθύρου ιδιωτικής συνομιλίας
  def close
    @conversation_id = params[:id].to_i
    session[:private_conversations].delete(@conversation_id)
    respond_to do |format|
      format.js
      format.html { head :no_content }
    end
  end
 
  private
 
  def add_to_conversations
    #προσθήκη συνομιλίας στο session
    session[:private_conversations] ||= []
    session[:private_conversations] << @conversation.id
  end
 
  def already_added?
    #ελεγχος αν η συνομιλία είναι ήδη ανοιχτή
    session[:private_conversations].include?(@conversation.id)
  end
end
 
