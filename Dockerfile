FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  dante \
  iptables \
  base-devel \
  git \
  sudo

RUN useradd -m -s /bin/bash expressvpn && \
    echo "expressvpn ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/expressvpn && \
    chmod 0440 /etc/sudoers.d/expressvpn

USER expressvpn
RUN git clone https://aur.archlinux.org/yay.git /home/expressvpn/yay && \
    cd /home/expressvpn/yay && \
    makepkg -si --noconfirm && \
    rm -rf /home/expressvpn/yay

RUN yay -S --noconfirm expressvpn

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY systemd/entrypoint.service /etc/systemd/system/entrypoint.service

RUN systemctl enable entrypoint.service

VOLUME [ "/sys/fs/cgroup" ]
STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
