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
    echo "report_content=$(cat $REPORT_PATH | sed 's/"/\\"/g')"  # Escape quotes for JSON compatibility
    echo "report_path=$REPORT_PATH"
    
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
  echo "----"
  cat $REPORT_PATH
  echo "----"
  echo "::endgroup::"
else
  {
    echo "success=false"
    echo "report_content="
    echo "report_path="
    echo "leaks_found=false"
  } >> $GITHUB_OUTPUT

  GITLEAKS_EXIT_CODE=1
fi

# if STOP_ON_FAILURE is true, exit with the Gitleaks exit code, which could be 1, which means leaks found and should stop the workflow
# if STOP_ON_FAILURE is false, exit with 0, which means the workflow should continue no matter what
if [ $STOP_ON_FAILURE = true ]; then
  exit $GITLEAKS_EXIT_CODE
else 
  exit 0
fi

