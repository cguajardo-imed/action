#!/bin/sh -l

# Print information about the scan directory
echo "::group::Directory information"
echo "Scanning files in $REPO_PATH:"
ls -la $REPO_PATH
echo "::endgroup::"

REPORT_PATH="$REPO_PATH/gitleaks-report.$FORMAT"

echo "::group::Running Gitleaks scan"
# Run Gitleaks with options to ensure all files are scanned
gitleaks dir -v --report-format $FORMAT --report-path $REPORT_PATH \
  --no-banner \
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

