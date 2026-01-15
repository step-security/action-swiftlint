# syntax=docker/dockerfile:1.6

# ---- runtime: minimal ----
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

# Required for download + unzip in build; removed later to keep image small
RUN apk add --no-cache ca-certificates curl unzip

# Docker buildx passes TARGETARCH automatically (amd64/arm64)
ARG TARGETARCH

# Download static binary from GitHub releases
# NOTE: asset names can vary by release. If build fails, adjust the URL/asset name once.
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64)  ASSET="swiftlint_linux_amd64.zip" ;; \
      arm64)  ASSET="swiftlint_linux_arm64.zip" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/swiftlint.zip \
      "https://github.com/realm/SwiftLint/releases/download/${SWIFTLINT_VERSION}/${ASSET}"; \
    unzip -q /tmp/swiftlint.zip -d /usr/local/bin; \
    chmod +x /usr/local/bin/swiftlint; \
    rm -f /tmp/swiftlint.zip; \
    # remove build-time tools if you want even smaller (optional)
    apk del curl unzip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
