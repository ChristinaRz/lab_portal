class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
  #επιτρέπει το πεδίο name στην εγγραφή μέσω devise
  before_action :configure_permitted_parameters, if: :devise_controller?
 
  #λίστα ανοιχτών παραθύρων συνομιλιών για κάθε σελίδα
  before_action :opened_conversations_windows
  #λίστα όλων των συνομιλιών του χρήστη
  before_action :all_ordered_conversations
  #δεδομένα χρήστη για JavaScript
  before_action :set_user_data
 
  def all_ordered_conversations
    if user_signed_in?
      @all_conversations = OrderConversationsService.new({ user: current_user }).call
    end
  end
 
  def opened_conversations_windows
    if user_signed_in?
      #αρχικοποίηση session για ανοιχτές συνομιλίες
      session[:private_conversations] ||= []
      session[:group_conversations] ||= []
 
      #ανοιχτά παράθυρα ιδιωτικών συνομιλιών
      @private_conversations_windows = Private::Conversation
        .includes(:recipient, :messages)
        .where(id: session[:private_conversations])
 
      #ανοιχτά παράθυρα ομαδικών συνομιλιών
      @group_conversations_windows = Group::Conversation
        .where(id: session[:group_conversations])
    else
      @private_conversations_windows = []
      @group_conversations_windows = []
    end
  end
 
  def redirect_if_not_signed_in
    #redirect στην αρχική αν ο χρήστης δεν είναι συνδεδεμένος
    redirect_to root_path unless user_signed_in?
  end
 
  def redirect_if_signed_in
    #redirect στην αρχική αν ο χρήστης είναι ήδη συνδεδεμένος
    redirect_to root_path if user_signed_in?
  end
 
  private
 
  def set_user_data
    if user_signed_in?
      #αποστολή δεδομένων στο JavaScript μέσω gon
      gon.group_conversations = current_user.group_conversations.ids
      gon.user_id = current_user.id
      cookies[:user_id] = current_user.id if current_user.present?
      cookies[:group_conversations] = current_user.group_conversations.ids
    else
      gon.group_conversations = []
    end
  end
 
  def configure_permitted_parameters
    #προσθήκη :name στα επιτρεπτά πεδία του Devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
 
