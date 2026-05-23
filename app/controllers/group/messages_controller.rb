class Group::MessagesController < ApplicationController
  include Messages
 
  # GET
  # Φορτώνονται παλαιότερα μηνύματα ομαδικής συνομιλίας
  def index
    get_messages('group', 15)
    @user = current_user
    @is_messenger = params[:is_messenger]
    respond_to do |format|
      format.js { render partial: 'group/messages/load_more_messages' }
    end
  end
 
  # POST
  # Αποστολή νέου μηνύματος σε ομαδική συνομιλία
  def create
    @conversation = Group::Conversation.find(params[:conversation_id])
    @message = Group::Message.new(
      user_id: current_user.id,
      conversation_id: @conversation.id,
      content: params[:content]
    )
    if @message.save
      Group::MessageBroadcastJob.perform_now(@message, nil, nil)
    end
    redirect_to group_conv_path(@conversation)
  end
end
