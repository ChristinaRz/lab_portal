class OrderConversationsService
  def initialize(params)
    @user = params[:user]
  end

  def call
    #φρτώνονται όλες οι ιδιωτικές συνομιλίες του χρήστη
    all_private_conversations = Private::Conversation
                                  .all_by_user(@user.id)
                                  .includes(:messages)
    #φορτώνονται όλες οι ομαδικές συνομιλίες του χρήστη
    all_group_conversations = @user.group_conversations.includes(:messages)

    #συνδυασμός και ταξινόμηση κατά ημερομηνία τελευταίου μηνύματος
     all_conversations = all_private_conversations + all_group_conversations
      all_conversations = all_conversations.select { |c| c.messages.any? }

      all_conversations.sort { |a, b| b.messages.last.created_at <=> a.messages.last.created_at }
    rescue => e
      Rails.logger.error "OrderConversationsService error: #{e.message}"
      []
 end
end