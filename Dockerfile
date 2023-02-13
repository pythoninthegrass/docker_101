FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc python3-dev -y
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.3.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# map port 3000 to host
EXPOSE 3000

# ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
# CMD ["gunicorn", "-c", "gunicorn.conf.py", "main:app"]
CMD ["/bin/sh", "startup.sh"]
# CMD ["/bin/bash"]
