FROM python:3.7.9-slim-buster

ENV PYTHONUNBUFFERED 1
RUN mkdir -p /opt/services/backend/src

COPY Pipfile Pipfile.lock /opt/services/backend/src/
WORKDIR /opt/services/backend/src
RUN pip install pipenv && pipenv install --system

COPY . /opt/services/backend/src
RUN cd backend && python manage.py collectstatic --no-input

EXPOSE 8000
CMD ["gunicorn", "-c", "config/gunicorn/conf.py", "--bind", ":8000", "--chdir", "backend", "backend.wsgi:application"]
