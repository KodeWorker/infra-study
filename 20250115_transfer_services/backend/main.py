import uvicorn
from fastapi import FastAPI, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import make_asgi_app, Counter, CollectorRegistry, REGISTRY
from prometheus_client.openmetrics.exposition import (CONTENT_TYPE_LATEST,
                                                      generate_latest)
app = FastAPI()

registry = CollectorRegistry()

HELLO_COUNTER = Counter("hello_total", "Total number of requests to the API", ["method", "endpoint"])

origins = [
    '*'
]

@app.get("/hello")
async def root():
    HELLO_COUNTER.labels(method="GET", endpoint="/hello").inc()
    return {"message": "Hello World"}

# metrics_app = make_asgi_app(registry)  # register!
# app.mount("/metrics", metrics_app)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def metrics(request: Request) -> Response:
    return Response(generate_latest(REGISTRY), media_type=CONTENT_TYPE_LATEST, headers={"Content-Type": CONTENT_TYPE_LATEST})
app.add_route("/metrics", metrics)

if __name__ == '__main__':
    # hardcoded host and port
    # host = 127.0.0.1 will not work in container

    Instrumentator().instrument(app).expose(app)
    uvicorn.run(app, host="0.0.0.0", port=1234) 