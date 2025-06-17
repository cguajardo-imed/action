FROM zricethezav/gitleaks:v8.27.2

# Receive env vars from the runner
ARG FORMAT
ENV FORMAT=${FORMAT:-json}

# Set the working directory
WORKDIR /app

# Copy entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /usr/bin/entrypoint.sh

# run entrypoint
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
