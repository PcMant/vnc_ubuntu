# Use an official Ubuntu base image
FROM ubuntu:latest

# Avoid warnings by switching to noninteractive for the build process
ENV DEBIAN_FRONTEND=noninteractive

ENV USER=root

#Repository
RUN echo deb "http://gb.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list

# Install XFCE, VNC server, dbus-x11, and xfonts-base
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    xfonts-base \
    libwebkit2gtk-4.1-0 \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Add Mozilla repository and key for Firefox installation
#RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
#RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
#RUN echo "Package: * \nPin: origin packages.mozilla.org \n Pin-Priority: 1000 \n\nPackage: firefox*\n Pin: release o=Ubuntu\n Pin-Priority: -1" | tee /etc/apt/preferences.d/mozilla

# Install Firefox from Mozilla repository
#RUN aptitude update && aptitude install -y firefox

# Setup VNC server
RUN mkdir /root/.vnc \
    && echo "password" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Create an .Xauthority file
RUN touch /root/.Xauthority

# Set display resolution (change as needed)
ENV RESOLUTION=1920x1080

# Expose VNC port
EXPOSE 5901

# Set the working directory in the container
WORKDIR /app

# Copy a script to start the VNC server
COPY start-vnc.sh start-vnc.sh
RUN chmod +x start-vnc.sh

# List the contents of the /app directory
RUN ls -a /app

# Uprock
COPY UpRock-Mining-v0.0.5.deb UpRock-Mining-v0.0.5.deb
RUN dpkg -i /app/UpRock-Mining-v0.0.5.deb