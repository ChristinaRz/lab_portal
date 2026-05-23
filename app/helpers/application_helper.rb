module ApplicationHelper
  include NavigationHelper
  include PostsHelper

  def private_conversations_windows
    #δεν εμφανίζονται παράθυρα συνομιλιών στη σελίδα messenger
    params[:controller] != 'messengers' ? @private_conversations_windows : []
  end

  def group_conversations_windows
    # δεν εμφανίζονται ομαδικά παράθυρα στη σελίδα messenger
    params[:controller] != 'messengers' ? @group_conversations_windows : []
  end
end