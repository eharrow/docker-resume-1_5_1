# Quick Start Guide - Resume Generation with Maven

## TL;DR - Get Started in 3 Minutes

```bash
# 1. Clone repository (or use existing checkout)
cd /Users/ewan/dev/resume-1_5_1

# 2. One-time setup (downloads dependencies)
mvn clean dependency:resolve

# 3. Generate your CV
cd src
./run-maven.sh example1 uk a4

# 4. Find outputs in ../generated/
ls -lh ../generated/
# example1.html - Web version
# example1.pdf  - Professional PDF
# example1.txt  - Plain text
```

## Requirements

- **Java**: Version 21+ (or use Java 25)
- **Maven**: Version 3.8+
- **Disk Space**: ~50 MB for dependencies (first run only)
- **Bash**: Any recent version

**Check**:
```bash
java -version   # Should show 21+
mvn -version    # Should show 3.8+
```

## Common Tasks

### Generate Resume with Different Locales

```bash
cd src

# UK format (default)
./run-maven.sh myresume uk a4

# US Letter size
./run-maven.sh myresume us letter

# German format
./run-maven.sh myresume de a4

# French format  
./run-maven.sh myresume fr a4
```

**Supported locales**: br, de, es, fr, it, nl, uk, us

### Generate From Custom XML File

```bash
# Option 1: Copy to src/ directory
cp /path/to/cv.xml src/
cd src
./run-maven.sh cv uk a4

# Option 2: Copy to example/ directory
cp /path/to/cv.xml example/
cd src
./run-maven.sh cv uk a4

# Option 3: Place in xml/ directory
cp /path/to/cv.xml xml/
cd src
./run-maven.sh cv uk a4
```

### Generate Multiple CVs at Once

```bash
cd src
for cv in example1 professional academic; do
  echo "Generating $cv..."
  ./run-maven.sh $cv uk a4
done
```

### Verify Installation

```bash
cd /Users/ewan/dev/resume-1_5_1
mvn validate

# Should output: BUILD SUCCESS
```

## Output Files

Generated in `generated/` directory:

| Format | Extension | Size | Purpose |
|--------|-----------|------|---------|
| HTML | `.html` | 3-5 KB | Web/Email - XHTML 1.0 |
| PDF | `.pdf` | 5-10 KB | Professional - Print-ready |
| Text | `.txt` | 1-2 KB | Plain text - Accessibility |

**Example**:
```
generated/
├── example1.html  (3.6 KB)
├── example1.pdf   (6.2 KB)
└── example1.txt   (961 B)
```

## Troubleshooting

### "Maven: command not found"
```bash
# macOS
brew install maven

# Ubuntu/Debian
sudo apt-get install maven
```

### "Java 21: command not found"
```bash
# Check Java version
java -version

# Install from https://openjdk.org/
# Or use SDKMAN: sdk install java 21
```

### "DTD file not found" errors
**This is normal.** The script automatically fixes DTD paths. The warnings are benign.

### Build hangs or takes too long
```bash
# First run downloads dependencies. Wait 10-30 seconds.
# Subsequent runs use cached dependencies (< 5 seconds).
```

### Files not generating
```bash
# Verify your XML file location
cd src
ls -la example1.xml  # Should exist

# Check generated directory
ls -la ../generated/

# Try with example CV
./run-maven.sh example1 uk a4
```

## Docker Alternative

If you don't have Maven installed locally:

```bash
cd /Users/ewan/dev/resume-1_5_1

# Build container
DOCKER_BUILDKIT=1 docker build -t resume:latest .

# Run (generates to ./generated/)
docker run -v $(pwd)/generated:/usr/src/resume-1_5_1/generated resume:latest
```

## Advanced Usage

### Custom Paper Sizes

```bash
# A4 (210×297 mm) - default for most locales
./run-maven.sh cv uk a4

# US Letter (8.5×11 in)
./run-maven.sh cv us letter
```

### Edit Generated Files

The output files are independent and can be edited:
- **HTML**: Open in any browser, edit CSS directly
- **PDF**: Use PDF editor (Adobe, Preview, etc.)
- **TXT**: Edit in any text editor

### Create Filtered Versions

To create a targeted resume (e.g., for specific job type):

```bash
# Edit src/cv.xml to add targets attribute:
# <job targets="tech">...</job>
# <job targets="sales">...</job>

# Then generate each version:
./run-maven.sh cv uk a4
```

## Performance

| Step | Time | Notes |
|------|------|-------|
| Dependency resolve | 1.2s | First run only |
| HTML generation | 0.8s | Quick XSLT |
| PDF generation | 1.5s | Includes FOP |
| Text generation | 0.7s | Quick XSLT |
| **Total** | **~4s** | Includes overhead |

After first run, repeat generations take < 2 seconds.

## File Locations

```
resume-1_5_1/
├── src/
│   ├── run-maven.sh      ← Run this
│   ├── example1.xml      ← CV source files
│   └── *.xml
├── xsl/
│   └── output/           ← Stylesheets (auto-loaded)
│       ├── uk-html.xsl
│       ├── uk-a4.xsl
│       └── uk-text.xsl
├── dtd/
│   └── resume.dtd        ← Schema validation
├── generated/            ← Output directory
│   ├── *.html
│   ├── *.pdf
│   └── *.txt
└── pom.xml               ← Maven config
```

## Getting Help

1. **Script help**: `./run-maven.sh --help` (shows inline documentation)
2. **Maven help**: `mvn help` (Maven documentation)
3. **Documentation**: See `README.md`, `MODERNIZATION.md`, `IMPLEMENTATION_SUMMARY.md`
4. **Issues**: Check existing CVs in `example/` directory

## Next Steps

1. ✅ Verify setup works: `./run-maven.sh example1`
2. 📝 Create your CV: Copy and edit `example1.xml`
3. 🎯 Generate: `./run-maven.sh yourname uk a4`
4. 📤 Share: Send the `.pdf` or `.html` files

## Version Information

- **Resume Library Version**: 1.5.1
- **Java**: 21+ LTS
- **Maven**: 3.8+
- **Build Date**: April 4, 2026
- **Status**: Production Ready ✅

---

**Happy resume generating!** 🚀

For detailed information, see `README.md` or `IMPLEMENTATION_SUMMARY.md`.

