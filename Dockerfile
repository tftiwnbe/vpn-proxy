FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  expressvpn \
  dante \
  iptables

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1080

CMD ["/entrypoint.sh"]
