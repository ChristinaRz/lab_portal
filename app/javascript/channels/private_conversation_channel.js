import consumer from "channels/consumer"
 
//εγγραφή στο κανάλι ιδιωτικής συνομιλίας
consumer.subscriptions.create("Private::ConversationChannel", {
  connected() {
    console.log("Connected to Private::ConversationChannel");
  },
 
  disconnected() {
    console.log("Disconnected from Private::ConversationChannel");
  },
 
  received(data) {
    if (data.message) {
      const conversationId = data.conversation_id;
      const messagesContainer = document.getElementById(`messages-pc-${conversationId}`);
 
      if (messagesContainer) {
        //το popup υπάρχει ήδη — προσθέτουμε το μήνυμα
        messagesContainer.insertAdjacentHTML('beforeend', data.message);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      } else {
        //ο παραλήπτης δεν έχει ανοιχτό popup — εμφάνιση toast
        if (data.sender_name) {
          showToast(`💬 Νέο μήνυμα από ${data.sender_name}`);
        }
        //άνοιγμα popup μέσω AJAX
        fetch(`/private/conversations/${conversationId}/open`, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'text/javascript'
          }
        })
        .then(r => r.text())
        .then(js => eval(js));
      }
    }
  }
});
 
//εμφάνιση toast notification
function showToast(message) {
  var container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.style.cssText = `
      position: fixed; top: 20px; right: 20px;
      z-index: 9999; display: flex;
      flex-direction: column; gap: 8px;
    `;
    document.body.appendChild(container);
  }
 
  var toast = document.createElement('div');
  toast.style.cssText = `
    background: #4e5d6c; color: white;
    padding: 12px 18px; border-radius: 6px;
    border-left: 4px solid #df691a;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    font-size: 14px; max-width: 300px;
    opacity: 0; transition: opacity 0.3s ease;
  `;
  toast.textContent = message;
  container.appendChild(toast);
 
  setTimeout(() => { toast.style.opacity = '1'; }, 10);
  setTimeout(() => {
    toast.style.opacity = '0';
    setTimeout(() => { toast.remove(); }, 300);
  }, 4000);
}
