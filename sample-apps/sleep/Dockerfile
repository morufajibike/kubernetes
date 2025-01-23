# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install bash, curl, and httpie
RUN apt-get update && \
    apt-get install -y bash curl && \
    pip install --no-cache-dir httpie && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the command to sleep indefinitely
CMD ["bash", "-c", "while true; do sleep infinity; done"]