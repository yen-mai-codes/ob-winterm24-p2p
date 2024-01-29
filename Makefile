.PHONY: clean clean-build clean-src pylint ruff run test

.DEFAULT_GOAL := test

clean: clean-build clean-src

clean-build:
	@echo ">>> Cleaning build"
	rm -rf build

clean-src:
	@echo ">>> Cleaning source"
	find src/ -type d -name "__pycache__" -print0 | xargs -0 rm -rf

pylint:
	pylint --recursive=y src/*/py

ruff:
	ruff format
	ruff .

run:
	export PYTHONPATH=src/main/py; \
		python3 -m peer.peer 50000 "src/test/py/resources/peer_test" "127.0.0.1:50000"

test: ruff pylint
	export PYTHONPATH=src/main/py; \
	    coverage run -m unittest discover --pattern "*_test.py" \
		  --start-directory src/test/py \
		  --top-level-directory .
	coverage report
	coverage html
