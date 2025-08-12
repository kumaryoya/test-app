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
        }
      });
    });
  }
});
