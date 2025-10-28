# CVGen Reference: Extending RenderCV YAML

This document describes the cvgen-specific extensions to RenderCV's YAML syntax. **CVGen is a preprocessor tool that provides a superset of RenderCV's YAML syntax**, adding multi-language support, content filtering by verbosity, and tagging capabilities. CVGen processes your extended YAML files and outputs standard RenderCV YAML, which is then rendered by RenderCV itself.

**Relationship:** CVGen extends RenderCV, it doesn't replace it. You write your CV in CVGen's extended YAML format, process it with `cvgen filter` and `cvgen collapse`, and the output is fed to `rendercv` for final PDF generation.

## Table of Contents

1. [Configuration Sections](#configuration-sections)
2. [Multi-Language Support](#multi-language-support)
3. [Verbosity System](#verbosity-system)
4. [Content Wrapping](#content-wrapping)
5. [Tagging System](#tagging-system)
6. [Processing Pipeline](#processing-pipeline)
7. [Migration Guide](#migration-guide)

---

## Configuration Sections

CVGen adds two configuration sections to the top-level `cv` object:

### `multi_lang_config`

Defines the languages supported in your CV and the default language.

```yaml
cv:
  multi_lang_config:
    lang_keys:
      - en
      - ko
    default_lang: en
```

**Fields:**
- `lang_keys`: List of language codes (e.g., `en`, `ko`, `es`, `fr`)
- `default_lang`: The default language to use if no language is specified during processing

### `filter_config`

Defines the keys used for content wrapping and verbosity filtering.

```yaml
cv:
  filter_config:
    content_key: content
    verbosity_key: verbosity
```

**Fields:**
- `content_key`: The key name used to wrap content (default: `"content"`)
- `verbosity_key`: The key name used for verbosity values (default: `"verbosity"`)

---

## Multi-Language Support

CVGen allows you to define multiple translations for any string field using a dictionary with language codes as keys.

### Basic String Fields

**RenderCV syntax:**
```yaml
cv:
  name: "Your Name"
  location: "Your Location"
```

**CVGen syntax:**
```yaml
cv:
  name:
    en: "Your Name"
    ko: "당신의 이름"
  location:
    en: "Your Location"
    ko: "당신의 위치"
```

### In Section Entries

**RenderCV syntax:**
```yaml
education:
  - institution: "University of Pennsylvania"
    area: "Computer Science"
    degree: "BS"
```

**CVGen syntax:**
```yaml
education:
  - institution:
      en: "University of Pennsylvania"
      ko: "펜실베이니아 대학교"
    area:
      en: "Computer Science"
      ko: "컴퓨터 과학"
    degree:
      en: "BS"
      ko: "학사"
```

### In Lists (Highlights, Authors, etc.)

**RenderCV syntax:**
```yaml
highlights:
  - "Reduced time to render user buddy lists by 75%"
  - "Integrated iChat with Spotlight Search"
```

**CVGen syntax:**
```yaml
highlights:
  - en: "Reduced time to render user buddy lists by 75%"
    ko: "예측 알고리즘을 구현하여 사용자 친구 목록 렌더링 시간을 75% 단축"
  - en: "Integrated iChat with Spotlight Search"
    ko: "저장된 채팅 기록에서 메타데이터를 추출하고 시스템 전체 검색"
```

### Language-Agnostic Fields

Some fields remain the same across languages (dates, URLs, DOIs, etc.):

```yaml
experience:
  - company:
      en: "Apple"
      ko: "애플"
    start_date: 2005-06  # No translation needed
    end_date: 2007-08    # No translation needed
```

---

## Verbosity System

The verbosity system allows you to include or exclude content based on a target verbosity level. This is useful for creating different versions of your CV (e.g., short, medium, detailed).

### Verbosity Levels

- **Lower values** (e.g., `1.0`): Essential content that appears in all versions
- **Higher values** (e.g., `2.0`, `3.0`): Optional content that only appears in detailed versions
- **Decimal values** (e.g., `1.5`): Intermediate levels for fine-grained control

### Item-Level Verbosity

**Basic syntax:**
```yaml
highlights:
  - content:
      en: "Essential highlight"
      ko: "필수 하이라이트"
    verbosity: 1.0
  - content:
      en: "Detailed highlight"
      ko: "상세 하이라이트"
    verbosity: 2.0
```

When filtering with `--target-verbosity 1`, only items with `verbosity <= 1.0` are included.

### Section-Level Verbosity

Entire sections can have verbosity levels:

```yaml
sections:
  welcome_to_RenderCV!:
    - content:
        en: "Basic intro"
        ko: "기본 소개"
      verbosity: 1.0
    - content:
        en: "Extended intro"
        ko: "확장 소개"
      verbosity: 2.0
```

### Nested Verbosity

You can apply verbosity at multiple levels:

```yaml
experience:
  - company:
      en: "Microsoft"
      ko: "마이크로소프트"
    highlights:
      - content:
          en: "Core achievement"
          ko: "핵심 업적"
        verbosity: 1.0
      - content:
          en: "Additional achievement"
          ko: "추가 업적"
        verbosity: 1.5
      - content:
          en: "Minor detail"
          ko: "세부 사항"
        verbosity: 2.0
```

### Verbosity on Complex Structures

For fields that have their own sub-fields, wrap the content:

```yaml
education:
  - institution:
      en: "University of Pennsylvania"
      ko: "펜실베이니아 대학교"
    highlights:
      content:
        - en: 'GPA: 3.9/4.0'
          ko: '학점: 3.9/4.0'
        - content:
            en: '**Coursework:** Computer Architecture'
            ko: '**수강 과목:** 컴퓨터 아키텍처'
          verbosity: 2.0
      verbosity: 1.0
```

---

## Content Wrapping

Content wrapping allows you to add metadata (like verbosity) to any item by wrapping it in a `content` object.

### Simple Wrapping

**Without wrapping:**
```yaml
highlights:
  - "Some text"
```

**With wrapping:**
```yaml
highlights:
  - content: "Some text"
    verbosity: 1.0
```

### Multi-Language + Wrapping

```yaml
highlights:
  - content:
      en: "English text"
      ko: "한국어 텍스트"
    verbosity: 1.5
```

### Wrapping Lists

When a field expects a list, you can wrap the entire list:

```yaml
technologies:
  content:
    - content:
        label:
          en: "Languages"
          ko: "언어"
        details:
          en: "C++, Java, Python"
          ko: "C++, Java, Python"
      verbosity: 1.0
  verbosity: 1.0
```

### Wrapping Sections

Entire sections can be wrapped:

```yaml
sections:
  publications:
    content:
      - title:
          en: "Research Paper"
          ko: "연구 논문"
        authors:
          - en: "John Doe"
            ko: "존 도"
    verbosity: 1.0
```

---

## Tagging System

> **⚠️ Alpha Feature:** The tagging system is currently in alpha. The API and behavior may change in future releases.

Tags allow you to categorize and filter content based on arbitrary labels.

### Section Tags

```yaml
sections:
  technologies:
    content:
      - label:
          en: "Languages"
          ko: "언어"
        details:
          en: "C++, Java"
          ko: "C++, Java"
    tags: ["detail"]
```

### Using Tags with Filtering

Tags can be used with the `cvgen filter` command:

```bash
# Include only items with "detail" tag (e.g., technologies section in example_cv.yaml)
cvgen filter example_cv.yaml --include-tags "detail" | \
  cvgen collapse -k en > output_detailed.yaml

# Exclude items with "detail" tag (cleaner CV without detailed tech lists)
cvgen filter example_cv.yaml --exclude-tags "detail" | \
  cvgen collapse -k en > output_minimal.yaml

# Combine with verbosity filtering
cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags "detail" | \
  cvgen collapse -k ko > output_medium_ko.yaml
```

**Note:** In `example_cv.yaml`, the `technologies` section has `tags: ["detail"]`, which allows you to include or exclude it based on your needs.

---

## Processing Pipeline

CVGen processes your CV in two stages:

### 1. Filter (`cvgen filter`)

Filters content based on verbosity and tags:

```bash
cvgen filter example_cv.yaml \
  --target-verbosity 1 \
  --include-tags '' \
  > filtered.yaml
```

**Options:**
- `--target-verbosity`: Include only items with verbosity ≤ this value
- `--include-tags`: Comma-separated list of tags to include (empty string means no tag filtering)
- `--exclude-tags`: Comma-separated list of tags to exclude

### 2. Collapse (`cvgen collapse`)

Collapses multi-language fields to a single language:

```bash
cvgen collapse filtered.yaml -k ko > output_ko.yaml
```

**Options:**
- `-k, --lang-key`: Language code to extract (e.g., `en`, `ko`)

### Combined Pipeline

```bash
cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
  cvgen collapse -k ko > output_ko.yaml
```

### Integration with RenderCV

After processing with cvgen, the output is **standard RenderCV YAML** that can be directly consumed by RenderCV:

```bash
# The output from cvgen collapse is now pure RenderCV YAML
rendercv render output_ko.yaml -o .outputs
```

**Key Point:** At this stage, all CVGen-specific syntax (multi-language dictionaries, verbosity metadata, tags, etc.) has been removed. The file is now a standard RenderCV YAML file that RenderCV can process natively.

---

## Migration Guide

### Converting RenderCV to CVGen

#### Step 1: Add Configuration Sections

Add to the top of your `cv:` section:

```yaml
cv:
  multi_lang_config:
    lang_keys:
      - en  # Add more languages as needed
    default_lang: en
  filter_config:
    content_key: content
    verbosity_key: verbosity
```

#### Step 2: Add Multi-Language Support

For each string field you want to translate:

**Before:**
```yaml
name: "Your Name"
```

**After:**
```yaml
name:
  en: "Your Name"
  ko: "당신의 이름"
```

#### Step 3: Add Verbosity Levels

Wrap items you want to control with verbosity:

**Before:**
```yaml
highlights:
  - "Essential item"
  - "Optional detail"
```

**After:**
```yaml
highlights:
  - content:
      en: "Essential item"
      ko: "필수 항목"
    verbosity: 1.0
  - content:
      en: "Optional detail"
      ko: "선택적 세부사항"
    verbosity: 2.0
```

#### Step 4: (Optional) Add Tags

Add tags to sections you want to filter:

```yaml
sections:
  technologies:
    content:
      - label: "Languages"
        details: "Python, Java"
    tags: ["technical"]
```

#### Step 5: Update Your Build Process

Replace direct RenderCV calls with the CVGen pipeline:

**Before:**
```bash
rendercv render cv.yaml
```

**After:**
```bash
# Generate English version
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k en | \
  rendercv render - -o outputs/en

# Generate Korean version
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k ko | \
  rendercv render - -o outputs/ko
```

### Common Patterns

#### Pattern 1: Different Verbosity Levels for Different Roles

```yaml
experience:
  - company: "Apple"
    position: "Senior Engineer"
    highlights:
      - content: "Led team of 5"
        verbosity: 1.0  # Always show
      - content: "Implemented feature X"
        verbosity: 1.5  # Medium detail
      - content: "Fixed 50+ bugs"
        verbosity: 2.0  # High detail
```

#### Pattern 2: Language-Specific Highlights

```yaml
highlights:
  - content:
      en: "Worked in international team"
      ko: "국제 팀에서 근무하며 한국어와 영어로 협업"
    verbosity: 1.0
```

#### Pattern 3: Tagged Sections for Different CV Types

```yaml
sections:
  research_projects:
    content:
      - name: "ML Research"
    tags: ["academic"]
  
  industry_projects:
    content:
      - name: "Production System"
    tags: ["industry"]
```

Then generate different versions:

```bash
# Academic CV
cvgen filter example_cv.yaml --include-tags "academic" | \
  cvgen collapse -k en > output_academic.yaml

# Industry CV
cvgen filter example_cv.yaml --include-tags "industry" | \
  cvgen collapse -k en > output_industry.yaml
```

---

## Examples

### Example 1: Minimal CVGen Document

```yaml
cv:
  multi_lang_config:
    lang_keys: [en, ko]
    default_lang: en
  filter_config:
    content_key: content
    verbosity_key: verbosity
  
  name:
    en: "John Doe"
    ko: "존 도"
  
  sections:
    experience:
      - company:
          en: "Tech Corp"
          ko: "테크 코프"
        position:
          en: "Engineer"
          ko: "엔지니어"
        start_date: 2020-01
        end_date: present

design:
  theme: classic
```

### Example 2: Full-Featured Entry

```yaml
experience:
  - company:
      en: "Microsoft"
      ko: "마이크로소프트"
    position:
      en: "Software Engineer Intern"
      ko: "소프트웨어 엔지니어 인턴"
    location:
      en: "Redmond, WA"
      ko: "워싱턴주 레드몬드"
    start_date: 2003-06
    end_date: 2003-08
    highlights:
      - content:
          en: "Designed UI for VS open file switcher"
          ko: "VS 오픈 파일 전환기용 UI를 설계"
        verbosity: 1.0
      - content:
          en: "Created service to provide gradient across VS"
          ko: "VS 전반에 걸쳐 그래디언트를 제공하는 서비스를 만들고"
        verbosity: 1.5
      - content:
          en: "Reduced algorithm from O(n²) to O(n log n)"
          ko: "알고리즘을 O(n²)에서 O(n log n)으로 개선"
        verbosity: 2.0
```

---

## Practical Examples with example_cv.yaml

The `example_cv.yaml` file included in this template demonstrates all CVGen features. Here are practical use cases:

### Generate Different Verbosity Levels

```bash
# Brief CV (only verbosity 1.0 items)
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k en > output_brief_en.yaml

# Standard CV (verbosity up to 1.5)
cvgen filter example_cv.yaml --target-verbosity 1.5 | \
  cvgen collapse -k en > output_standard_en.yaml

# Detailed CV (all items, verbosity 2.0)
cvgen filter example_cv.yaml --target-verbosity 2 | \
  cvgen collapse -k en > output_detailed_en.yaml
```

### Generate Multi-Language Versions

```bash
# Korean version with medium detail
cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
  cvgen collapse -k ko > output_medium_ko.yaml

# English version without technical details section
cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags "detail" | \
  cvgen collapse -k en > output_clean_en.yaml
```

### Combined Filtering

```bash
# Brief Korean CV without detailed tech section
cvgen filter example_cv.yaml --target-verbosity 1 --exclude-tags "detail" | \
  cvgen collapse -k ko | \
  rendercv render - -o outputs/brief_ko

# Full English CV with all details
cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
  cvgen collapse -k en | \
  rendercv render - -o outputs/full_en
```

### Use with Make

The included `Makefile` shows how to automate the build process:

```makefile
# Build default Korean CV
make

# Build with custom input file
make with INPUT=my_cv.yaml

# Generate demo PDFs showcasing all filtering capabilities
make demo

# Clean output directories
make clean
```

The `make demo` command generates 8 different PDFs in the `.demo/` directory, organized into categories:

**Verbosity + Language Examples:**
- Brief, standard, and detailed versions in both English and Korean
- Showcases how verbosity filtering (1.0, 1.5, 2.0) works across languages

**Tag-Based Filtering Examples (Alpha):**
- Academic-only CV (showing tag inclusion)
- CV without technologies section (showing tag exclusion)

This demonstrates the core CVGen features: multi-language support and verbosity filtering, with a glimpse of the alpha tagging system!

---

## Summary of Key Differences

**Important:** CVGen is not an alternative to RenderCV. Instead, CVGen provides a **superset of RenderCV's YAML syntax** that can be "compiled" into standard RenderCV YAML based on your configuration needs. The workflow is:

```
CVGen YAML (extended syntax) → [cvgen filter] → [cvgen collapse] → RenderCV YAML (standard syntax) → [rendercv] → PDF
```

| Feature | RenderCV YAML | CVGen Extended YAML |
|---------|---------------|---------------------|
| Multi-language | ❌ Single language per file | ✅ Multiple languages in one file via dictionaries |
| Verbosity filtering | ❌ No built-in filtering | ✅ Numeric levels (1.0, 1.5, 2.0...) |
| Content wrapping | ❌ No metadata support | ✅ `content` + `verbosity` pattern |
| Tagging | ❌ No tagging system | ✅ `tags: ["tag1", "tag2"]` |
| Configuration | Only `design` section | `design` + `multi_lang_config` + `filter_config` |
| Usage | Direct input to rendercv | Preprocessed by cvgen, then input to rendercv |

---

## Tips and Best Practices

1. **Start with verbosity 1.0**: Make your most important content `verbosity: 1.0` so it appears in all versions

2. **Use consistent verbosity levels**: Stick to standard levels (1.0, 1.5, 2.0) for easier management

3. **Translate consistently**: If you translate one field in an entry, translate all fields in that entry

4. **Keep design section standard**: The `design:` section should remain RenderCV-compatible (no multi-language fields)

5. **Test your pipeline**: Always test the full pipeline to ensure the output is valid RenderCV YAML

6. **Use Makefile**: Automate your build process with a Makefile (see project template)

7. **Version control intermediate files**: Consider gitignoring `output_*.yaml` but keep your main CV file (e.g., `cv.yaml` or `example_cv.yaml`) in version control

---

## Troubleshooting

### RenderCV reports unknown fields

Make sure you've run the collapse step to convert multi-language dictionaries to single strings.

### Content not filtering correctly

Check that your `filter_config` keys match the keys you're using in your YAML (`content` and `verbosity` by default).

### Multi-language fields not collapsing

Ensure you're passing the correct language key with `-k` or `--lang-key` to the collapse command.

### Missing content after filtering

Check your verbosity levels. Content with `verbosity: 2.0` won't appear if you filter with `--target-verbosity 1`.

---

## Reference Links

- [RenderCV Documentation](https://docs.rendercv.com)
- [RenderCV GitHub](https://github.com/rendercv/rendercv)
- CVGen GitHub: *(add your repository URL)*

---

*Last updated: October 28, 2025*
