#!/bin/sh -l

echo "Hola\n"

REPORT_PATH="/app/gitleaks-report.$FORMAT"

gitleaks $SCAN --report-format $FORMAT --report-path $REPORT_PATH \
  --redact 20 \
  --verbose $VERBOSE \
  --no-banner \
  .

# read generated report and write the github output file
if [ -f $REPORT_PATH ]; then
  echo "Gitleaks report generated at $REPORT_PATH"
  echo "gitleaks_report<<EOF" >> $GITHUB_OUTPUT
  cat $REPORT_PATH >> $GITHUB_OUTPUT
  echo "EOF" >> $GITHUB_OUTPUT
else
  echo "No gitleaks report generated."
  exit 1
fi

exit 0

