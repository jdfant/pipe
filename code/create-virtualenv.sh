#!/bin/bash

    mkdir -p VIRTUALENV
    cd VIRTUALENV
    #pip3 install virtualenv
    python3 -m venv $(pwd)
    source bin/activate
    pip3 install -U pip 2>/dev/null
    pip3 install -U setuptools 2>/dev/null
    pip3 install -r ../files/req.txt

    deactivate
