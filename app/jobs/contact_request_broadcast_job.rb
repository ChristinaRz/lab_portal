class ContactRequestBroadcastJob < ApplicationJob
  queue_as :default

  def perform(contact_request)
    sender = User.find(contact_request.user_id)
    receiver = User.find(contact_request.contact_user_id)
    ActionCable.server.broadcast(
      "notifications_#{receiver.id}",
      { notification: 'contact-request-received',
        sender_name: sender.name || sender.email }
    )
  end
end
