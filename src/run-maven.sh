#!/bin/bash
# Maven-based resume generation script for Java 21 + Xalan 2.7.3 + FOP 2.9
# Supports: HTML, PDF, RTF (via Pandoc), and TXT output formats
# Usage: ./run-maven.sh [CV_TITLE] [COUNTRY] [PAPERSIZE]

set -e

# Configuration
CV_TITLE="${1:-${CV_TITLE:-example1}}"
COUNTRY="${2:-uk}"
PAPERSIZE="${3:-a4}"

# Determine output file format based on country/paper size
if [ "$COUNTRY" = "us" ]; then
    PAPERSIZE="${PAPERSIZE:-letter}"
    OUTPUT_FORMAT="${COUNTRY}-${PAPERSIZE}"
else
    PAPERSIZE="${PAPERSIZE:-a4}"
    OUTPUT_FORMAT="${COUNTRY}-${PAPERSIZE}"
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Resume/CV Generation - Maven Build (Java 21)             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Configuration:"
echo "  CV Title:     $CV_TITLE"
echo "  Country:      $COUNTRY"
echo "  Paper Size:   $PAPERSIZE"
echo "  Output Format: $OUTPUT_FORMAT"
echo ""

# Verify input file exists
CV_FILE="$CV_TITLE.xml"
if [ ! -f "$CV_FILE" ]; then
    # Try to find in example/ or xml/ directories
    if [ -f "../example/$CV_TITLE.xml" ]; then
        cp "../example/$CV_TITLE.xml" "$CV_FILE"
    elif [ -f "../xml/$CV_TITLE.xml" ]; then
        cp "../xml/$CV_TITLE.xml" "$CV_FILE"
    else
        echo "❌ Error: Cannot find CV file: $CV_TITLE.xml"
        echo "   Searched in: ., ../example/, ../xml/"
        exit 1
    fi
fi

# Fix DTD references to use local file paths (for offline processing)
# The example files have hardcoded Docker paths which won't work locally
# Fix both http:// URLs and file:// URLs with wrong paths
DTD_PATH="../dtd/resume.dtd"
if [ -f "$DTD_PATH" ]; then
    DTD_ABS_PATH=$(cd ../dtd && pwd)/resume.dtd

    # Replace http URLs
    sed -i.bak "s|http://xmlresume.sourceforge.net/dtd/resume.dtd|file://${DTD_ABS_PATH}|g" "$CV_FILE"

    # Replace incorrect file:// URLs (from Docker examples)
    sed -i.bak "s|file:///usr/src/resume-1_5_1/dtd/resume.dtd|file://${DTD_ABS_PATH}|g" "$CV_FILE"

    rm -f "${CV_FILE}.bak"

    echo "✓ DTD references fixed in $CV_FILE"
fi

# Create output directory
mkdir -p ../generated

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1/4: Resolving Maven dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd ..
mvn -q clean dependency:resolve

# Build classpath - Maven provides this in target/classpath.txt if configured
CLASSPATH=$(mvn -q dependency:build-classpath -Dmdep.outputFile=/dev/stdout)

echo "✅ Dependencies resolved"
echo "   Found $(echo $CLASSPATH | tr ':' '\n' | wc -l) JAR files"
echo ""

cd src

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2/4: Generating HTML output..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HTML_XSL="../xsl/output/${COUNTRY}-html.xsl"
if [ ! -f "$HTML_XSL" ]; then
    echo "❌ Error: XSL file not found: $HTML_XSL"
    exit 1
fi

java -cp "$CLASSPATH" org.apache.xalan.xslt.Process \
    -in "$CV_FILE" \
    -xsl "$HTML_XSL" \
    -out "../generated/$CV_TITLE.html" 2>&1

if [ -f "../generated/$CV_TITLE.html" ]; then
    echo "✅ HTML generated: generated/$CV_TITLE.html"
    ls -lh "../generated/$CV_TITLE.html"
else
    echo "❌ Failed to generate HTML"
    exit 1
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3/5: Generating PDF via XSL-FO intermediate format..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FO_XSL="../xsl/output/${OUTPUT_FORMAT}.xsl"
FO_FILE="$CV_TITLE.fo"
PDF_FILE="../generated/$CV_TITLE.pdf"
RTF_FILE="../generated/$CV_TITLE.rtf"

if [ ! -f "$FO_XSL" ]; then
    echo "❌ Error: XSL-FO stylesheet not found: $FO_XSL"
    exit 1
fi

# Step 3a: Generate FO (XSL-FO) intermediate file
echo "  3a. Generating XSL-FO intermediate file..."
java -cp "$CLASSPATH" org.apache.xalan.xslt.Process \
    -in "$CV_FILE" \
    -xsl "$FO_XSL" \
    -out "$FO_FILE" 2>&1

if [ ! -f "$FO_FILE" ]; then
    echo "❌ Failed to generate XSL-FO file"
    exit 1
fi
echo "     ✅ XSL-FO generated: $FO_FILE ($(ls -lh $FO_FILE | awk '{print $5}'))"

# Step 3b: Convert FO to PDF using FOP
echo "  3b. Converting XSL-FO to PDF using FOP..."
java -cp "$CLASSPATH" org.apache.fop.cli.Main \
    -fo "$FO_FILE" \
    -pdf "$PDF_FILE" 2>&1

if [ -f "$PDF_FILE" ]; then
    echo "✅ PDF generated: generated/$CV_TITLE.pdf"
    ls -lh "$PDF_FILE"
else
    echo "❌ Failed to generate PDF"
    exit 1
fi

# Step 3c: Optionally generate RTF from HTML using Pandoc (if available)
echo "  3c. Attempting RTF generation from HTML using Pandoc..."
if command -v pandoc &> /dev/null; then
    HTML_NO_TABLE="../generated/$CV_TITLE-no-table.html"
    # Strip tables from HTML for better RTF compatibility
    cp "../generated/$CV_TITLE.html" "$HTML_NO_TABLE" awk 'BEGIN{in_table=0} /<table/{in_table=1; next} /</table>/{in_table=0; next} !in_table{print}' "../generated/$CV_TITLE.html" > "$HTML_NO_TABLE"awk 'BEGIN{in_table=0} /<table/{in_table=1; next} /</table>/{in_table=0; next} !in_table{print}' "../generated/$CV_TITLE.html" > "$HTML_NO_TABLE" sed -i "/<table/,/</table>/d" "$HTML_NO_TABLE"
    pandoc -f html -t rtf "$HTML_NO_TABLE" -o "$RTF_FILE" 2>/dev/null
    rm -f "$HTML_NO_TABLE"
    if [ -f "$RTF_FILE" ]; then
        echo "✅ RTF generated: generated/$CV_TITLE.rtf (via Pandoc)"
        ls -lh "$RTF_FILE"
        echo "   💡 Tip: Open with Pages, Word, or LibreOffice (TextEdit has limited RTF support)"
    else
        echo "⚠️  Pandoc RTF conversion failed (continuing without RTF)"
    fi
else
    echo "ℹ️  Pandoc not installed - RTF generation skipped"
    echo "   To enable RTF: brew install pandoc  (macOS) or apt-get install pandoc (Linux)"
fi

# Keep FO file available in generated directory for reference
cp "$FO_FILE" "../generated/$CV_TITLE.fo"
echo "ℹ️  XSL-FO intermediate format saved: generated/$CV_TITLE.fo"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4/5: Generating plain text output..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TXT_XSL="../xsl/output/${COUNTRY}-text.xsl"
TXT_FILE="../generated/$CV_TITLE.txt"

if [ ! -f "$TXT_XSL" ]; then
    echo "❌ Error: Text XSL file not found: $TXT_XSL"
    exit 1
fi

# Generate via XSLT (better than HTML extraction)
java -cp "$CLASSPATH" org.apache.xalan.xslt.Process \
    -in "$CV_FILE" \
    -xsl "$TXT_XSL" \
    -out "$TXT_FILE" 2>&1

if [ -f "$TXT_FILE" ]; then
    echo "✅ Plain text generated: generated/$CV_TITLE.txt"
    ls -lh "$TXT_FILE"
else
    echo "❌ Failed to generate text output"
    exit 1
fi
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ Resume generation complete!                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Generated files:"
ls -lh ../generated/$CV_TITLE.* 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "Done at: $(date)"
