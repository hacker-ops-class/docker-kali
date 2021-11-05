FROM kalilinux/kali-rolling

MAINTAINER qeeqbox

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils bash-completion firefox-esr python3-pip python3-dev build-essential

RUN apt-get update && \
    apt-get install -y --no-install-recommends evince file-roller gnome-themes-standard gpicview gtk2-engines-pixbuf ttf-ubuntu-font-family xfce4 xfce4-whiskermenu-plugin xorg xserver-xorg xfce4-indicator-plugin xfce4-terminal numix-icon-theme numix-icon-theme-circle

RUN apt-get install -y xrdp locales supervisor sudo ibus ibus-mozc dbus dbus-x11 kali-desktop-xfce

RUN locale-gen en_US && \
    apt-get install -y git tigervnc-standalone-server && \
    git clone https://github.com/novnc/noVNC.git /root/noVNC && \
    git clone https://github.com/novnc/websockify.git /root/noVNC/utils/websockify

RUN mkdir -p /var/run/dbus 

RUN useradd -m -s /bin/bash -G sudo xuser

RUN ln -s /root/noVNC/vnc_lite.html /root/noVNC/index.html

RUN echo "xfce4-session" > /etc/skel/.xsession
    
RUN apt-get install -y xfce4-taskmanager mousepad wget

RUN wget https://downloads.hackerops.dev/file/hackerops/BHIS_Basic_V1.png -O /usr/share/backgrounds/xfce/default.jpg -O /usr/share/backgrounds/xfce/default.jpg

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["./entrypoint.sh"]
