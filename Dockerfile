FROM python:latest
RUN touch index.html
RUN echo "Hello world! from version6" > index.html
EXPOSE 7000
CMD python -m http.server 7000
