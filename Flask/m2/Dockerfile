FROM python:3.8-slim

WORKDIR /app

ADD . /app

RUN pip install -r requirements.txt

EXPOSE 5001

CMD ["python", "m2.py"]
