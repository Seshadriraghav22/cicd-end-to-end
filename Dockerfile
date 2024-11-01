FROM python:3

# Install system dependencies
RUN apt-get update && apt-get install -y python3-distutils && apt-get clean

# Set the working directory
WORKDIR /app

# Copy the requirements file if you have one
# If you don't have a requirements.txt file, you can skip this line for now
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose the desired port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
