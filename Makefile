.DEFAULT_GOAL := lint
isort = isort -rc -w 88 flask_prometheus_metrics tests
black = black -l 88 --target-version py37 flask_prometheus_metrics tests


.PHONY: install
install:
	pip install -U pip setuptools wheel twine
	pip install -U -r requirements.txt
	pip install -e .


.PHONY: format
format:
	$(isort)
	$(black)


.PHONY: lint
lint:
	python setup.py check -rms
	flake8 flask_prometheus_metrics
	$(isort) --check-only
	$(black) --check


.PHONY: test
test:
	pytest -vvs --cov=flask_prometheus_metrics tests
	mypy flask_prometheus_metrics


.PHONY: run
run:
	python -m flask_prometheus_metrics.example


.PHONY: build
build:
	python setup.py sdist bdist_wheel


.PHONY: push-test
push-test:
	python -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*


.PHONY: push
push:
	python -m twine upload dist/*


.PHONY: clean
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	python setup.py clean
