FROM python:3

# Install system dependencies
RUN apt-get update && apt-get install -y python3-distutils && apt-get clean

# Set the working directory
WORKDIR /app

# Install Django
RUN pip install django==3.2

# Copy the application code
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose the desired port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
