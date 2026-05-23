class Group::ConversationsController < ApplicationController
 
  # POST
  # Δημιουργία νέας ομαδικής συνομιλίας
  def create
    @conversation = create_group_conversation
    add_to_conversations unless already_added?
    respond_to do |format|
      format.js
      format.html { redirect_to group_conv_path(@conversation), notice: 'Group conversation created!' }
    end
  end
 
  # PUT
  # Προσθήκη νέου χρήστη σε ομαδική συνομιλία
  def update
    Group::AddUserToConversationService.new({
      conversation_id: params[:id],
      new_user_id: params[:user][:id],
      added_by_id: params[:added_by]
    }).call
  end
 
  #ανοιγμα παραθύρου ομαδικής συνομιλίας
  def open
    @conversation = Group::Conversation.find(params[:id])
    add_to_conversations unless already_added?
    respond_to do |format|
      format.js { render partial: 'group/conversations/open' }
    end
  end
 
  #κλείσιμο παραθύρου ομαδικής συνομιλίας
  def close
    @conversation = Group::Conversation.find(params[:id])
    session[:group_conversations].delete(@conversation.id)
    respond_to do |format|
      format.js
    end
  end
 
  private
 
  def add_to_conversations
    #προσθήκη συνομιλίας στο session
    session[:group_conversations] ||= []
    session[:group_conversations] << @conversation.id
  end
 
  def already_added?
    #ελεγχος αν η συνομιλία είναι ήδη ανοιχτή
    session[:group_conversations].include?(@conversation.id)
  end
 
  def create_group_conversation
    #service για δημιουργία ομαδικής συνομιλίας
    Group::NewConversationService.new({
      creator_id: params[:creator_id],
      private_conversation_id: params[:private_conversation_id],
      new_user_id: params[:group_conversation][:id]
    }).call
  end
end
