import subprocess
from fastapi import FastAPI, BackgroundTasks

app = FastAPI()

def rodar():
    subprocess.run(["./root.sh"])

@app.post("/executar")
def executar(background_tasks: BackgroundTasks):
    background_tasks.add_task(rodar)
    return {"status": "processamento iniciado"}
