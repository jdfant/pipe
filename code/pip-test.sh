#!/bin/bash

    cd VIRTUALENV
    python3 -m venv $(pwd)
    source bin/activate

    pytest

    deactivate
