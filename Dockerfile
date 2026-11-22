# =====================================================================
# EMS BANQUET CLOUD DOCKERFILE (Hỗ trợ Google Cloud Run Free 1C & VPS Paid 2A)
# =====================================================================
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    EMS_DB_MODE=google_sheets \
    PORT=8080

WORKDIR /app

# Cài đặt các gói hệ thống cơ bản & ODBC Driver (hỗ trợ cả Google Sheets lẫn SQL Server)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unixodbc unixodbc-dev gcc g++ \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY . /app/

EXPOSE 8080 5090 5088 5092

CMD ["python", "cloud_gateway.py"]
