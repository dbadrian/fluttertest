FROM archlinux:latest


RUN pacman -Sy \
    && pacman -S --noconfirm base-devel git go npm yarn sudo
# RUN useradd builduser -m # Create the builduser \
#     && passwd -d builduser # Delete the buildusers password \
#     && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers


# Set up a build user (to avoid building packages as root)
RUN useradd -m builduser && \
    echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Switch to the build user
USER builduser
WORKDIR /home/builduser




RUN git clone https://aur.archlinux.org/yay.git \
    && cd yay \
    && makepkg -si --noconfirm 

RUN yay -S --noconfirm flutter libsecret

# # Copy the PKGBUILD and any necessary files to the container
# COPY PKGBUILD /build/PKGBUILD

# # Prepare the build environment and build the package
# RUN cd /build && makepkg -si --noconfirm

# Default command to keep the container running or explore the container
CMD ["/bin/bash"]