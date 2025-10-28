all:
	mkdir -p .outputs
	uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs

# Example: make with INPUT=example_cv.yaml
with:
	mkdir -p .outputs
	uv run cvgen filter $(INPUT) --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs
