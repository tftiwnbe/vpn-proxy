FROM alpine:latest

RUN apk add --no-cache \
  wireguard-tools \
  dante-server \
  iptables \
  iptables-legacy 

# Use iptables-legacy
RUN ln -sf /usr/sbin/iptables-legacy /usr/sbin/iptables && \
  ln -sf /usr/sbin/iptables-legacy-restore /usr/sbin/iptables-restore && \
  ln -sf /usr/sbin/iptables-legacy-save /usr/sbin/iptables-save

RUN sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1080

CMD ["/entrypoint.sh"]
