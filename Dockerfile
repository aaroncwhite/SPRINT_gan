FROM tensorflow/tensorflow:1.9.0-gpu-py3 as base
ARG DEV
# Make it easier to access jupyter
COPY docker/jupyter_notebook_config.py /root/.jupyter/

ENV \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PIPENV_HIDE_EMOJIS=true \
    PIPENV_COLORBLIND=true \
    PIPENV_NOSPIN=true \
    PYTHONPATH="/app:${PYTHONPATH}" \
    PIP_SRC="/src"

RUN pip install pipenv

WORKDIR /app
COPY Pipfile .
COPY Pipfile.lock .

RUN pipenv install --system --deploy --ignore-pipfile --dev

EXPOSE 8888
WORKDIR /app
