from pydantic import BaseModel, EmailStr
from datetime import datetime

class User(BaseModel):
    email: EmailStr
    password: str
    created_at: datetime = datetime.utcnow()
