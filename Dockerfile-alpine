FROM alpine
RUN apk update && apk upgrade
RUN apk add --update python3
RUN apk add py3-pip
RUN pip3 install flask
COPY . /app
WORKDIR /app
CMD python3 ./app.py 