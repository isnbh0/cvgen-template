# CVGen 참고 문서: RenderCV YAML 확장하기

이 문서는 RenderCV의 YAML 구문에 대한 cvgen 전용 확장 기능을 설명합니다. **CVGen은 RenderCV YAML 구문의 상위 집합을 제공하는 전처리 도구**로, 다국어 지원, 상세도 기반 콘텐츠 필터링, 태깅 기능을 추가합니다. CVGen은 확장된 YAML 파일을 처리하여 표준 RenderCV YAML을 출력하고, 이는 RenderCV 자체에서 렌더링됩니다.

**관계:** CVGen은 RenderCV를 확장하는 것이지 대체하는 것이 아닙니다. CVGen의 확장 YAML 형식으로 CV를 작성하고, `cvgen filter`와 `cvgen collapse`로 처리한 다음, 출력을 `rendercv`에 전달하여 최종 PDF를 생성합니다.

## 목차

1. [설정 섹션](#설정-섹션)
2. [다국어 지원](#다국어-지원)
3. [상세도 시스템](#상세도-시스템)
4. [콘텐츠 래핑](#콘텐츠-래핑)
5. [태깅 시스템](#태깅-시스템)
6. [처리 파이프라인](#처리-파이프라인)
7. [마이그레이션 가이드](#마이그레이션-가이드)

---

## 설정 섹션

CVGen은 최상위 `cv` 객체에 두 가지 설정 섹션을 추가합니다:

### `multi_lang_config`

CV에서 지원하는 언어와 기본 언어를 정의합니다.

```yaml
cv:
  multi_lang_config:
    lang_keys:
      - en
      - ko
    default_lang: en
```

**필드:**
- `lang_keys`: 언어 코드 목록 (예: `en`, `ko`, `es`, `fr`)
- `default_lang`: 처리 중 언어가 지정되지 않은 경우 사용할 기본 언어

### `filter_config`

콘텐츠 래핑 및 상세도 필터링에 사용되는 키를 정의합니다.

```yaml
cv:
  filter_config:
    content_key: content
    verbosity_key: verbosity
```

**필드:**
- `content_key`: 콘텐츠를 래핑하는 데 사용되는 키 이름 (기본값: `"content"`)
- `verbosity_key`: 상세도 값에 사용되는 키 이름 (기본값: `"verbosity"`)

---

## 다국어 지원

CVGen을 사용하면 언어 코드를 키로 하는 딕셔너리를 사용하여 모든 문자열 필드에 대해 여러 번역을 정의할 수 있습니다.

### 기본 문자열 필드

**RenderCV 구문:**
```yaml
cv:
  name: "Your Name"
  location: "Your Location"
```

**CVGen 구문:**
```yaml
cv:
  name:
    en: "Your Name"
    ko: "당신의 이름"
  location:
    en: "Your Location"
    ko: "당신의 위치"
```

### 섹션 항목에서

**RenderCV 구문:**
```yaml
education:
  - institution: "University of Pennsylvania"
    area: "Computer Science"
    degree: "BS"
```

**CVGen 구문:**
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

### 리스트에서 (하이라이트, 저자 등)

**RenderCV 구문:**
```yaml
highlights:
  - "Reduced time to render user buddy lists by 75%"
  - "Integrated iChat with Spotlight Search"
```

**CVGen 구문:**
```yaml
highlights:
  - en: "Reduced time to render user buddy lists by 75%"
    ko: "예측 알고리즘을 구현하여 사용자 친구 목록 렌더링 시간을 75% 단축"
  - en: "Integrated iChat with Spotlight Search"
    ko: "저장된 채팅 기록에서 메타데이터를 추출하고 시스템 전체 검색"
```

### 언어와 무관한 필드

일부 필드는 언어에 관계없이 동일하게 유지됩니다 (날짜, URL, DOI 등):

```yaml
experience:
  - company:
      en: "Apple"
      ko: "애플"
    start_date: 2005-06  # 번역 불필요
    end_date: 2007-08    # 번역 불필요
```

---

## 상세도 시스템

상세도 시스템을 사용하면 대상 상세도 수준에 따라 콘텐츠를 포함하거나 제외할 수 있습니다. 이는 CV의 다양한 버전(예: 짧은 버전, 중간 버전, 상세 버전)을 만드는 데 유용합니다.

### 상세도 수준

- **낮은 값** (예: `1.0`): 모든 버전에 나타나는 필수 콘텐츠
- **높은 값** (예: `2.0`, `3.0`): 상세 버전에만 나타나는 선택적 콘텐츠
- **소수 값** (예: `1.5`): 세밀한 제어를 위한 중간 수준

### 항목 수준 상세도

**기본 구문:**
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

`--target-verbosity 1`로 필터링하면 `verbosity <= 1.0`인 항목만 포함됩니다.

### 섹션 수준 상세도

전체 섹션에 상세도 수준을 지정할 수 있습니다:

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

### 중첩 상세도

여러 수준에서 상세도를 적용할 수 있습니다:

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

### 복잡한 구조에 대한 상세도

하위 필드가 있는 필드의 경우 콘텐츠를 래핑합니다:

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

## 콘텐츠 래핑

콘텐츠 래핑을 사용하면 `content` 객체로 래핑하여 항목에 메타데이터(예: 상세도)를 추가할 수 있습니다.

### 간단한 래핑

**래핑 없이:**
```yaml
highlights:
  - "Some text"
```

**래핑 사용:**
```yaml
highlights:
  - content: "Some text"
    verbosity: 1.0
```

### 다국어 + 래핑

```yaml
highlights:
  - content:
      en: "English text"
      ko: "한국어 텍스트"
    verbosity: 1.5
```

### 리스트 래핑

필드가 리스트를 예상하는 경우 전체 리스트를 래핑할 수 있습니다:

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

### 섹션 래핑

전체 섹션을 래핑할 수 있습니다:

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

## 태깅 시스템

> **⚠️ 알파 기능:** 태깅 시스템은 현재 알파 단계입니다. API 및 동작은 향후 릴리스에서 변경될 수 있습니다.

태그를 사용하면 임의의 레이블을 기반으로 콘텐츠를 분류하고 필터링할 수 있습니다.

### 섹션 태그

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

### 필터링과 함께 태그 사용

태그는 `cvgen filter` 명령과 함께 사용할 수 있습니다:

```bash
# "detail" 태그가 있는 항목만 포함 (예: example_cv.yaml의 technologies 섹션)
cvgen filter example_cv.yaml --include-tags "detail" | \
  cvgen collapse -k ko > output_detailed.yaml

# "detail" 태그가 있는 항목 제외 (상세한 기술 목록 없는 깔끔한 CV)
cvgen filter example_cv.yaml --exclude-tags "detail" | \
  cvgen collapse -k ko > output_minimal.yaml

# 상세도 필터링과 결합
cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags "detail" | \
  cvgen collapse -k ko > output_medium_ko.yaml
```

**참고:** `example_cv.yaml`에서 `technologies` 섹션은 `tags: ["detail"]`을 가지고 있어 필요에 따라 포함하거나 제외할 수 있습니다.

---

## 처리 파이프라인

CVGen은 두 단계로 CV를 처리합니다:

### 1. 필터 (`cvgen filter`)

상세도 및 태그를 기반으로 콘텐츠를 필터링합니다:

```bash
cvgen filter example_cv.yaml \
  --target-verbosity 1 \
  --include-tags '' \
  > filtered.yaml
```

**옵션:**
- `--target-verbosity`: 이 값 이하의 상세도를 가진 항목만 포함
- `--include-tags`: 포함할 태그의 쉼표로 구분된 목록 (빈 문자열은 태그 필터링 없음을 의미)
- `--exclude-tags`: 제외할 태그의 쉼표로 구분된 목록

### 2. 축약 (`cvgen collapse`)

다국어 필드를 단일 언어로 축약합니다:

```bash
cvgen collapse filtered.yaml -k ko > output_ko.yaml
```

**옵션:**
- `-k, --lang-key`: 추출할 언어 코드 (예: `en`, `ko`)

### 결합된 파이프라인

```bash
cvgen filter example_cv.yaml --target-verbosity 1 --include-tags '' | \
  cvgen collapse -k ko > output_ko.yaml
```

### RenderCV와의 통합

cvgen으로 처리한 후 출력은 RenderCV가 직접 사용할 수 있는 **표준 RenderCV YAML**입니다:

```bash
# cvgen collapse의 출력은 이제 순수한 RenderCV YAML입니다
rendercv render output_ko.yaml -o .outputs
```

**핵심 사항:** 이 단계에서 모든 CVGen 전용 구문(다국어 딕셔너리, 상세도 메타데이터, 태그 등)이 제거되었습니다. 이제 파일은 RenderCV가 기본적으로 처리할 수 있는 표준 RenderCV YAML 파일입니다.

---

## 마이그레이션 가이드

### RenderCV를 CVGen으로 변환하기

#### 1단계: 설정 섹션 추가

`cv:` 섹션 상단에 추가:

```yaml
cv:
  multi_lang_config:
    lang_keys:
      - en  # 필요에 따라 더 많은 언어 추가
    default_lang: en
  filter_config:
    content_key: content
    verbosity_key: verbosity
```

#### 2단계: 다국어 지원 추가

번역하려는 각 문자열 필드에 대해:

**변경 전:**
```yaml
name: "Your Name"
```

**변경 후:**
```yaml
name:
  en: "Your Name"
  ko: "당신의 이름"
```

#### 3단계: 상세도 수준 추가

상세도로 제어하려는 항목을 래핑합니다:

**변경 전:**
```yaml
highlights:
  - "Essential item"
  - "Optional detail"
```

**변경 후:**
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

#### 4단계: (선택사항) 태그 추가

필터링하려는 섹션에 태그를 추가합니다:

```yaml
sections:
  technologies:
    content:
      - label: "Languages"
        details: "Python, Java"
    tags: ["technical"]
```

#### 5단계: 빌드 프로세스 업데이트

직접 RenderCV 호출을 CVGen 파이프라인으로 교체합니다:

**변경 전:**
```bash
rendercv render cv.yaml
```

**변경 후:**
```bash
# 영어 버전 생성
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k en | \
  rendercv render - -o outputs/en

# 한국어 버전 생성
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k ko | \
  rendercv render - -o outputs/ko
```

### 일반적인 패턴

#### 패턴 1: 다양한 역할에 대한 다른 상세도 수준

```yaml
experience:
  - company: "Apple"
    position: "Senior Engineer"
    highlights:
      - content: "5명으로 구성된 팀 리드"
        verbosity: 1.0  # 항상 표시
      - content: "기능 X 구현"
        verbosity: 1.5  # 중간 상세도
      - content: "50개 이상의 버그 수정"
        verbosity: 2.0  # 높은 상세도
```

#### 패턴 2: 언어별 하이라이트

```yaml
highlights:
  - content:
      en: "Worked in international team"
      ko: "국제 팀에서 근무하며 한국어와 영어로 협업"
    verbosity: 1.0
```

#### 패턴 3: 다양한 CV 유형을 위한 태그된 섹션

```yaml
sections:
  research_projects:
    content:
      - name: "ML 연구"
    tags: ["academic"]
  
  industry_projects:
    content:
      - name: "프로덕션 시스템"
    tags: ["industry"]
```

그런 다음 다른 버전을 생성합니다:

```bash
# 학술 CV
cvgen filter example_cv.yaml --include-tags "academic" | \
  cvgen collapse -k ko > output_academic.yaml

# 산업 CV
cvgen filter example_cv.yaml --include-tags "industry" | \
  cvgen collapse -k ko > output_industry.yaml
```

---

## 예제

### 예제 1: 최소 CVGen 문서

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

### 예제 2: 모든 기능을 갖춘 항목

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

## example_cv.yaml을 사용한 실용적인 예제

이 템플릿에 포함된 `example_cv.yaml` 파일은 모든 CVGen 기능을 보여줍니다. 다음은 실용적인 사용 사례입니다:

### 다양한 상세도 수준 생성

```bash
# 간단한 CV (상세도 1.0 항목만)
cvgen filter example_cv.yaml --target-verbosity 1 | \
  cvgen collapse -k ko > output_brief_ko.yaml

# 표준 CV (상세도 1.5까지)
cvgen filter example_cv.yaml --target-verbosity 1.5 | \
  cvgen collapse -k ko > output_standard_ko.yaml

# 상세한 CV (모든 항목, 상세도 2.0)
cvgen filter example_cv.yaml --target-verbosity 2 | \
  cvgen collapse -k ko > output_detailed_ko.yaml
```

### 다국어 버전 생성

```bash
# 중간 상세도의 한국어 버전
cvgen filter example_cv.yaml --target-verbosity 1.5 --include-tags '' | \
  cvgen collapse -k ko > output_medium_ko.yaml

# 기술 상세 섹션이 없는 영어 버전
cvgen filter example_cv.yaml --target-verbosity 1.5 --exclude-tags "detail" | \
  cvgen collapse -k en > output_clean_en.yaml
```

### 결합 필터링

```bash
# 상세한 기술 섹션이 없는 간단한 한국어 CV
cvgen filter example_cv.yaml --target-verbosity 1 --exclude-tags "detail" | \
  cvgen collapse -k ko | \
  rendercv render - -o outputs/brief_ko

# 모든 상세 정보가 포함된 완전한 영어 CV
cvgen filter example_cv.yaml --target-verbosity 2 --include-tags '' | \
  cvgen collapse -k en | \
  rendercv render - -o outputs/full_en
```

### Make와 함께 사용

포함된 `Makefile`은 빌드 프로세스를 자동화하는 방법을 보여줍니다:

```makefile
# 기본 한국어 CV 빌드
make

# 사용자 정의 입력 파일로 빌드
make with INPUT=my_cv.yaml

# 모든 필터링 기능을 보여주는 데모 PDF 생성
make demo

# 출력 디렉토리 정리
make clean
```

`make demo` 명령은 `.demo/` 디렉토리에 8개의 서로 다른 PDF를 생성하며, 카테고리별로 구성됩니다:

**상세도 + 언어 예제:**
- 영어와 한국어로 된 간단한, 표준, 상세 버전
- 언어 간 상세도 필터링(1.0, 1.5, 2.0)의 작동 방식을 보여줍니다

**태그 기반 필터링 예제 (알파):**
- 학술 전용 CV (태그 포함 표시)
- 기술 섹션이 없는 CV (태그 제외 표시)

이것은 CVGen의 핵심 기능인 다국어 지원 및 상세도 필터링과 알파 단계의 태깅 시스템을 보여줍니다!

---

## 주요 차이점 요약

**중요:** CVGen은 RenderCV의 대안이 아닙니다. 대신 CVGen은 설정 요구사항에 따라 표준 RenderCV YAML로 "컴파일"할 수 있는 **RenderCV YAML 구문의 상위 집합**을 제공합니다. 작업 흐름은 다음과 같습니다:

```
CVGen YAML (확장 구문) → [cvgen filter] → [cvgen collapse] → RenderCV YAML (표준 구문) → [rendercv] → PDF
```

| 기능 | RenderCV YAML | CVGen 확장 YAML |
|------|---------------|-----------------|
| 다국어 | ❌ 파일당 단일 언어 | ✅ 딕셔너리를 통해 하나의 파일에 여러 언어 |
| 상세도 필터링 | ❌ 내장 필터링 없음 | ✅ 숫자 수준 (1.0, 1.5, 2.0...) |
| 콘텐츠 래핑 | ❌ 메타데이터 지원 없음 | ✅ `content` + `verbosity` 패턴 |
| 태깅 | ❌ 태깅 시스템 없음 | ✅ `tags: ["tag1", "tag2"]` |
| 설정 | `design` 섹션만 | `design` + `multi_lang_config` + `filter_config` |
| 사용 | rendercv에 직접 입력 | cvgen으로 전처리 후 rendercv에 입력 |

---

## 팁과 모범 사례

1. **상세도 1.0부터 시작**: 가장 중요한 콘텐츠를 `verbosity: 1.0`으로 설정하여 모든 버전에 나타나도록 합니다

2. **일관된 상세도 수준 사용**: 관리를 쉽게 하기 위해 표준 수준(1.0, 1.5, 2.0)을 사용합니다

3. **일관되게 번역**: 항목의 한 필드를 번역하는 경우 해당 항목의 모든 필드를 번역합니다

4. **디자인 섹션을 표준으로 유지**: `design:` 섹션은 RenderCV 호환성을 유지해야 합니다(다국어 필드 없음)

5. **파이프라인 테스트**: 출력이 유효한 RenderCV YAML인지 확인하기 위해 항상 전체 파이프라인을 테스트합니다

6. **Makefile 사용**: Makefile로 빌드 프로세스를 자동화합니다 (프로젝트 템플릿 참조)

7. **중간 파일 버전 관리**: `output_*.yaml`을 gitignore하는 것을 고려하되 메인 CV 파일(예: `cv.yaml` 또는 `example_cv.yaml`)은 버전 관리에 유지합니다

---

## 문제 해결

### RenderCV가 알 수 없는 필드를 보고함

다국어 딕셔너리를 단일 문자열로 변환하기 위해 축약 단계를 실행했는지 확인하세요.

### 콘텐츠가 올바르게 필터링되지 않음

`filter_config` 키가 YAML에서 사용하는 키와 일치하는지 확인하세요 (기본값은 `content` 및 `verbosity`).

### 다국어 필드가 축약되지 않음

축약 명령에 `-k` 또는 `--lang-key`로 올바른 언어 키를 전달하고 있는지 확인하세요.

### 필터링 후 콘텐츠 누락

상세도 수준을 확인하세요. `verbosity: 2.0`인 콘텐츠는 `--target-verbosity 1`로 필터링하면 나타나지 않습니다.

---

## 참고 링크

- [RenderCV 문서](https://docs.rendercv.com)
- [RenderCV GitHub](https://github.com/rendercv/rendercv)
- CVGen GitHub: *(저장소 URL 추가)*

---

*마지막 업데이트: 2025년 10월 28일*
