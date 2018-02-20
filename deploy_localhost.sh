#!/bin/bash
export PYTHONDONTWRITEBYTECODE='dontwrite'
ROOT=`dirname "${BASH_SOURCE[0]}"`
act="${ROOT}/.venv/bin/activate"

if [ ! -f "${act}" ]; then
    set -e
    virtualenv -p python3.6 .venv
    source ${act}
    pip install pip raven --upgrade
    pip install -r requirements.txt
    set +e
else
    source ${act}
fi

update-rc.d supervisor enable
service supervisor stop

pip install -r requirements.txt
cp supervisor.conf /etc/supervisor/conf.d/EthermineTelegramBots.conf

supervisorctl reread
supervisorctl update
service supervisor start
supervisorctl status

ARGS="$@"
if [ -n "${ARGS}" ]; then
    cd ${ROOT}
    exec $@
fi
