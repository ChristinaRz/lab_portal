class ContactsController < ApplicationController
  #υποχρεωτικό login για διαχείριση επαφών
  before_action :authenticate_user!
 
  # GET /posts/:post_id/contacts
  def index
    #φορτώνονται όλες οι επαφές του χρήστη
    @contacts = current_user.contacts.includes(:contact_user)
  end
 
  # POST /posts/:post_id/contacts
  def create
    # Αναζήτηση χρήστη με βάση όνομα
    contact_user = User.find_by(name: params[:contact_name])
 
    if contact_user.nil?
      redirect_to contacts_path, alert: 'User not found!'
    elsif contact_user == current_user
      redirect_to contacts_path, alert: 'You cannot add yourself!'
    else
      contact = current_user.contacts.new(contact_user: contact_user)
      if contact.save
        #αποστολή ειδοποίησης στον παραλήπτη μέσω ActionCable
        ContactRequestBroadcastJob.perform_now(contact)
        redirect_to contacts_path, notice: 'Contact added!'
      else
        redirect_to contacts_path, alert: 'Contact already exists!'
      end
    end
  end
 
  # DELETE /posts/:post_id/contacts/:id
  def destroy
    #διαγραφή μόνο από τις επαφές του current_user
    contact = current_user.contacts.find(params[:id])
    contact.destroy
    redirect_to contacts_path, notice: 'Contact removed.'
  end
end

