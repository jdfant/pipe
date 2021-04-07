#!/bin/bash

    mkdir -p VIRTUALENV
    cd VIRTUALENV
    #pip3 install virtualenv
    python -m venv $(pwd)
    source bin/activate
    pip install -U pip 2>/dev/null
    pip install -U setuptools 2>/dev/null
    pip install -r ../files/req.txt

    deactivate
