import consumer from "./consumer"

consumer.subscriptions.create("ChainWordChannel", {
  connected() {
    console.log("Connected to ChainWordChannel");
  },

  disconnected() {
    console.log("Disconnected from ChainWordChannel");
  },

  received(data) {
    console.log("Received data:", data);

    if (data.action === 'create') {
      this.addChainWord(data.chain_word);
    }
  },

  addChainWord(chainWord) {
    const newCard = document.createElement('div');
    newCard.className = 'card border m-3';
    newCard.style.width = '400px';

    newCard.innerHTML = `
      <div class="card-header h5 text-center">${chainWord.word}</div>
      <div class="card-body h5 text-center">${chainWord.user_name}</div>
    `;

    const cardContainer = document.querySelector('#chain-word-container');

    if (cardContainer) {
      cardContainer.insertBefore(newCard, cardContainer.firstChild);

      const wordInput = document.querySelector('#chain_word_word');
      if (wordInput) {
        wordInput.value = '';
      }

      this.showMessage('新しい単語が追加されました！', 'success');
    }
  },

  showMessage(text, type = 'info') {
    const existingMessage = document.querySelector('.realtime-message');
    if (existingMessage) {
      existingMessage.remove();
    }

    const message = document.createElement('div');
    message.className = `alert alert-${type} realtime-message`;
    message.style.position = 'fixed';
    message.style.top = '20px';
    message.style.right = '20px';
    message.style.zIndex = '9999';
    message.textContent = text;

    document.body.appendChild(message);

    setTimeout(() => {
      if (message.parentNode) {
        message.parentNode.removeChild(message);
      }
    }, 3000);
  }
});
