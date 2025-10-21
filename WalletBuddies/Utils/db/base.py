from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy import create_engine
import os

DATABASE_URL = "postgresql://wallet_user:postgres@localhost:5432/walletbuddies_db"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()