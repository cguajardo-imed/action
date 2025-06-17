# Gitleaks Action

![GitHub Action](https://img.shields.io/badge/GitHub-Action-blue)
![Gitleaks](https://img.shields.io/badge/Security-Gitleaks-blue)

A GitHub Action that uses Gitleaks to scan repositories for secrets, keys, and other sensitive information.

## Usage

Add this action to your GitHub workflow:

```yaml
name: Scan for secrets

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Run Gitleaks
        uses: cguajardo-imed/action@v0.0.9
        id: gitleaks
        with:
          report_format: json
          stop_on_failure: false
      
      - name: Check Gitleaks results
        if: always()
        run: |
          echo "Scan successful: ${{ steps.gitleaks.outputs.success }}"
          echo "Leaks found: ${{ steps.gitleaks.outputs.leaks_found }}"
          echo "Report path: ${{ steps.gitleaks.outputs.report_path }}"
          echo "Report content: ${{ steps.gitleaks.outputs.report_content }}"
```

## Inputs

| Input          | Description                  | Required | Default |
|----------------|------------------------------|----------|---------|
| `report_format`| Format of the report to generate | No     | `json`  |
| `stop_on_failure` | Stop the workflow if Gitleaks finds any leaks | No | `false` |

## Outputs

The action generates the following outputs:

| Output           | Description                                |
|------------------|--------------------------------------------|
| `success`        | Whether the Gitleaks scan completed successfully (`true` or `false`) |
| `report_path`   | Path to the generated report file          |
| `report_content` | Content of the generated report file |
| `leaks_found` | Whether any leaks were found (`true` or `false`) |

## How It Works

This action:

1. Uses the official Gitleaks Docker image (v8.27.2)
2. Scans your entire repository directory for potential secrets
3. Generates a report in the specified format (JSON by default)
4. Stores the report in your repository workspace
5. Provides outputs indicating scan success, Gitleaks exit code, and whether leaks were found
6. Can optionally stop the workflow if leaks are found (via `stop_on_failure` input)

## Security Notes

- This action helps identify potential security issues but is not a guarantee against all security vulnerabilities
- False positives may occur, review the results carefully
- Consider using this in combination with other security tools for comprehensive protection

## License

[MIT License](LICENSE)

## Contribution

Contributions are welcome! Please feel free to submit a Pull Request.
