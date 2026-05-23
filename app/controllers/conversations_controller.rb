class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    #φορτώνονται όλες οι ιδιωτικές συνομιλίες του χρήστη
    @private_conversations = Private::Conversation
                               .all_by_user(current_user.id)
                               .includes(:messages)
    #φορτώνονται όλες οι ομαδικές συνομιλίες του χρήστη
    @group_conversations = current_user.group_conversations
                               .includes(:messages)
  end

  def show
    #εύρεση ιδιωτικής συνομιλίας
    @conversation = Private::Conversation.find(params[:id])
    #έλεγχος ότι ο χρήστης είναι μέλος της συνομιλίας
    if @conversation.sender_id != current_user.id && @conversation.recipient_id != current_user.id
      redirect_to conversations_path, alert: 'Not allowed.' and return
    end
    @messages = @conversation.messages.order(created_at: :asc)
    @other_user = @conversation.opposed_user(current_user)
  end

  def show_group
    #εύρεση ομαδικής συνομιλίας
    @conversation = Group::Conversation.find(params[:id])
    #έλεγχος ότι ο χρήστης είναι μέλος της ομαδικής συνομιλίας
    if !current_user.group_conversations.include?(@conversation)
      redirect_to conversations_path, alert: 'Not allowed.' and return
    end
    @messages = @conversation.messages.order(created_at: :asc)
  end

  def destroy
    #διαγραφή ιδιωτικής συνομιλίας
    @conversation = Private::Conversation.find(params[:id])
    if @conversation.sender_id != current_user.id && @conversation.recipient_id != current_user.id
      redirect_to conversations_path, alert: 'Not allowed.' and return
    end
    @conversation.destroy
    session[:private_conversations]&.delete(@conversation.id)
    redirect_to conversations_path, notice: 'Conversation deleted.'
  end

  def destroy_group
    #διαγραφή ομαδικής συνομιλίας
    @conversation = Group::Conversation.find(params[:id])
    if !current_user.group_conversations.include?(@conversation)
      redirect_to conversations_path, alert: 'Not allowed.' and return
    end
    @conversation.destroy
    session[:group_conversations]&.delete(@conversation.id)
    redirect_to conversations_path, notice: 'Group conversation deleted.'
  end

  def create_message
    #δημιουργία μηνύματος σε ιδιωτική συνομιλία
    @conversation = Private::Conversation.find(params[:id])
    message = @conversation.messages.new(
      body: params[:body],
      user_id: current_user.id
    )
    if message.save
      redirect_to conversation_path(@conversation), notice: 'Message sent!'
    else
      redirect_to conversation_path(@conversation), alert: 'Message failed!'
    end
  end
end