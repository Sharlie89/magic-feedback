# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY api/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY api/ .

# Expose port 8080 for the Cloud Run service
EXPOSE 8080

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
