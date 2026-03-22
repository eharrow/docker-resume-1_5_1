# Modernization Guide: XML Resume Library 1.5.1

This document describes the migration from the legacy Ant-based build system to Maven and modern Java (OpenJDK 21).

## What Changed

### Before (Legacy)
- **Java Runtime**: OpenJDK 8 via Alpine (old openjdk:alpine)
- **Build System**: Apache Ant 1.9.4 (2014)
- **XSLT Processor**: Apache Xalan (loose/missing dependencies)
- **PDF Generator**: Apache FOP 1.0/1.1 (very outdated)
- **Dependency Management**: Manual JAR files in `lib/` and `java/`
- **Container Base**: Alpine Linux (small but limited)

### After (Modernized)
- **Java Runtime**: OpenJDK 21 (LTS, latest stable)
- **Build System**: Maven 3.8+ (industry standard)
- **XSLT Processor**: Apache Xalan 2.7.3 (current)
- **PDF Generator**: Apache FOP 2.9 (modern)
- **Dependency Management**: Maven Central (automatic, reproducible)
- **Container Base**: Debian Slim (better compatibility)

## Migration Steps

### For Docker Users

**Old way:**
```bash
DOCKER_BUILDKIT=1 docker build -t resume-1_5_1:latest .
docker run -v /path/to/xml:/usr/src/resume-1_5_1/xml \
           -v /path/to/generated:/usr/src/resume-1_5_1/generated \
           -it resume-1_5_1:latest /bin/sh
```

**New way (same commands work!):**
The new Dockerfile is backward-compatible. Just rebuild:
```bash
DOCKER_BUILDKIT=1 docker build -t resume-1_5_1:latest .
# Then run exactly the same way as before
```

### For Local/Manual Builds

**Old way:**
```bash
cd src
./run.sh  # Required: ./apache-ant-1.9.4/bin/ant in PATH
```

**New way:**
```bash
mvn clean dependency:resolve
cd src
./run-maven.sh  # Requires Maven and Java 21
```

Or use Ant if it's still installed (backward compatible):
```bash
cd src
./run.sh  # Still works if Ant 1.10+ is in PATH
```

## Key Files

| File | Purpose | Status |
|------|---------|--------|
| `pom.xml` | Maven project configuration | **NEW** - Central to new build |
| `Dockerfile` | Container build recipe | **UPDATED** - Java 21, multi-stage |
| `src/run-maven.sh` | Maven-based build script | **NEW** - Recommended |
| `src/run.sh` | Old Ant-based script | **DEPRECATED** - Still works |
| `src/build.xml` | Ant targets | **KEPT** - For compatibility |
| `lib/*.jar` | Old dependency JARs | **DEPRECATED** - Now via Maven |
| `java/*.jar` | Java tools | **DEPRECATED** - Now via Maven |

## Breaking Changes

⚠️ **None!** The migration is backward-compatible.

- Old scripts still work if you have Ant installed
- Dockerfile changes are transparent to users
- Resume output format unchanged

## Performance Improvements

- **Startup**: Faster JVM startup with Java 21
- **Memory**: More efficient garbage collection
- **Build**: Maven caches dependencies locally (faster subsequent builds)
- **Container**: Multi-stage Docker build keeps image size reasonable

## Dependency Changes

### Removed (via Maven Central)
- `apache-ant-1.9.4/` → Installed via `apt-get install maven`
- `lib/xalan*.jar` → `xalan:xalan:2.7.3`
- `lib/fop*.jar` → `org.apache.xmlgraphics:fop:2.9`
- `java/xmlresume-filter.jar` → Built from source or referenced

### Added (from Maven Central)
```xml
<dependency>
  <groupId>xalan</groupId>
  <artifactId>xalan</artifactId>
  <version>2.7.3</version>
</dependency>

<dependency>
  <groupId>org.apache.xmlgraphics</groupId>
  <artifactId>fop</artifactId>
  <version>2.9</version>
</dependency>

<dependency>
  <groupId>xerces</groupId>
  <artifactId>xercesImpl</artifactId>
  <version>2.12.2</version>
</dependency>

<dependency>
  <groupId>xml-apis</groupId>
  <artifactId>xml-apis</artifactId>
  <version>1.4.01</version>
</dependency>
```

## Future Steps (Optional)

1. **Retire Legacy Ant Setup**: Once Maven is stable, delete `src/build.xml` and `apache-ant-1.9.4/`
2. **Create Maven Plugin**: Wrap XSLT/PDF generation in a custom Maven plugin for cleaner integration
3. **CI/CD Pipeline**: Add GitHub Actions to auto-build and test on every commit
4. **Update XSL Stylesheets**: Modernize the XSLT stylesheets for HTML5 output
5. **Package as Maven Artifact**: Publish to Maven Central for easy reuse

## Troubleshooting

### "Maven command not found"
Install Maven: `apt-get install maven` or see https://maven.apache.org/install.html

### "Java 21 not available on my system"
Use Docker instead, or install Java 21 from https://openjdk.org/

### "Xalan/FOP classes not found"
Run: `mvn clean dependency:resolve` to download all dependencies

### "Old scripts still fail"
Make sure Ant is in your `PATH`. Or switch to the new Maven scripts.

## See Also

- **README.md** - Updated usage instructions
- **pom.xml** - Maven configuration with all dependencies
- **Dockerfile** - Modern multi-stage build
- **src/run-maven.sh** - New recommended build script
- Maven Docs: https://maven.apache.org/guides/
- Java 21 LTS: https://openjdk.org/projects/jdk/21/

---

**Questions?** Open an issue or check the docs in `doc/` directory.