FROM python:2.7-alphine
RUN mkdir /app
WORKDIR /app
copy requirement.txt requirement.txt
RUN pip install -r requirements.txt
COPY . .
CMD python app.py
