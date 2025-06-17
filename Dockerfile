FROM zricethezav/gitleaks:v8.27.2

# Receive env vars from the runner
ARG FORMAT
ENV FORMAT=${FORMAT:-json}

ARG STOP_ON_FAILURE
ENV STOP_ON_FAILURE=${STOP_ON_FAILURE:-false}

ENV REPO_PATH="/github/workspace"

# Set the working directory
WORKDIR $REPO_PATH

# Copy entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /usr/bin/entrypoint.sh

# run entrypoint
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
