// Frontend matching game logic
async function fetchCards() {
  const res = await fetch('/api/cards');
  return res.json();
}

function shuffleArray(a) {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
}

(function () {
  const statusEl = document.getElementById('status');
  const boardEl = document.getElementById('board');
  const startBtn = document.getElementById('startBtn');
  const restartBtn = document.getElementById('restartBtn');
  const errorsEl = document.getElementById('errors');
  const overlay = document.getElementById('startOverlay');
  const overlayStartBtn = document.getElementById('overlayStartBtn');

  let cards = [];
  let deck = [];
  let selected = [];
  let matched = new Set();
  let gameReady = false;
  let errors = 0;

  async function init() {
    try {
      const status = await fetch('/api/status').then(r => r.json());
      statusEl.textContent = `Backend: ${status.status}`;
    } catch (e) {
      statusEl.textContent = 'Backend unreachable';
    }
    cards = await fetchCards();
    startBtn.addEventListener('click', () => { if (overlay) overlay.style.display='none'; startGame(); });
    restartBtn.addEventListener('click', startGame);
    if (overlayStartBtn) {
      overlayStartBtn.addEventListener('click', () => {
        if (overlay) overlay.style.display = 'none';
        startGame();
      });
    }
    renderPlaceholder();
  }

  function renderPlaceholder() {
    boardEl.innerHTML = '';
    // empty grid placeholders
    for (let i = 0; i < 20; i++) {
      const el = document.createElement('div');
      el.className = 'card';
      boardEl.appendChild(el);
    }
  }

  function buildDeck() {
    deck = cards.concat(cards).map((c, idx) => ({ ...c, uid: idx }));
    shuffleArray(deck);
    matched = new Set();
    selected = [];
    errors = 0;
    errorsEl.textContent = `Errors: ${errors}`;
  }

  function renderBoard(showFaces = false) {
    boardEl.innerHTML = '';
    deck.forEach((card, i) => {
      const el = document.createElement('div');
      el.className = 'card';
      el.dataset.index = i;
      const img = document.createElement('img');
      img.alt = card.name;
      // when showing faces (start reveal) use face; otherwise back
      img.src = showFaces ? card.image : '/img/back.jpg';
      el.appendChild(img);
      el.addEventListener('click', onCardClick);
      boardEl.appendChild(el);
    });
  }

  function onCardClick(e) {
    if (!gameReady) return;
    const el = e.currentTarget;
    const idx = Number(el.dataset.index);
    if (matched.has(idx)) return;
    if (selected.includes(idx)) return;
    flipToFace(el, idx);
    selected.push(idx);
    if (selected.length === 2) {
      gameReady = false; // pause input
      const [a, b] = selected;
      if (deck[a].name === deck[b].name) {
        matched.add(a);
        matched.add(b);
        markMatched(a);
        markMatched(b);
        selected = [];
        gameReady = true;
        checkWin();
      } else {
        errors++;
        errorsEl.textContent = `Errors: ${errors}`;
        setTimeout(() => {
          // flip back
          flipToBack(getCardElement(a));
          flipToBack(getCardElement(b));
          selected = [];
          gameReady = true;
        }, 1000);
      }
    }
  }

  function getCardElement(idx) {
    return boardEl.querySelector(`.card[data-index="${idx}"]`);
  }

  function flipToFace(el, idx) {
    const img = el.querySelector('img');
    img.src = deck[idx].image;
  }

  function flipToBack(el) {
    if (!el) return;
    const img = el.querySelector('img');
    img.src = '/img/back.jpg';
  }

  function markMatched(idx) {
    const el = getCardElement(idx);
    if (!el) return;
    el.classList.add('matched');
  }

  function checkWin() {
    if (matched.size === deck.length) {
      gameReady = false;
      restartBtn.disabled = false;
      startBtn.disabled = false;
      statusEl.textContent = 'You win!';
    }
  }

  function startGame() {
    startBtn.disabled = true;
    restartBtn.disabled = true;
    buildDeck();
    // reveal faces briefly
    renderBoard(true);
    setTimeout(() => {
      renderBoard(false);
      gameReady = true;
      restartBtn.disabled = false;
    }, 1500);
  }

  // init on load
  init();

})();
