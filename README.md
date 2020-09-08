# 🖥️ Django Docker Dojo 🎉

## Introduction
Django Docker Dojo is a starter project for building a Dockerised, API-driven web application using Django, Django Rest Framework, PostgreSQL, Celery, Gunicorn & Nginx, served to a decoupled ReactJS front-end.

It's an intentionally simple starter project. Out of the box, it assumes a single database, a single application layer, and a single, de-coupled front-end, although it could be fairly easily modified to handle a more complex architecture. Equally, it could be simplified by removing services that are surplus to requirements!

## Requirements
You'll need to install [Docker][] and [Docker-Compose][] before the system will work. You'll want the most recent versions of both for your development machine. This system hasn't been tested on anything beyond Mac OS Catalina 10.15.6, but it's probably safe to assume it will work without issue on other Unix-based systems, although you might need to tweak it a little if you run into any trouble. (It would be extremely surprising to me if it worked in any capacity on Windows environments and I would probably recommend just not putting yourself through that.)

## The Build
This project builds what is essentially a multi-container Docker Compose configuration that sets up
a number of containers, each based on an appropriate image. It includes:

- A [Django][] container, for the back-end application layer.
- A [Postgres][] container, for the database.
- An [NginX][] container as the reverse proxy & static fileserver. Static and media files are
  persisted stored in appropriate volumes within the container.
- We use [ReactJS][] on the front-end through a dedicated Node-based container.
- We use [Gunicorn][] to serve the Django application, through WSGI.
- We use [Celery][] to handle long-running, or scheduled jobs.
- We use [Redis][] as the message queue for the Celery schedule.

### Notes

- [Python][] dependencies are managed through [pipenv][], using `Pipfile` for requirements, and
`Pipfile.lock` to lock dependencies.
- Tests are run using [tox][], [pytest][], and some other tools - including [safety][], [bandit][], [isort][] and [prospector][]. (You may want to remove this test suite and replace it with your own test suite of choice if you have your own preference.)

## Some hopefully helpful, pre-configured stuff
The system is not particularly opinionated - but it does come pre-made with the tools you'll need to build an API-driven Django & ReactJS application, with scheduled background workers. So based on that premise, a set of pre-configurations have been made, including some light examples of how to get a system like this one running (sending a request from ReactJS to Django,
for example).

The main pre-configurations are:

* [Django][] is pre-installed with [Django Rest Framework][], which provides the facility for you to build your API endpoints.
* [Django CORS Headers][] is also pre-installed, which allows you to make requests to those endpoints from any decoupled frontend, otherwise the requests will be rejected by Django's security mechanisms. You'll need to update the CORS settings in `settings.py`if you want to add other hosts.
* An extremely simple Django / DRF app called 'Items' is pre-built - it's a tiny model with a read-only DRF API view and serializer that sends a 3-field JSON object to a URL for consumption by the front-end.
* A simple ReactJS 'Items' component requests the Items API every 3 seconds from the front-end using `fetch`.
* [Celery][] has been pre-installed, which runs on a Worker container - which allows you to hand long-running
tasks (or scheduled jobs) to Celery. It uses Redis as a message queue so it can handle massive volumes of tasks if needed.
* An example scheduled Celery task has been set up, which can be used as skeleton for future tasks. You can actually run this
on the back-end using `make startbeat` once the build is completed, your database has data in it (there are fixtures for this)
and all of your containers are running. This will run the task every 5 seconds, updating the data. The front-end will then consume
the new data. Real-time stuff!
* Gunicorn serves the application through the `wsgi.py` file in `/backend`
* Nginx serves the project's static files.


The project is designed to mostly be administered through a provided `Makefile` in the root directory that provides a
number of simple but very convenient shortcuts to the most common commands and workflows that we tend to use with Django projects. Good news - these commands can be easily extended by adding new Make targets specific to your application, following the pattern within the Makefile!


## The makefile
A [Makefile][] is a file of pre-made CLI commands proxied through the `make` command so you have a single, consistent interface by which you can manage otherwise unwieldy commands from different software products and services. The aforementioned Makefile is included to help make developing your Django application faster, simpler and more fun. (Be aware - in some instances, you may need to use `sudo make` instead of just calling `make` - because the `docker` and `docker-compose` commands occasionally need admin rights, depending on what you're doing. If your Make commands fail, despite the syntax being correct that might be why.)

The syntax looks like `make <command>` (without the brackets). A full list of commands can be found
within the Makefile itself, I highly recommend checking it out!


## Getting the system running
The simplest way to get this stack of containers working is to use the commands in the
included Makefile, which will do everything for you. 

The workflow should be as simple as:

* First, build everything: `make build` (This will build everything and start
all of the containers)
* Then, run the first load - which will migrate the database, create a Django admin 
user, and prompt you for a password for that user: `make firstload`
* Then, you can load the system with data, through attached fixtures - 
you'll just need to specify which apps you want to load, for example:
`make loaddata APP=items`
* You should then be able to visit http://127.0.0.1:8000/admin/, log in with the
name 'admin' and the password you specified - and then you'll have access to 
the backend.
* The system runs on a main, scheduled Celery Beat task. The build process
does not start this task automatically and you can easily start it manually with
`make startbeat`. This will immediately start processing the data that you have
previously loaded (and it will probably fail if the database is empty).
* If your static files haven't loaded for some unknown reason (everything is 
unstyled, or missing CSS, just run `make collectstatic`, which will fix it for you.


## Removing things you don't need
You can, of course, rip out any of the stuff you don't need from this starter project, and you'll almost
certainly want to do that with the Django 'Items' app, as well as any dependencies that you don't actually need. You'll just need to:

* Remove any of the directories and files that are surplus to requirements
* Update the Django settings file to reflect anything you've removed (Celery dictionaries, for example)
* Run `make uninstall PKG=` for any of the dependencies you don't need (more details in the Makefile)
* Run `make install PKG=` for any new dependencies you do need (more details in the Makefile)
* Run `make piplock` to re-lock your requirements, after you've installed what you need

If you don't need a completely decoupled ReactJS front-end, you can just remove the entire 'frontend' directory
and set up your Django project with either a) A different frontend or b) As a vanilla Django project, using your
choice of template handler, as per the documentation.

#### Note:
There are a lot of Make utilities in the Makefile that will cover pretty much
all of the regular Django manage.py developmental workflow stuff you need. It's
written as a simple wrapper around the regular `docker exec` style commands - 
but it will save you a lot of typing, so take a look at that for some 
very handy shortcuts.

### Alternatively, regular Docker
Alternatively, if you prefer the more traditional Docker commands, you can of course
just use the regular commands, for example:

* `docker-compose build`
* `docker-compose run --rm djangoapp roguetrader/manage.py migrate`
* `docker-compose run --rm djangoapp hello/manage.py collectstatic --no-input'`

(This is, however, quite a lot of typing)

## Running the tests
To run the full test suite, simply run:

- `make runtests`

(This will both install the test suite and run it all.)

Other test utilities are also available:

- `make checksafety` (Checks for security holes or pre-deployment issues.)
- `make checkstyle` (Checks for code style.)
- `make coverage` (Reports code coverage.)

## Predeploy
Before deploying, you can run a `clean` as well as the testsuite by running:

- `make predeploy`

This should give you an actionable list of things to take care of before
redeploying.

Before deployment, as always, make sure to remove your secrets from version control (remove the
`config` directory from VCS), and only make sure that DB, Nginx & Gunicorn settings are 
set up in production, (and stored securely in development).

[Celery]: https://docs.celeryproject.org/en/latest/django/first-steps-with-django.html
[Docker]: https://www.docker.com/
[Django]: https://www.djangoproject.com/
[Django CORS Headers]: https://github.com/adamchainz/django-cors-headers
[Django REST Framework]: https://www.django-rest-framework.org/
[Gunicorn]: http://gunicorn.org/
[NginX]: https://www.nginx.com/
[Postgres]: https://www.postgresql.org/
[Python]: https://www.python.org/
[pipenv]: https://docs.pipenv.org/
[tox]: https://tox.readthedocs.io/en/latest/
[pytest]: https://docs.pytest.org/en/latest/
[safety]: https://pyup.io/safety/
[bandit]: https://github.com/openstack/bandit
[isort]: https://github.com/timothycrosley/isort
[prospector]: https://github.com/landscapeio/prospector
[GitLab]: https://about.gitlab.com/
[ReactJS]: https://reactjs.org/
[Makefile]: https://www.gnu.org/software/make/manual/make.html
[Docker-Compose]: https://docs.docker.com/compose/
