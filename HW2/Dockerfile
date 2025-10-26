# Use a small Python base image (works on Apple Silicon and Intel)
FROM python:3.12-slim

# Prevent Python from writing .pyc files / buffering logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Work directory inside the image
WORKDIR /app

# System deps (curl optional, handy for debugging)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl && rm -rf /var/lib/apt/lists/*

# Copy dependency list and install first (leverages Docker layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY . .

# Expose the Flask port (same as FLASK_RUN_PORT)
EXPOSE 35522

# Default: run with gunicorn (production-grade HTTP server)
# If your Flask app object is named "app" inside web_service.py, this works:
# app/web_service.py -> variable "app"
CMD ["gunicorn", "--bind", "0.0.0.0:35522", "HW2:app"]
