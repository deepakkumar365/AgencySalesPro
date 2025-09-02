# Dockerfile for AgencySalesPro
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps for common Python packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy application
COPY . /app

# Expose port and default env
ENV PORT=5000
EXPOSE 5000

# Use Gunicorn with the provided config
CMD ["gunicorn", "--config", "gunicorn_config.py", "main:app"]
