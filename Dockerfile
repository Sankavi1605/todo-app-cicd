# Stage 1: Build the Flutter web app from the official Dart image
FROM dart:stable AS builder

# Install Git and other dependencies needed to get the Flutter SDK
RUN apt-get update && apt-get install -y git curl unzip

# Clone ONLY the latest version of the stable branch of the Flutter SDK (shallow clone)
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /usr/local/flutter

# Set the path to include the Flutter binary
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Run flutter doctor to download the Dart SDK and verify the installation
RUN flutter doctor

# Set the working directory for our app
WORKDIR /app

# Copy the project files into the container
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build the Flutter web application for production
RUN flutter build web

# Stage 2: Create the final production image (this part is unchanged)
FROM nginx:alpine

# Copy the built web files from the 'builder' stage
# to the default Nginx public HTML directory
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port 80 to allow traffic to the web server
EXPOSE 80