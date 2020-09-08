.PHONY: docs springclean

# Generic declarations
PROJECT = backend
INSTALL = pip install

# Sets commands for individual containers
BACKEND_CMD = docker-compose run --rm backend /bin/bash -c
WORKER_CMD = docker-compose run --rm worker /bin/bash -c
DATABASE_CMD = docker-compose exec db bash -c

# Includes and exports environment variables for Database
include config/db/db_env
export

# Build & run tools
build:
	docker-compose build
	docker-compose up

up:
	docker-compose up

down:
	docker-compose down

fullrebuild:
	docker-compose down --rmi local -v
	docker-compose build --no-cache
	docker-compose up

# DATABASE - Migration & DB tools
planmigrations:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py migrate --plan;"

makemigrations:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py makemigrations;"

migrate:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py migrate;"

firstload: makemigrations migrate createadmin

# Loads fixtures
loaddata:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py loaddata $(APP);"

startbeat:
	$(WORKER_CMD) "celery worker -B -A backend;"

# WARNING - This drops and rebuilds your local db from scratch
rebuilddb:
	$(DATABASE_CMD) "PGUSER=$(POSTGRES_USER) PGPASSWORD=$(POSTGRES_PASSWORD) dropdb $(POSTGRES_DB);"
	$(DATABASE_CMD) "PGUSER=$(POSTGRES_USER) PGPASSWORD=$(POSTGRES_PASSWORD) createdb $(POSTGRES_DB)"
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py migrate;"

psqlshell:
	$(DATABASE_CMD) "PGUSER=$(POSTGRES_USER) PGPASSWORD=$(POSTGRES_PASSWORD) psql $(POSTGRES_DB)"

# GENERAL - General purpose tools
createadmin:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py createsuperuser --username admin --email admin@admin.com;"

createsuperuser:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py createsuperuser;"

# This accepts any manage.py argument passed through it by ARG1= on the command
# line - for example: make manage ARG1=migrate ARG2=--plan
# (This is useful for all of the less common manage.py tools you might need)
manage:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py $(ARG1) $(ARG2);"

# This accepts any pipenv install package passed to it by PKG on the command
# line - for example: make install PKG=djangorestframework
install:
	$(BACKEND_CMD) "cd $(PROJECT); pipenv install $(PKG);"

piplock:
	$(BACKEND_CMD) "cd $(PROJECT); pipenv lock;"

uninstall:
	$(BACKEND_CMD) "cd $(PROJECT); pipenv uninstall $(PKG);"

collectstatic:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py collectstatic --no-input;"

djangoshell:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py shell;"

startapp:
	$(BACKEND_CMD) "cd $(PROJECT); ./manage.py startapp;"

# TEST - Testing tools
check: checksafety checkstyle

checksafety:
	$(BACKEND_CMD) "$(INSTALL) tox && tox -e checksafety"

checkstyle:
	$(BACKEND_CMD) "$(INSTALL) tox && tox -e checkstyle"

coverage:
	$(BACKEND_CMD) "$(INSTALL) tox && tox -e coverage"

runtests:
	$(BACKEND_CMD) "$(INSTALL) tox && tox -e test"

django-version:
	$(BACKEND_CMD) "cd $(PROJECT); python3 -m django --version;"

predeploy: springclean runtests

# Maintenance & cleanup tools
springclean:
	rm -rf build
	rm -rf backend.egg-info
	rm -rf dist
	rm -rf htmlcov
	rm -rf .tox
	rm -rf .cache
	rm -rf .pytest_cache
	find . -type f -name "*.pyc" -delete
	rm -rf $(find . -type d -name __pycache__)
	rm .coverage
	rm .coverage.*

dockerclean:
	docker system prune -f
	docker system prune -f --volumes

bigclean: springclean dockerclean