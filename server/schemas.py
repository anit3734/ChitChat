# schemas.py
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

# User creation request model
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: Optional[str] = None

# Response model for User
class UserResponse(BaseModel):
    id: int
    email: EmailStr
    name: Optional[str]
    created_at: datetime

    class Config:
        orm_mode = True  # allows SQLAlchemy models to convert to Pydantic

# Login request model
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Token response
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

# Message schema
class MessageCreate(BaseModel):
    receiver_id: int
    content: str

class MessageResponse(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    content: str
    timestamp: datetime
    read: int

    class Config:
        orm_mode = True
