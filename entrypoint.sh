#!/bin/sh -l

REPORT_PATH="$REPO_PATH/gitleaks-report.$FORMAT"

echo "::group::Running Gitleaks scan in $REPO_PATH"
# Run Gitleaks with options to ensure all files are scanned
gitleaks dir -v \
  --report-format $FORMAT \
  --report-path $REPORT_PATH \
  --follow-symlinks \
  $REPO_PATH

# Store the exit code to handle it properly
GITLEAKS_EXIT_CODE=$?
echo "::endgroup::"

if [ -f $REPORT_PATH ]; then
  {
    echo "success=true"
    echo "gitleaks_exit_code=$GITLEAKS_EXIT_CODE"
    
    # non-zero exit code means leaks found
    if [ $GITLEAKS_EXIT_CODE -ne 0 ]; then
      echo "leaks_found=true"
    else
      echo "leaks_found=false"
    fi
  } >> $GITHUB_OUTPUT

  # Print the report path
  echo "::group::Gitleaks report"
  echo "Gitleaks report generated at: $REPORT_PATH"
  echo "Gitleaks exit code: $GITLEAKS_EXIT_CODE"
  echo "----"
  cat $REPORT_PATH
  echo "----"
  echo "::endgroup::"
else
  {
    echo "success=false"
    echo "gitleaks_exit_code=1"
    echo "leaks_found=false"
  } >> $GITHUB_OUTPUT

  GITLEAKS_EXIT_CODE=1
fi

# Exit with the gitleaks exit code to properly indicate if leaks were found
exit $GITLEAKS_EXIT_CODE

