# Use the latest development version of the Chainguard Python image as the base image for the development stage
FROM cgr.dev/chainguard/python:latest-dev as dev

# Set the working directory inside the container to /app
WORKDIR /app

# Create a virtual environment named 'venv'
RUN python -m venv venv

# Add the virtual environment's bin directory to the PATH environment variable
ENV PATH="/app/venv/bin:$PATH"

# Copy the requirements.txt file from the host to the container
COPY requirements.txt requirements.txt

# Install the Python dependencies specified in requirements.txt
RUN pip install -r requirements.txt

# Use the latest version of the Chainguard Python image as the base image for the production stage
FROM cgr.dev/chainguard/python:latest

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the main.py file from the host to the container
COPY main.py main.py

# Copy the virtual environment from the development stage to the production stage
COPY --from=dev /app/venv /app/venv

# Add the virtual environment's bin directory to the PATH environment variable
ENV PATH="/app/venv/bin:$PATH"

# Expose port 8080 to allow external access to the application
EXPOSE 8080

# Define the command to run the FastAPI application using Uvicorn when the container starts
ENTRYPOINT ["python","-m","uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]