all:
	mkdir -p .outputs
	uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs

# Example: make with INPUT=example_cv.yaml
with:
	mkdir -p .outputs
	uv run cvgen filter $(INPUT) --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs

# Generate demo PDFs showcasing various filtering combinations
demo:
	@echo "Generating demo PDFs showcasing CVGen filtering capabilities..."
	@mkdir -p .demo
	
	@echo "  [1/8] Brief Korean CV (verbosity 1.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/01_brief_ko.pdf
	
	@echo "  [2/8] Brief English CV (verbosity 1.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/02_brief_en.pdf
	
	@echo "  [3/8] Standard Korean CV (verbosity 1.5)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/03_standard_ko.pdf
	
	@echo "  [4/8] Standard English CV (verbosity 1.5)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/04_standard_en.pdf
	
	@echo "  [5/8] Detailed Korean CV (verbosity 2.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/05_detailed_ko.pdf
	
	@echo "  [6/8] Detailed English CV (verbosity 2.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/06_detailed_en.pdf
	
	@echo "  [7/8] Clean English CV (no detail tags)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags 'detail' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/07_clean_en_no_tech_details.pdf
	
	@echo "  [8/8] Tech Details Only (detail tags only)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags 'detail' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/08_tech_details_only.pdf
	
	@rm -f .demo/temp.yaml .demo/*.typ .demo/*.png .demo/*.md .demo/*.html
	@echo ""
	@echo "✓ Demo complete! Generated 8 PDFs in .demo/ directory:"
	@echo "  • 01_brief_ko.pdf - Minimal Korean CV"
	@echo "  • 02_brief_en.pdf - Minimal English CV"
	@echo "  • 03_standard_ko.pdf - Standard Korean CV with medium details"
	@echo "  • 04_standard_en.pdf - Standard English CV with medium details"
	@echo "  • 05_detailed_ko.pdf - Full Korean CV with all content"
	@echo "  • 06_detailed_en.pdf - Full English CV with all content"
	@echo "  • 07_clean_en_no_tech_details.pdf - CV without technologies section"
	@echo "  • 08_tech_details_only.pdf - Only the technologies section"

clean:
	rm -rf .outputs .demo
