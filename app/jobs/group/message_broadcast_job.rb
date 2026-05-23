class Group::MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, previous_message, current_user)
    #broadcast σε όλα τα μέλη της ομαδικής συνομιλίας
    message.conversation.users.each do |user|
      ActionCable.server.broadcast(
        "group_conversations_#{user.id}",
        { message: message.content,
          sender_name: message.user.name || message.user.email,
          conversation_id: message.conversation_id }
      )
    end
  end
end
