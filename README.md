## Getting Started

Welcome to the VS Code Java world. Here is a guideline to help you get started to write Java code in Visual Studio Code.

## Folder Structure

The workspace contains two folders by default, where:

- `src`: the folder to maintain sources
- `lib`: the folder to maintain dependencies

Meanwhile, the compiled output files will be generated in the `bin` folder by default.

> If you want to customize the folder structure, open `.vscode/settings.json` and update the related settings there.

## Dependency Management

The `JAVA PROJECTS` view allows you to manage your dependencies. More details can be found [here](https://github.com/microsoft/vscode-java-dependency#manage-dependencies).

## Web frontend & backend (added)

A minimal frontend and backend were added to this project to provide a simple web demo of the MatchCards assets.

Backend (Node/Express):

- Location: `backend/`
- Start:

  1. Install Node.js (LTS) if you don't have it.
  2. Open PowerShell in the project root and run:

	  npm install; cd backend; npm install

  3. Start the backend:

	  cd backend; npm start

  The backend serves a small API on http://localhost:3000:
  - `GET /api/status` — health/status
  - `GET /api/cards` — JSON list of card objects ({name, image})
  - `GET /img/<name>.jpg` — serves images from the existing `img/` folder

Frontend (static):

- Location: `frontend/` (served by the backend)
- After the backend is running, open http://localhost:3000 in your browser to view the web demo.

Notes:
- The web demo is intentionally minimal — it uses static HTML/CSS/JS and fetches the `/api/cards` endpoint.
- If you prefer to serve the frontend separately, you can open `frontend/index.html` in a browser but be mindful of CORS for the API.

