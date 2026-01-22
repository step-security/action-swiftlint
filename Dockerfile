FROM ghcr.io/step-security/swiftlint:0.63.1_swift-6.1@sha256:c6d57030c15a1bdc9f58daba162b5667b34dd1f200977397e20806cf30e464a8
LABEL version="3.2.1"
LABEL repository="https://github.com/step-security/action-swiftlint"
LABEL homepage="https://github.com/step-security/action-swiftlint"
LABEL maintainer="step-security"

LABEL "com.github.actions.name"="GitHub Action for SwiftLint"
LABEL "com.github.actions.description"="A tool to enforce Swift style and conventions."
LABEL "com.github.actions.icon"="shield"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
