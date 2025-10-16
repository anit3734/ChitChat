# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# SQLite dev DB (./chat.db file)
SQLALCHEMY_DATABASE_URL = "sqlite:///./chat.db"

# Engine: DB se connection banaata hai
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

# Session factory: har request/operation ke liye session create karne ke liye
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class: isse inherit karke ORM models banayenge
Base = declarative_base()
