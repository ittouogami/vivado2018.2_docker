FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"

ENV VIVADO_VER=2018.2
ARG URIS=smb://192.168.103.223/Share/Vivado2018.2/
ARG VIVADO_MAIN=Xilinx_Vivado_SDK_2018.2_0614_1954.tar.gz
ARG VIVADO_UPDATE1=Xilinx_Vivado_SDx_Update_2018.2.1_0726_1815.tar.gz
ARG VIVADO_UPDATE2=Xilinx_Vivado_SDx_Update_2018.2.2_1001_1805.tar.gz
COPY install_config_main.txt /VIVADO-INSTALLER/
COPY install_config_up1.txt /VIVADO-INSTALLER_UP1/
COPY install_config_up2.txt /VIVADO-INSTALLER_UP2/
RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential binutils ncurses-dev u-boot-tools file tofrodos iproute2 \
    gawk net-tools libncurses5-dev tftp tftpd-hpa zlib1g-dev libssl-dev flex \
    bison libselinux1 diffstat xvfb chrpath xterm libtool socat autoconf unzip \
    texinfo gcc-multilib libsdl1.2-dev libglib2.0-dev zlib1g:i386 libtool-bin \
    cpio python python3 pkg-config git gcc-multilib libc6-dev:i386 \
    ocl-icd-opencl-dev libjpeg62-dev && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
#Main
  curl -u guest ${URIS}${VIVADO_MAIN} | tar zx --strip-components=1 -C /VIVADO-INSTALLER && \
  /VIVADO-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER/install_config_main.txt && \
  rm -rf /VIVADO-INSTALLER && \
#Update1
  curl -u guest ${URIS}${VIVADO_UPDATE1} | tar zx --strip-components=1 -C /VIVADO-INSTALLER_UP1 && \
  /VIVADO-INSTALLER_UP1/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER_UP1/install_config_up1.txt && \
  rm -rf /VIVADO-INSTALLER_UP1 && \
#Update2
  curl -u guest ${URIS}${VIVADO_UPDATE2} | tar zx --strip-components=1 -C /VIVADO-INSTALLER_UP2 && \
  /VIVADO-INSTALLER_UP2/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER_UP2/install_config_up2.txt && \
  rm -rf /VIVADO-INSTALLER_UP2

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

