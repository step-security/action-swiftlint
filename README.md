# GitHub Action for SwiftLint

This Action executes [SwiftLint](https://github.com/realm/SwiftLint) and generates annotations from SwiftLint Violations.

## Usage

An example workflow(`.github/workflows/swiftlint.yml`) to executing SwiftLint follows:

```yaml
name: SwiftLint

on:
  pull_request:
    paths:
      - '.github/workflows/swiftlint.yml'
      - '.swiftlint.yml'
      - '**/*.swift'

jobs:
  SwiftLint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: GitHub Action for SwiftLint
        uses: step-security/action-swiftlint@v3
      - name: GitHub Action for SwiftLint with --strict
        uses: step-security/action-swiftlint@v3
        with:
          args: --strict
      - name: GitHub Action for SwiftLint (Only files changed in the PR)
        uses: step-security/action-swiftlint@v3
        env:
          DIFF_BASE: ${{ github.base_ref }}
      - name: GitHub Action for SwiftLint (Different working directory)
        uses: step-security/action-swiftlint@v3
        env:
          WORKING_DIRECTORY: Source
```

## Secrets

- `GITHUB_TOKEN` is not needed.

## Example
![screenshot](screenshot.png)

## Author

step-security

## License

[MIT](LICENSE)
