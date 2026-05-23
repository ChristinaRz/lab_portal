module MessengersHelper
  def conversations_list_item_partial_path(conversation)
    # αν είναι ιδιωτική συνομιλία
    if conversation.class == Private::Conversation
      'messengers/index/conversations_list_item/private'
    else #αν είναι ομαδική συνομιλία
      'messengers/index/conversations_list_item/group'
    end
  end
end
