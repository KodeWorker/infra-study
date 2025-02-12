import os
import uvicorn
from fastapi import FastAPI, Request, Response, status
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
import redis
import psycopg2
from minio import Minio
from minio.error import S3Error
import pika

app = FastAPI()

origins = [
    '*'
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# access redis cache
@app.get("/redis")
async def redis_api():
    r = redis.Redis(host=os.environ['REDIS_HOST'], port=os.environ['REDIS_PORT'], password=os.environ['REDIS_PASSWORD'], decode_responses=True)
    r.set('foo', 'bar')
    redis_return = r.get('foo')
    return {"return": str(redis_return)}

# access postgresql database
@app.get("/postgresql")
async def postgresql_api():
    conn = psycopg2.connect(database=os.environ['POSTGRES_DB'], user=os.environ['POSTGRES_USER'], 
                            password=os.environ['POSTGRES_PASSWORD'], host=os.environ['POSTGRES_HOST'], 
                            port=os.environ['POSTGRES_PORT'])
    
    cur = conn.cursor()
    cur.execute("CREATE TABLE IF NOT EXISTS test (id serial PRIMARY KEY, num integer, data varchar);")
    cur.execute("INSERT INTO test VALUES (1, 100, 'abc');")
    cur.execute("SELECT * FROM test;")
    postgresql_return = cur.fetchall()
    conn.close()
    return {"return": str(postgresql_return)}

# access storage
@app.get("/storage")
async def storage_api():

    try:
        client = Minio(f"{os.environ['MINIO_HOST']}:{os.environ['MINIO_PORT']}",
            access_key=os.environ['MINIO_ROOT_USER'],
            secret_key=os.environ['MINIO_ROOT_PASSWORD'],
            secure=False,
        )
        source_file = "/app/requirements.txt"
        bucket_name = os.environ['MINIO_BUCKET']
        destination_file = "upload_requirements.txt"

        storage_return = ""
        found = client.bucket_exists(bucket_name)
        if not found:
            client.make_bucket(bucket_name)
            storage_return += f"Created bucket {bucket_name}"
        else:
            storage_return += f"Bucket {bucket_name} already exists"

        client.fput_object(
            bucket_name, destination_file, source_file,
        )
        storage_return += f"{source_file} successfully uploaded as object {destination_file} to bucket {bucket_name}"
    except S3Error as exc:
        storage_return = f"Storage error occurred: {exc}"

    return {"return": str(storage_return)}

@app.get("/rabbitmq")
async def rabbitmq_api():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=os.environ['RABBITMQ_HOST']))
    channel = connection.channel()
    channel.queue_declare(queue='hello')
    channel.basic_publish(exchange='', routing_key='hello', body='Hello World!')
    connection.close()
    return {"return": "Message sent to RabbitMQ"}


if __name__ == '__main__':
    Instrumentator().instrument(app).expose(app)
    uvicorn.run(app, host="0.0.0.0", port=1234)