#!/bin/bash

function prepare_venv() {
    VIRTUALENV=$(which virtualenv) || :
    if [ -z "$VIRTUALENV" ]; then
        # python36 which is in CentOS does not have virtualenv binary
        VIRTUALENV=$(which virtualenv-3)
    fi

    ${VIRTUALENV} -p python3 venv && source venv/bin/activate && python3 "$(which pip3)" install radon==3.0.1
}

[ "$NOVENV" == "1" ] || prepare_venv || exit 1

radon cc -s -a -i venv .

if [[ "$1" == "--fail-on-error" ]]
then
    defects="$(radon cc -s -n D -i venv . | wc -l)"
    if [[ $defects -gt 0 ]]
    then
        echo "File(s) with too high cyclomatic complexity detected!"
        exit 1
    fi
fi
