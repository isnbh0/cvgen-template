# CVGen Template

A template repository for creating multi-language, multi-version CVs using CVGen and RenderCV.

## Quick Start

```bash
# Install dependencies
uv sync

# Generate default Korean CV
make

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

Run `make demo` to generate 8 different CV versions showcasing:
- Different verbosity levels (brief, standard, detailed)
- Multi-language support (English and Korean)
- Tag-based filtering (with/without technical details)

All demo PDFs will be generated in the `.demo/` directory.

## Documentation

See [CVGEN_REFERENCE.md](CVGEN_REFERENCE.md) for complete documentation on how to use CVGen to create your own customizable CV.
