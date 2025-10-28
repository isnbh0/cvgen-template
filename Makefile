all:
	mkdir -p .outputs
	uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs

# Example: make with INPUT=example_cv.yaml
with:
	mkdir -p .outputs
	uv run cvgen filter $(INPUT) --target-verbosity 1 --include-tags '' | uv run cvgen collapse -k ko > .outputs/output_ko.yaml && uv run rendercv render .outputs/output_ko.yaml -o .outputs

# Generate demo PDFs showcasing verbosity and multi-language support
demo:
	@echo "Generating demo PDFs showcasing CVGen capabilities..."
	@echo ""
	@mkdir -p .demo
	
	@echo "━━━ Verbosity Filtering Examples ━━━"
	@echo "  [1/8] Brief Korean CV (verbosity 1.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/01_brief_ko.pdf
	
	@echo "  [2/8] Standard English CV (verbosity 1.5)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/02_standard_en.pdf
	
	@echo "  [3/8] Detailed English CV (verbosity 2.0)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/03_detailed_en.pdf
	
	@echo ""
	@echo "━━━ Multi-Language Examples ━━━"
	@echo "  [4/8] Brief English CV..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/04_brief_en.pdf
	
	@echo "  [5/8] Standard Korean CV..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/05_standard_ko.pdf
	
	@echo "  [6/8] Detailed Korean CV..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
		uv run cvgen collapse -k ko > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/당신의_이름_CV.pdf .demo/06_detailed_ko.pdf
	
	@echo ""
	@echo "━━━ Tag-Based Filtering Examples (Alpha) ━━━"
	@echo "  [7/8] Academic CV (include academic tags)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 2 --include-tags 'academic' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/07_academic_only.pdf
	
	@echo "  [8/8] No Tech Details Section (exclude detail tags)..."
	@uv run cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags 'detail' | \
		uv run cvgen collapse -k en > .demo/temp.yaml && \
		uv run rendercv render .demo/temp.yaml -o .demo > /dev/null 2>&1 && \
		mv .demo/Your_Name_CV.pdf .demo/08_exclude_detail.pdf
	
	@rm -f .demo/temp.yaml .demo/*.typ .demo/*.png .demo/*.md .demo/*.html
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "✓ Demo complete! Generated 8 PDFs in .demo/ directory:"
	@echo ""
	@echo "Verbosity + Language Examples:"
	@echo "  • 01_brief_ko.pdf              - Brief CV in Korean (verbosity ≤ 1.0)"
	@echo "  • 02_standard_en.pdf           - Standard CV in English (verbosity ≤ 1.5)"
	@echo "  • 03_detailed_en.pdf           - Detailed CV in English (verbosity ≤ 2.0)"
	@echo "  • 04_brief_en.pdf              - Brief CV in English (verbosity ≤ 1.0)"
	@echo "  • 05_standard_ko.pdf           - Standard CV in Korean (verbosity ≤ 1.5)"
	@echo "  • 06_detailed_ko.pdf           - Detailed CV in Korean (verbosity ≤ 2.0)"
	@echo ""
	@echo "Tag-Based Filtering Examples (Alpha):"
	@echo "  • 07_academic_only.pdf         - Only academic content"
	@echo "  • 08_exclude_detail.pdf        - Without technologies section"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

clean:
	rm -rf .outputs .demo
