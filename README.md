# Docker Resume 1.5.1 - Modernized with Maven & Java 21

A containerized resume/CV generation system using modern Maven build tooling and Java 21 LTS.

## 🚀 Quick Start

### Local Build (Maven)

```bash
# Prerequisites: Java 21 JDK and Maven 3.8+

# Clone and navigate to repository
git clone https://github.com/eharrow/docker-resume-1_5_1.git
cd docker-resume-1_5_1

# Resolve dependencies (one-time setup)
mvn clean dependency:resolve

# Generate resume (default: example1, uk locale, a4 paper)
cd src
./run-maven.sh

# Or customize:
./run-maven.sh myresume us letter
```

Output files will be in `generated/` directory:
- `example1.html` - Web-ready XHTML (3-5 KB)
- `example1.pdf` - Professional PDF (5-10 KB)
- `example1.txt` - Plain text (1-2 KB)

### Docker Build

```bash
# Build image
DOCKER_BUILDKIT=1 docker build -t resume-1_5_1:maven .

# Run with default CV
docker run -v $(pwd)/generated:/usr/src/resume-1_5_1/generated resume-1_5_1:maven

# Run with specific CV title
docker run -e CV_TITLE=example2 \
  -v $(pwd)/generated:/usr/src/resume-1_5_1/generated \
  resume-1_5_1:maven
```

## 🏗️ Architecture

### Maven Build System

This modernized version replaces Ant with Maven for:
- **Standardized build lifecycle**: `clean`, `validate`, `compile`, `package`
- **Dependency management**: Centralized POM configuration with automatic Maven Central resolution
- **Multi-format generation**: HTML, PDF (via XSL-FO), TXT from single XML source
- **Java 21 LTS support**: Modern language features, improved GC, and security updates
- **Reproducible builds**: All dependencies pinned to specific versions, cached locally

### Key Dependencies

| Dependency | Version | Purpose |
|---|---|---|
| `xalan` | 2.7.3 | XSL Transformation (XML→HTML/PDF) |
| `fop` | 2.9 | Apache FOP - PDF Generation |
| `xerces` | 2.12.2 | XML Validation & Parsing |
| `xml-apis` | 1.4.01 | W3C XML Standards |

### Project Structure

```
.
├── pom.xml                          # Maven Project Object Model
├── Dockerfile                       # Multi-stage Docker build
├── src/
│   ├── run-maven.sh                # Build orchestration script
│   ├── cv/
│   │   ├── example1.xml            # Sample CV data (XML)
│   │   └── example2.xml            # Alternative CV data
│   ├── xsl/
│   │   └── resume.xsl              # XSL transformation templates
│   └── ...
├── generated/                       # Output directory (gitignored)
│   ├── example1.html
│   ├── example1.pdf
│   └── example1.txt
└── README.md
```

## 🔄 Comparison: Ant vs Maven

| Aspect | Ant (Legacy) | Maven (Modern) |
|---|---|---|
| **Config Format** | XML (verbose) | POM.xml (standardized) |
| **Dependency Mgmt** | Manual IvyDE | Automatic Maven Central |
| **Lifecycle** | Custom targets | Standard build phases |
| **Convention** | Requires build.xml | Convention over config |
| **Java Support** | Java 8-17 | Java 21 LTS |
| **Community** | Declining | Active & maintained |
| **Docker Base** | openjdk:11-slim | openjdk:21-slim |

## 📋 Usage Examples

### Generate All Formats for Single CV

```bash
./src/run-maven.sh professional
# Outputs: professional.html, professional.pdf, professional.txt
```

### Generate with Specific Locale and Paper Size

```bash
# US Letter format (default for US locale)
./src/run-maven.sh myresume us letter

# German A4 format
./src/run-maven.sh myresume de a4

# Italian A4 format
./src/run-maven.sh myresume it a4

# Supported locales: br, de, es, fr, it, nl, uk, us
```

### Batch Processing Multiple CVs

```bash
for cv in example1 professional academic; do
  ./src/run-maven.sh $cv uk a4
done
```

### Output Formats

The tool generates three formats from a single XML source:

1. **HTML** - Web-ready XHTML with embedded CSS styling
   - File: `generated/{cv-title}.html`
   - Size: ~3-5 KB typical
   - Suitable for: Web display, email, printing

2. **PDF** - Professional document format
   - File: `generated/{cv-title}.pdf`
   - Generated via XSL-FO intermediate format + Apache FOP
   - Size: ~5-10 KB typical
   - Suitable for: Job applications, archival

3. **Plain Text** - Accessible text format
   - File: `generated/{cv-title}.txt`
   - Generated via XSLT text transformation
   - Size: ~1-2 KB typical
   - Suitable for: Email, accessibility, parsing

## 🔧 Configuration

### Maven Properties

Edit `pom.xml` to customize:

```xml
<properties>
    <maven.compiler.source>21</maven.compiler.source>  <!-- Java version -->
    <maven.compiler.target>21</maven.compiler.target>
    <xalan.version>2.7.3</xalan.version>
    <fop.version>2.9</fop.version>
    <xerces.version>2.12.2</xerces.version>
</properties>
```

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `CV_TITLE` | `example1` | Name of CV file (without .xml) |

## ✅ Backward Compatibility

- Original Ant-based build still available on `legacy-ant` branch
- XML source format unchanged - all existing CVs work as-is
- XSL templates backward compatible
- Same output formats (HTML, PDF, TXT)

## 📦 Deployment

### Kubernetes Example

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: resume-generator
spec:
  template:
    spec:
      containers:
      - name: resume
        image: resume-1_5_1:maven
        env:
        - name: CV_TITLE
          value: "professional"
        volumeMounts:
        - name: output
          mountPath: /usr/src/resume-1_5_1/generated
      volumes:
      - name: output
        emptyDir: {}
      restartPolicy: Never
```

## 🐛 Troubleshooting

### Issue: "Maven command not found"

**Solution**: Install Maven 3.8+
```bash
# macOS
brew install maven

# Ubuntu/Debian
sudo apt-get install maven

# Or use Docker: DOCKER_BUILDKIT=1 docker build ...
```

### Issue: "xercesImpl-2.12.2.jar not found"

**Solution**: Run dependency resolution
```bash
mvn clean dependency:resolve
```

This downloads all JARs from Maven Central and caches them locally.

### Issue: "DTD file not found" errors during transformation

**Solution**: Ensure you're running from the `src/` directory - the script automatically fixes paths.
The warnings are benign since XSLT doesn't actually need the DTD file.

### Issue: PDF generation fails with "Premature end of file"

**Cause**: Invalid or empty XSL-FO intermediate file
**Solutions**:
1. Verify XML file is valid
2. Check correct XSL stylesheet is being used (check locale parameter)
3. Ensure DTD paths are fixed by running from `src/` directory

### Issue: Custom CV file not recognized

**Solution**: Place CV file in one of these locations:
```
src/cv/myfile.xml          # Standard location
../example/myfile.xml      # Example directory
src/myfile.xml             # Local to src/
../xml/myfile.xml          # XML directory
```

## 🔧 Configuration

### Maven Properties

Edit `pom.xml` to customize dependency versions:

```xml
<properties>
    <maven.compiler.source>21</maven.compiler.source>  <!-- Java version -->
    <maven.compiler.target>21</maven.compiler.target>
    <xalan.version>2.7.3</xalan.version>               <!-- XSLT processor -->
    <serializer.version>2.7.3</serializer.version>
    <fop.version>2.9</fop.version>                      <!-- PDF generator -->
    <xerces.version>2.12.2</xerces.version>             <!-- XML parser -->
</properties>
```

### Supported Locales

The XSLT stylesheets support multiple locales with region-specific formatting:

| Code | Country | Language | Paper Sizes |
|------|---------|----------|-------------|
| `br` | Brazil | Portuguese | a4 |
| `de` | Germany | German | a4 |
| `es` | Spain | Spanish | a4 |
| `fr` | France | French | a4 |
| `it` | Italy | Italian | a4 |
| `nl` | Netherlands | Dutch | a4 |
| `uk` | United Kingdom | English | a4 |
| `us` | United States | English | letter, a4 |

### Paper Sizes

- `a4` - ISO A4 (210 × 297 mm) - Default for most locales
- `letter` - US Letter (8.5 × 11 in) - Default for US locale

### Usage with Locales

```bash
# Generate German version on A4
./run-maven.sh cv_de de a4

# Generate US version on Letter size
./run-maven.sh cv_us us letter

# Generate French version on A4 (default)
./run-maven.sh cv_fr fr
```

### Issue: Docker build fails

**Solution**: Enable BuildKit for better caching
```bash
DOCKER_BUILDKIT=1 docker build -t resume-1_5_1:maven .
```

## 📚 Resources

- [Maven Official Documentation](https://maven.apache.org/)
- [Java 21 LTS Release Notes](https://docs.oracle.com/en/java/javase/21/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Apache FOP Documentation](https://xmlgraphics.apache.org/fop/)
- [Xalan XSLT Processor](https://xalan.apache.org/)

## 📝 License

See LICENSE file for details.

---

**Branch**: `modernize-maven-java`  
**Last Updated**: 2026-03-22  
**Maintainer**: @eharrow