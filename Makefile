
PYTHON ?= python3

.PHONY: doc

.venv/bin/pip:
	${PYTHON} -m venv .venv
	.venv/bin/pip3 install --upgrade pip wheel

venv: .venv/bin/pip

dev: venv
	.venv/bin/pip3 install -e .[dev]

cs: venv
	.venv/bin/pylint pytest_httpserver
	.venv/bin/pycodestyle pytest_httpserver

mrproper: clean
	rm -rf dist

clean: cov-clean doc-clean
	rm -rf .venv *.egg-info build .eggs __pycache__ */__pycache__ .tox

quick-test:
	.venv/bin/pytest tests -s -vv

test:
	tox

test-pdb:
	.venv/bin/pytest tests -s -vv --pdb

cov: cov-clean
	.venv/bin/pytest --cov pytest_httpserver --cov-report=term --cov-report=html --cov-report=xml tests

cov-clean:
	rm -rf htmlcov

doc: .venv
	.venv/bin/sphinx-build -M html doc doc/_build $(SPHINXOPTS) $(O)

doc-clean:
	rm -rf doc/_build
