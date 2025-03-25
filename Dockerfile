# Use python:3.x-slim as the base image
FROM python:3.x-slim

# Set the working directory to /app
WORKDIR /app

# Copy requirements.txt to the Docker image
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy the rest of the repository to the Docker image
COPY . .

# Expose port 8000
EXPOSE 8000

# Set the default command to serve the MkDocs site
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]
