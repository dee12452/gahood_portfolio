from ubuntu:latest as flutterbuild

# Setup lib location
RUN mkdir -p /usr/lib
WORKDIR /usr/lib

# Install Dependencies
RUN apt-get update -y && apt-get upgrade -y;
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/usr/lib/flutter/bin"
RUN flutter precache
RUN flutter channel stable
RUN flutter upgrade

# Setup app location
RUN mkdir -p /usr/app
WORKDIR /usr/app

# Setup App
COPY lib lib
COPY assets assets
COPY web web
COPY pubspec.yaml .
COPY pubspec.lock .
COPY analysis_options.yaml .
RUN flutter build web --release


from python:3-alpine

EXPOSE 8000
COPY --from=flutterbuild /usr/app/build/web app
WORKDIR app

ENTRYPOINT ["python", "-m", "http.server"]
