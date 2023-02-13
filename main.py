import sys
from fastapi import FastAPI

version = f"{sys.version_info.major}.{sys.version_info.minor}"

app = FastAPI()


@app.get("/")
async def indext():
    message = f"Hello world! From FastAPI running on Uvicorn with Gunicorn. Using Python {version}"  # noqa
    return {"message": message}


@app.get("/message/{msg}")
async def read_item(msg: str):
    return {"message": msg}
