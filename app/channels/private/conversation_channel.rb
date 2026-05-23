class Private::ConversationChannel < ApplicationCable::Channel

  def subscribed
    #εγγραφή στο κανάλι ιδιωτικών συνομιλιών του χρήστη
    stream_from "private_conversations_#{current_user.id}"
  end

  def unsubscribed
    #διακοπή streams με την αποσυνδεση χρήστη
    stop_all_streams
  end

  def send_message(data)
    #μετατροπή των δεδομένων της φόρμας σε hash
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el['name']] = el['value']
    end
    #εύρεση συνομιλίας για previous_message
    conversation = Private::Conversation.find(message_params['conversation_id'].to_i)
    previous_message = conversation.messages.last
    #δημιουργία νέου ιδιωτικού μηνύματος
    message = Private::Message.create(message_params)
    #broadcast στον αποστολέα και παραλήπτη
    if message.persisted?
      Private::MessageBroadcastJob.perform_now(message, previous_message)
      #notification στον παραλήπτη
      recipient = conversation.opposed_user(current_user)
      ActionCable.server.broadcast(
        "notifications_#{recipient.id}",
        { notification: 'new-message',
          sender_name: current_user.name || current_user.email }
      )
    end
  end

  def set_as_seen(data)
    #εύρεση συνομιλίας
    #σήμανση όλων των μηνυμάτων ως seen
    conversation = Private::Conversation.find(data["conv_id"].to_i)
    messages = conversation.messages.where(seen: false)
    messages.each do |message|
      message.update(seen: true)
    end
  end
end