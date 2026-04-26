import os
import time
import psycopg2
from flask import Flask

app = Flask(__name__)

DB_HOST = os.getenv('DB_HOST','db')
DB_NAME = os.getenv('DB_NAME','postgres')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASS = os.getenv('DB_PASSWORD', 'secret')

def connect_db():
    while True:
        try:
            conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
            return conn
        except Exception as e:
            print("Esperando a la base de datos...")
            time.sleep(2)

@app.route('/')
def hello():
    return "Hola, saludos desde el container."

@app.route('/db')
def check_db():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("CREATE TABLE IF NOT EXISTS visitas (id SERIAL PRIMARY KEY, fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP);")
    cur.execute("INSERT INTO visitas DEFAULT VALUES;")
    cur.execute("SELECT COUNT(*) FROM visitas;")
    count = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return f"Conexión exitosa. Esta es la visita numero: {count}"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
