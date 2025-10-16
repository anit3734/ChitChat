from fastapi import FastAPI, Depends, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from sqlalchemy import or_
from jose import JWTError
from datetime import datetime, timedelta
from typing import Dict, List

from database import Base, engine, SessionLocal
from models import User, Message
from schemas import UserCreate, UserResponse, Token, MessageResponse
from auth import (
    hash_password,
    verify_password,
    create_access_token,
    decode_access_token,
    ACCESS_TOKEN_EXPIRE_MINUTES,
)

# Create DB tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Flutter Multi-User Chat API")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ----------------- USERS -----------------
@app.post("/register", response_model=UserResponse)
def register(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_pw = hash_password(user.password)
    new_user = User(email=user.email, hashed_password=hashed_pw, name=user.name)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": str(user.id)}, expires_delta=access_token_expires)
    return {"access_token": access_token, "token_type": "bearer"}

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = decode_access_token(token)
        if payload is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        user_id: str = payload.get("sub")
        user = db.query(User).filter(User.id == int(user_id)).first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return user
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

@app.get("/me", response_model=UserResponse)
def get_profile(current_user: User = Depends(get_current_user)):
    return current_user

@app.get("/users", response_model=List[UserResponse])
def get_all_users(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    users = db.query(User).filter(User.id != current_user.id).all()
    return users

# ----------------- WEBSOCKET -----------------
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[int, WebSocket] = {}  # user_id -> websocket

    async def connect(self, websocket: WebSocket, user_id: int):
        await websocket.accept()
        self.active_connections[user_id] = websocket
        print(f"✅ User {user_id} connected")

    def disconnect(self, user_id: int):
        self.active_connections.pop(user_id, None)
        print(f"❌ User {user_id} disconnected")

    async def send_personal_message(self, message: dict, receiver_id: int):
        ws = self.active_connections.get(receiver_id)
        if ws:
            await ws.send_json(message)

manager = ConnectionManager()

@app.websocket("/ws/chat")
async def chat_endpoint(websocket: WebSocket, token: str, db: Session = Depends(get_db)):
    payload = decode_access_token(token)
    if payload is None:
        await websocket.close(code=1008)
        return
    user_id = int(payload.get("sub"))
    await manager.connect(websocket, user_id)

    try:
        while True:
            data = await websocket.receive_json()

            # Typing indicator
            if data.get("type") == "typing":
                receiver_id = data["receiver_id"]
                await manager.send_personal_message({
                    "type": "typing",
                    "status": data["status"],
                    "sender_id": user_id
                }, receiver_id)
                continue

            # Normal message
            receiver_id = data["receiver_id"]
            content = data["content"]
            message = Message(sender_id=user_id, receiver_id=receiver_id, content=content, timestamp=datetime.utcnow())
            db.add(message)
            db.commit()
            db.refresh(message)

            await manager.send_personal_message({
                "type": "message",
                "id": message.id,
                "sender_id": user_id,
                "receiver_id": receiver_id,
                "content": content,
                "timestamp": message.timestamp.isoformat()
            }, receiver_id)

    except WebSocketDisconnect:
        manager.disconnect(user_id)

# ----------------- CHAT HISTORY -----------------
@app.get("/messages/{other_user_id}", response_model=List[MessageResponse])
def get_chat_history(
    other_user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    messages = db.query(Message).filter(
        or_(
            (Message.sender_id == current_user.id) & (Message.receiver_id == other_user_id),
            (Message.sender_id == other_user_id) & (Message.receiver_id == current_user.id)
        )
    ).order_by(Message.timestamp.asc()).all()
    # Mark unread as read
    unread_msgs = db.query(Message).filter(
        (Message.sender_id == other_user_id) & (Message.receiver_id == current_user.id) & (Message.read == 0)
    ).all()
    for msg in unread_msgs:
        msg.read = 1
        db.add(msg)
    db.commit()
    return messages
