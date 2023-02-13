#!/usr/bin/env sh

# shellcheck disable=SC1091,SC2034,SC2086,SC2153,SC2236,SC3037,SC3045,SC2046

if [ "$(uname -s)" = "Darwin" ]; then
	export VENV=".venv"
else
	export VENV="/opt/venv"
fi
export PATH="${VENV}/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

# . "${VENV}/bin/activate"

# TODO: cleanup (case statement?)
port_check() {
	if [ ! -z "$1" ] && [ -z "$(lsof -i :$1 | grep LISTEN | awk '{print $2}')" ]; then
		PORT="$1"
	elif [ ! -z "$1" ] && [ ! -z "$(lsof -i :$1 | grep LISTEN | awk '{print $2}')" ]; then
		PORT=$(($1+1))
		echo "Port $1 is in use, trying $PORT"
		while [ ! -z "$(lsof -i :$PORT | grep LISTEN | awk '{print $2}')" ]; do
			echo "Port $PORT is in use, trying $((PORT+1))"
			PORT=$((PORT+1))
		done
		echo "Port $PORT is available. Using it instead of $1"
	else
		echo "Failed to find available port. $1 is in use. Exiting... "
		exit 1
	fi
}

main() {
	port_check "$@"
	gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app -b "0.0.0.0:${PORT:-3000}" --log-file -
}
main "$@"
