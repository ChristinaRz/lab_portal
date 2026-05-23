import consumer from "channels/consumer"
 
//εγγραφή στο notification channel
consumer.subscriptions.create("NotificationChannel", {
  connected() {
    //επιτυχής σύνδεση στο notification channel
    console.log("Connected to NotificationChannel");
  },
 
  disconnected() {
    //αποσύνδεση
    console.log("Disconnected from NotificationChannel");
  },
 
  received(data) {
    //νέα ειδοποίηση - toast
    if (data.notification === 'contact-request-received') {
      showToast(`📬 ${data.sender_name} σε πρόσθεσε στις επαφές!`);
    } else if (data.notification === 'added-to-group-conversation') {
      showToast('👥 Προστέθηκες σε ομαδική συνομιλία!');
    } else if (data.notification === 'new-message') {
      showToast(`💬 Νέο μήνυμα από ${data.sender_name}`);
    }
  }
});
 
//δημιουργία και εμφάνιση toast notification
function showToast(message) {
  //δημιουργία container αν δεν υπάρχει
  var container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      z-index: 9999;
      display: flex;
      flex-direction: column;
      gap: 8px;
    `;
    document.body.appendChild(container);
  }
 
  //δημιουργία toast
  var toast = document.createElement('div');
  toast.style.cssText = `
    background: #4e5d6c;
    color: white;
    padding: 12px 18px;
    border-radius: 6px;
    border-left: 4px solid #df691a;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    font-size: 14px;
    max-width: 300px;
    opacity: 0;
    transition: opacity 0.3s ease;
  `;
  toast.textContent = message;
  container.appendChild(toast);
 
  //fade in
  setTimeout(() => { toast.style.opacity = '1'; }, 10);
 
  //αφαίρεση μετά από 4 δευτερόλεπτα
  setTimeout(() => {
    toast.style.opacity = '0';
    setTimeout(() => { toast.remove(); }, 300);
  }, 4000);
}
 
