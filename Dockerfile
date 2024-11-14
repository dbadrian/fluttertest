FROM archlinux:latest

ARG GPGKEY=""

RUN pacman -Sy \
    && pacman -S --noconfirm base-devel git go npm yarn sudo
# RUN useradd builduser -m # Create the builduser \
#     && passwd -d builduser # Delete the buildusers password \
#     && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers


# Set up a build user (to avoid building packages as root)
RUN useradd -m builduser && \
    echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN echo 'PACKAGER="David B. Adrian <dawidh.adrian@gmail.com>"' >> /etc/makepkg.conf \
    echo 'GPGKEY="4ABA106821FC33C2"' >> /etc/makepkg.conf

# Switch to the build user
USER builduser
WORKDIR /home/builduser


RUN echo -n "$GPGKEY" | base64 --decode | gpg --import

RUN git clone https://aur.archlinux.org/yay.git \
    && cd yay \
    && makepkg -si --noconfirm 

RUN yay -Sy && yay -S --noconfirm flutter-bin libsecret
RUN yay -S --noconfirm gtk3 pkgconf

# Copy the PKGBUILD and any necessary files to the container
COPY PKGBUILD /home/builduser/PKGBUILD



# Prepare the build environment and build the package
RUN cd /home/builduser && makepkg -si --noconfirm --sign

# # Default command to keep the container running or explore the container
# CMD ["/bin/bash"]

# COPY entrypoint.sh /entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]