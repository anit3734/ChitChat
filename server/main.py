from fastapi import FastAPI
from routes.auth_routes import router as auth_router

app = FastAPI(title="ChitChat Backend")

app.include_router(auth_router)

@app.get("/")
async def root():
    return {"message": "ChitChat API running"}
