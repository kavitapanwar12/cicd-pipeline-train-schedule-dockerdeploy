FROM python:2.7-alpine
RUN mkdir /app
WORKDIR /app
copy requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
ENTRYPOINT ["python"]
CMD ["app.py"]
