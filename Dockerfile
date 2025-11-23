# Use official Python image (LTS)
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements if you want (optional)
# But for now we install streamlit + pandas + plotly directly
RUN pip install --no-cache-dir streamlit pandas plotly

# Copy everything into the container
COPY . /app

# Expose Streamlit default port
EXPOSE 8501

# Streamlit needs to run with 0.0.0.0 inside Docker
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
