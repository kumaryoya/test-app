import consumer from "./consumer"

consumer.subscriptions.create("ChainWordsChannel", {
  connected() {
    console.log("Connected to ChainWordsChannel");
  },

  disconnected() {
    console.log("Disconnected from ChainWordsChannel");
  },

  received(data) {
    console.log("Received data:", data);

    if (data.action === 'create') {
      this.addChainWord(data.chain_word);
    }
  },

  addChainWord(chainWord) {
    // 新しいカードを作成
    const newCard = document.createElement('div');
    newCard.className = 'card border m-3';
    newCard.style.width = '400px';

    newCard.innerHTML = `
      <div class="card-header h5 text-center">${chainWord.word}</div>
      <div class="card-body h5 text-center">${chainWord.user_name}</div>
    `;

    // カードコンテナを取得
    const cardContainer = document.querySelector('#chain-words-container');

    if (cardContainer) {
      // 新しいカードを先頭に追加（最新のものが上に表示される）
      cardContainer.insertBefore(newCard, cardContainer.firstChild);

      // フォームをリセット
      const wordInput = document.querySelector('#chain_word_word');
      if (wordInput) {
        wordInput.value = '';
      }

      // 成功メッセージを表示
      this.showMessage('新しい単語が追加されました！', 'success');
    }
  },

  showMessage(text, type = 'info') {
    // 既存のメッセージを削除
    const existingMessage = document.querySelector('.realtime-message');
    if (existingMessage) {
      existingMessage.remove();
    }

    // 新しいメッセージを作成
    const message = document.createElement('div');
    message.className = `alert alert-${type} realtime-message`;
    message.style.position = 'fixed';
    message.style.top = '20px';
    message.style.right = '20px';
    message.style.zIndex = '9999';
    message.textContent = text;

    document.body.appendChild(message);

    // 3秒後にメッセージを削除
    setTimeout(() => {
      if (message.parentNode) {
        message.parentNode.removeChild(message);
      }
    }, 3000);
  }
});
