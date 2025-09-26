.PHONY: help install dev lint test run clean
help:                 ## show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*## .*$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
venv:                 ## create virtualenv if it does not exist
	uv venv --seed .venv
install: venv         ## install all dependencies
	uv pip install --python .venv/bin/python -U pip
	uv pip install --python .venv/bin/python -r requirements/base.txt
	uv pip install --python .venv/bin/python -r requirements/dev.txt
	uv pip install --python .venv/bin/python -r requirements/test.txt
	uv pip install --python .venv/bin/python -e .
lint:                 ## run ruff check + format
	.venv/bin/ruff check .
	.venv/bin/ruff format .
test:                 ## run tests with coverage
	.venv/bin/pytest
run:                  ## start hot-reload server
	.venv/bin/uvicorn src.app.main:app --reload --host 0.0.0.0 --port 8000
dev: install lint test run   ## one-shot full dev cycle (default target)
.DEFAULT_GOAL := dev
clean:                ## remove caches and build artefacts
	find . -type d -name __pycache__ | xargs rm -rf
	rm -rf .pytest_cache .coverage htmlcov dist *.egg-info