Table of Contents

Overview

Features

Screenshots

Tech Stack

Architecture

Installation & Setup

Usage

Future Improvements

License

Overview

ChitChat is a real-time chat application built with Flutter on the frontend and FastAPI on the backend. The app allows multiple users to communicate instantly, with features like online/offline status, typing indicators, message history, and instant delivery.

This app is ideal for learning real-time WebSocket communication, user authentication with JWT, and Flutter-FastAPI integration.

Features

User Authentication: Register & login with JWT-based authentication.

Real-Time Messaging: Send & receive messages instantly using WebSockets.

Typing Indicator: See when the other user is typing.

Online/Offline Status: Shows green/red indicator for active users.

Message History: Fetch previous chats when opening a conversation.

Message Alignment: Sent messages appear on the right, received on the left.

Timestamp Display: Each message shows sent/received time.

	
Tech Stack

Frontend: Flutter, Dart

Backend: FastAPI, Python

Database: SQLAlchemy (SQLite/PostgreSQL optional)

WebSocket: FastAPI WebSocket & Flutter WebSocket

Authentication: JWT Token

Architecture
Flutter (Mobile App) <----WebSocket----> FastAPI (Backend)
        |                                 |
        |-------- HTTP REST API ---------->|
        |                                 |
        |-------- Database (SQLAlchemy)---|


Key Points:

Flutter handles UI, WebSocket client & API calls.

FastAPI manages authentication, user management, message storage & WebSocket communication.

SQLAlchemy stores messages, user data, and last seen status.

Installation & Setup
Backend (FastAPI)

Clone the repository:

git clone <repo_url>
cd backend


Create & activate a virtual environment:

python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows


Install dependencies:

pip install -r requirements.txt


Run the server:

uvicorn main:app --reload


The backend runs at: http://localhost:8000

Frontend (Flutter)

Navigate to the frontend folder:

cd frontend


Install dependencies:

flutter pub get


Run the app on emulator or physical device:

flutter run


Make sure the backend URL in api_service.dart & websocket_service.dart matches your local FastAPI server URL.

Usage

Open the app.

Register a new user or login.

Browse the Users List to see online/offline users.

Tap a user to open Chat Screen.

Send messages in real-time.

Observe typing indicator and online/offline status.

Future Improvements

Add Group Chat support.

Push notifications for new messages.

Message read receipts.

Emoji & media support.

Dark mode UI.

License

This project is licensed under the MIT License.
See LICENSE
 for details.
