FROM python:3.11-slim

WORKDIR /app

# Copiar e instalar dependencias
COPY requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código de la app
COPY app/ .

# Puerto expuesto y usuario no-root por seguridad
EXPOSE 5000
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

CMD ["python", "app.py"]

