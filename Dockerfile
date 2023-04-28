FROM python:3.10 AS base

## Avoid to write .pyc files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PYTHONUNBUFFERED 1

### Install compilation dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc

RUN pip install openai

WORKDIR /

COPY agoa.py ./

CMD [ "python3", "agoa.py"]