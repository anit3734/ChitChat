from fastapi import APIRouter, HTTPException, Depends
from models.user_model import User
from database import db
from utils.hashing import hash_password, verify_password
from utils.auth_token import create_access_token, verify_token

router = APIRouter(prefix="/auth", tags=["Auth"])

@router.post("/login")
async def login_or_signup(user: User):
    existing = await db.users.find_one({"email": user.email})
    if existing:
        if verify_password(user.password, existing["password"]):
            token = create_access_token({"sub": user.email})
            return {"message": "Login successful", "token": token}
        else:
            raise HTTPException(status_code=401, detail="Invalid password")

    hashed = hash_password(user.password)
    new_user = {"email": user.email, "password": hashed}
    await db.users.insert_one(new_user)
    token = create_access_token({"sub": user.email})
    return {"message": "New account created", "token": token}

@router.get("/verify")
async def verify(token: str):
    email = verify_token(token)
    if not email:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return {"message": "Token valid", "email": email}
