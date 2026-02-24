from fastapi import FastAPI
import subprocess

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/executar")
def executar():
    result = subprocess.run(
        ["./root.sh"],
        capture_output=True,
        text=True
    )
    return {
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }
