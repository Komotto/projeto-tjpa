from fastapi import FastAPI
import subprocess
import os

app = FastAPI()

LOCK_FILE = "/tmp/process.lock"

@app.get("/")
def health():
    return {"status": "API ativa"}

@app.post("/executar")
def executar():
    if os.path.exists(LOCK_FILE):
        return {"status": "Processo já em execução"}

    open(LOCK_FILE, "w").close()

    try:
        subprocess.run(["./root.sh"], check=True)
    finally:
        os.remove(LOCK_FILE)

    return {"status": "Processo finalizado"}
