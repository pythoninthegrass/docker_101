#!/usr/bin/env sh

# shellcheck disable=SC1091,SC2034,SC2153,SC2236,SC3037,SC3045,SC2046

if [ "$(uname -s)" = "Darwin" ]; then
	export VENV=".venv"
else
	export VENV="/opt/venv"
fi
export PATH="${VENV}/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

# . "${VENV}/bin/activate"

main() {
	if [ ! -z "$1" ]; then
		PORT="$1"
	fi
	gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app -b "0.0.0.0:${PORT:-3000}" --log-file -
}
main "$@"
