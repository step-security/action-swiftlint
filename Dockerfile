FROM alpine:3.23

LABEL version="3.2.1"
LABEL repository="https://github.com/step-security/action-swiftlint"
LABEL homepage="https://github.com/step-security/action-swiftlint"
LABEL maintainer="step-security"

LABEL "com.github.actions.name"="GitHub Action for SwiftLint"
LABEL "com.github.actions.description"="A tool to enforce Swift style and conventions."
LABEL "com.github.actions.icon"="shield"
LABEL "com.github.actions.color"="orange"

# Pick SwiftLint version
ARG SWIFTLINT_VERSION=0.62.2

# Install runtime dependencies: bash (for entrypoint), curl (for API check), git (for diff), ca-certificates (for HTTPS)
RUN apk add --no-cache bash curl git ca-certificates

# Docker buildx passes TARGETARCH automatically (amd64/arm64)
ARG TARGETARCH

# Download static binary from GitHub releases
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64)  ASSET="swiftlint_linux_amd64.zip" ;; \
      arm64)  ASSET="swiftlint_linux_arm64.zip" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    apk add --no-cache unzip; \
    curl -fsSL -o /tmp/swiftlint.zip \
      "https://github.com/realm/SwiftLint/releases/download/${SWIFTLINT_VERSION}/${ASSET}"; \
    unzip -q /tmp/swiftlint.zip -d /tmp; \
    mv /tmp/swiftlint-static /usr/local/bin/swiftlint; \
    chmod +x /usr/local/bin/swiftlint; \
    rm -rf /tmp/swiftlint*; \
    apk del unzip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
