#!/bin/bash

    cd VIRTUALENV
    python -m venv $(pwd)
    source bin/activate

    pytest

    deactivate
