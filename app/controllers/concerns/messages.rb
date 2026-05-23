require 'active_support/concern'

module Messages
  extend ActiveSupport::Concern

  def get_messages(conversation_type, messages_amount)
    #μετατροπή string σε constant για δυναμική κλήση model
    model = "#{conversation_type.capitalize}::Conversation".constantize

    #εύρεση της συνομιλίας με βάση το conversation_id
    @conversation = model.find(params[:conversation_id])

    #φορτώνονται τα προηγούμενα μηνύματα (από νεότερο σε παλαιότερο)
    @messages = @conversation.messages
                             .order(created_at: :desc)
                             .limit(messages_amount)
                             .offset(params[:messages_to_display_offset].to_i)

    #offset για το επόμενο φόρτωμα μηνυμάτων
    @messages_to_display_offset = params[:messages_to_display_offset].to_i + messages_amount

    @type = conversation_type.downcase

    #αν δεν υπάρχουν άλλα μηνύματα, το offset γίνεται 0
    #ετσι ώστε να εξαφανιστεί το κουμπί "φόρτωσε περισσότερα"
    if @conversation.messages.count < @messages_to_display_offset
      @messages_to_display_offset = 0
    end
  end
end