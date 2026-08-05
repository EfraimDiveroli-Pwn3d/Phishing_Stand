FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    libmilter-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pymilter

COPY gophish_milter.py /app/gophish_milter.py

RUN chmod +x /app/gophish_milter.py

CMD ["python3", "/app/gophish_milter.py"]