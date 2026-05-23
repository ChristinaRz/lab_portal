class Group::NewConversationService
  def initialize(params)
    @creator_id = params[:creator_id]
    @private_conversation_id = params[:private_conversation_id]
    @new_user_id = params[:new_user_id]
  end
 
  def call
    creator = User.find(@creator_id)
    #βρίσκεται ο άλλος χρήστης από την ιδιωτική συνομιλία
    pchat_opposed_user = Private::Conversation
                           .find(@private_conversation_id)
                           .opposed_user(creator)
    new_user_to_chat = User.find(@new_user_id)
 
    #δημιουργία ομαδικής συνομιλίας 
    #με όνομα από τα ονόματα των χρηστών
    new_group_conversation = Group::Conversation.new
    new_group_conversation.name = "#{creator.name}, #{pchat_opposed_user.name}, #{new_user_to_chat.name}"
 
    if new_group_conversation.save
      arr_of_users_ids = [creator.id, pchat_opposed_user.id, new_user_to_chat.id]
 
      #προσθήκη χρηστών στη συνομιλία
      creator.group_conversations << new_group_conversation
      pchat_opposed_user.group_conversations << new_group_conversation
      new_user_to_chat.group_conversations << new_group_conversation
 
      #δημιουργία αρχικού μηνύματος
      create_initial_message(creator, arr_of_users_ids, new_group_conversation)
 
      new_group_conversation
    end
  end
 
  private
 
  def create_initial_message(creator, arr_of_users_ids, new_group_conversation)
    #ενημερωτικό μήνυμα για τη δημιουργία της συνομιλίας
    message = Group::Message.create(
      user_id: creator.id,
      content: "Conversation created by #{creator.name}",
      added_new_users: arr_of_users_ids,
      conversation_id: new_group_conversation.id
    )
    Group::MessageBroadcastJob.perform_now(message, nil, nil)
  end
end
