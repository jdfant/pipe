#!/bin/bash

    cd VIRTUALENV
    virtualenv $(pwd)
    source bin/activate

    pytest

    deactivate
