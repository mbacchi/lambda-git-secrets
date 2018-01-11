PHONY: build clean replacepy

# Borrowed some of this from:
# https://github.com/awslabs/aws-sam-local/blob/develop/samples/python-with-packages/Makefile
# And
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html

BASE := $(shell /bin/pwd)
PY_VER=3.6
ZIP_FILE := $(BASE)/repositoryscan.zip

build:
	python3.6 -m venv venv
	venv/bin/pip \
		--isolated \
		--disable-pip-version-check \
		install --no-binary :all: -Ur requirements.txt
	find venv -name "*.pyc" -exec rm -f {} \;
	zip -r -9 "$(ZIP_FILE)" repositoryscan.py
	cd venv/lib/python$(PY_VER)/site-packages \
		&& zip -r -9 "$(ZIP_FILE)" *
	cd venv/lib64/python$(PY_VER)/site-packages \
		&& zip -r -9 "$(ZIP_FILE)" *

replacepy:
	zip -r -9 "$(ZIP_FILE)" repositoryscan.py

clean:
	$(RM) ${ZIP_FILE}
	$(RM) -rf venv
