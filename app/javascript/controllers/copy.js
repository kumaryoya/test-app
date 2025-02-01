document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.copy-button').forEach(button => {
    button.addEventListener('click', () => {
      const targetId = button.getAttribute('data-target');
      const targetElement = document.getElementById(targetId);
      const content = targetElement.innerText;
      navigator.clipboard.writeText(content)
      .then(() => {
        const originalText = button.querySelector('.copy-text');
        originalText.textContent = 'コピーしました';
        setTimeout(() => {
          originalText.textContent = 'コピー';
        }, 2000);
      })
    });
  });
});
