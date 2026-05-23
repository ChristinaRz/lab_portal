class Group::ConversationChannel < ApplicationCable::Channel
 
  def subscribed
    #εγγραφή μόνο αν ο χρήστης ανήκει στη συνομιλία
    if belongs_to_conversation(params[:id])
      stream_from "group_conversation_#{params[:id]}"
    end
  end
 
  def unsubscribed
    #διακοπή όλων των streams με την αποσυνδεση χρήστη
    stop_all_streams
  end
 
  def set_as_seen(data)
    #εύρεση συνομιλίας και σήμανση τελευταίου μηνύματος ως seen
    conversation = Group::Conversation.find(data['conv_id'])
    last_message = conversation.messages.last
    last_message.seen_by << current_user.id
    last_message.save
  end
 
  def send_message(data)
    #μετατροπή δεδομένων της φόρμας σε hash
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el['name']] = el['value']
    end
    message = Group::Message.new(message_params)
 
    if message.save
      #broadcast μηνύματος στους συμμετέχοντες
      previous_message = message.previous_message
      Group::MessageBroadcastJob.perform_now(message, previous_message, current_user)
    end
  end
 
  private
 
  def belongs_to_conversation(id)
    #ελεγχος αν ο χρήστης ανήκει στη συνομιλία
    conversations = current_user.group_conversations.ids
    conversations.include?(id)
  end
end
