FROM python:latest
RUN touch index.html
RUN echo "Hello world! version4" > index.html
EXPOSE 7000
CMD python -m http.server 7000
