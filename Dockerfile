# Use official Swift image (regularly updated, fewer vulnerabilities)
FROM swift:6.0.3-jammy

LABEL version="3.2.1"
LABEL repository="https://github.com/step-security/action-swiftlint"
LABEL homepage="https://github.com/step-security/action-swiftlint"
LABEL maintainer="step-security"

LABEL "com.github.actions.name"="GitHub Action for SwiftLint"
LABEL "com.github.actions.description"="A tool to enforce Swift style and conventions."
LABEL "com.github.actions.icon"="shield"
LABEL "com.github.actions.color"="orange"

# SwiftLint version
ARG SWIFTLINT_VERSION=0.62.2

# Install dependencies and SwiftLint with dynamic binary
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        ca-certificates \
        unzip && \
    rm -rf /var/lib/apt/lists/*

# Docker buildx passes TARGETARCH automatically (amd64/arm64)
ARG TARGETARCH

# Download dynamic SwiftLint binary (supports all rules including SourceKit)
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64)  ASSET="swiftlint_linux_amd64.zip" ;; \
      arm64)  ASSET="swiftlint_linux_arm64.zip" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/swiftlint.zip \
      "https://github.com/realm/SwiftLint/releases/download/${SWIFTLINT_VERSION}/${ASSET}"; \
    unzip -q /tmp/swiftlint.zip -d /tmp; \
    mv /tmp/swiftlint /usr/local/bin/swiftlint; \
    chmod +x /usr/local/bin/swiftlint; \
    rm -rf /tmp/swiftlint*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
