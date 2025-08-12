document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('#new_chain_word');
  
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(form);
      const wordInput = document.querySelector('#chain_word_word');
      
      // フォームデータを送信
      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          // 成功時はWebSocketで更新されるので、フォームだけリセット
          wordInput.value = '';
        } else {
          // エラー時はメッセージを表示
          showErrorMessage(data.errors.join(', '));
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showErrorMessage('エラーが発生しました');
      });
    });
  }
});

function showErrorMessage(message) {
  // 既存のエラーメッセージを削除
  const existingError = document.querySelector('.error-message');
  if (existingError) {
    existingError.remove();
  }
  
  // 新しいエラーメッセージを作成
  const errorDiv = document.createElement('div');
  errorDiv.className = 'alert alert-danger error-message';
  errorDiv.style.position = 'fixed';
  errorDiv.style.top = '20px';
  errorDiv.style.right = '20px';
  errorDiv.style.zIndex = '9999';
  errorDiv.textContent = message;
  
  document.body.appendChild(errorDiv);
  
  // 5秒後にエラーメッセージを削除
  setTimeout(() => {
    if (errorDiv.parentNode) {
      errorDiv.parentNode.removeChild(errorDiv);
    }
  }, 5000);
}
