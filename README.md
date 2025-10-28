# CVGen Template

A template repository for creating multi-language, multi-version CVs using CVGen and RenderCV.

## Quick Start

```bash
# Install dependencies
uv sync

# Generate default Korean CV
make

# Generate CV from custom input file
make with INPUT=example_cv.yaml

# See all filtering capabilities in action
make demo

# Clean output directories
make clean
```

## What's Inside

- `example_cv.yaml` - Example CV demonstrating all CVGen features
- `CVGEN_REFERENCE.md` - Complete reference guide (English)
- `CVGEN_REFERENCE_ko.md` - Complete reference guide (Korean)
- `Makefile` - Build automation with demo command

## Demo

Run `make demo` to generate different CV versions showcasing:
- **Verbosity filtering**: Brief (1.0), standard (1.5), and detailed (2.0) versions
- **Multi-language**: Generate CVs in English and Korean
- **Tag-based filtering** _(alpha)_: Filter by content categories like academic or industry

All demo PDFs will be generated in the `.demo/` directory with descriptive filenames.

## Documentation

See [CVGEN_REFERENCE.md](CVGEN_REFERENCE.md) for complete documentation on how to use CVGen to create your own customizable CV.
