# Multi-stage Dockerfile with Java 21 LTS
FROM eclipse-temurin:25-alpine AS builder
WORKDIR /build

# Install Maven and required build tools
RUN apk add maven \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY pom.xml .
COPY src/ ./src/

# Build with Maven
RUN mvn clean dependency:resolve

# Runtime stage
FROM eclipse-temurin:25-alpine

WORKDIR /usr/src/resume-1_5_1

# Install runtime dependencies
RUN apk add maven \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copy from builder
COPY --from=builder /build /usr/src/resume-1_5_1

# Ensure scripts are executable
COPY src/run-maven.sh /usr/src/resume-1_5_1/src/
RUN chmod +x /usr/src/resume-1_5_1/src/run-maven.sh

# Set working directory for resume generation
WORKDIR /usr/src/resume-1_5_1/src

# Default command
CMD ["./run-maven.sh"]