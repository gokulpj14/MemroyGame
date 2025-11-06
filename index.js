const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());

// serve images from top-level img/ (existing project images)
app.use('/img', express.static(path.join(__dirname, '..', 'img')));
// serve frontend static files
app.use(express.static(path.join(__dirname, '..', 'frontend')));

// sample card list (match the Java project names)
const cards = [
  "apple",
  "banana",
  "cherry",
  "grapes",
  "mango",
  "orange",
  "papaya",
  "pineapple",
  "strawberry",
  "watermelon"
];

app.get('/api/status', (req, res) => {
  res.json({ status: 'ok', name: 'MatchCards backend' });
});

app.get('/api/cards', (req, res) => {
  // return card objects with name and image URL
  const result = cards.map(name => ({
    name,
    image: `/img/${name}.jpg`
  }));
  res.json(result);
});

// fallback to index.html for SPA
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'frontend', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`MatchCards backend listening on http://localhost:${PORT}`);
});
