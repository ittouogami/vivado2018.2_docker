FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ARG VIVADO_VER="2018.2"
ARG IP=192.168.0.200
ARG URIS=smb://${IP}/Share/Vivado${VIVADO_VER}/
ARG VIVADO_MAIN=Xilinx_Vivado_SDK_2018.2_0614_1954.tar.gz
ARG VIVADO_UPDATE1=Xilinx_Vivado_SDx_Update_2018.2.1_0726_1815.tar.gz
ARG VIVADO_UPDATE2=Xilinx_Vivado_SDx_Update_2018.2.2_1001_1805.tar.gz
COPY install_config_main.txt /VIVADO-INSTALLER/
COPY install_config_up1.txt /VIVADO-INSTALLER_UP1/
COPY install_config_up2.txt /VIVADO-INSTALLER_UP2/
RUN \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install sudo && \
  apt-get -y -qq --no-install-recommends install \
          locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq --no-install-recommends install \
          software-properties-common \
          binutils \
          u-boot-tools \
          file \
          tofrodos \
          iproute2 \
          libncurses5-dev \
          tftp \
          tftpd-hpa \
          zlib1g-dev \
          libssl-dev \
          flex \
          bison \
          libselinux1 \
          diffstat \
          xvfb \
          chrpath \
          xterm \
          libtool \
          socat \
          autoconf \
          texinfo \
          gcc-multilib \
          libsdl1.2-dev \
          libglib2.0-dev \
          libtool-bin \
          cpio \
          pkg-config \
          ocl-icd-opencl-dev \
          smbclient \
          libjpeg62-dev && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install \
          zlib1g:i386 \
          libc6-dev:i386 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
#Main
  smbget -O -a ${URIS}${VIVADO_MAIN} | gzip -dcq - | tar x --strip-components=1 -C /VIVADO-INSTALLER && \
  /VIVADO-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER/install_config_main.txt && \
  rm -rf /VIVADO-INSTALLER && \
#Update1
  smbget -O -a ${URIS}${VIVADO_UPDATE1} | gzip -dcq - | tar x --strip-components=1 -C /VIVADO-INSTALLER_UP1 && \
  /VIVADO-INSTALLER_UP1/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER_UP1/install_config_up1.txt && \
  rm -rf /VIVADO-INSTALLER_UP1 && \
#Update2
  smbget -O -a ${URIS}${VIVADO_UPDATE2} | gzip -dcq - | tar x --strip-components=1 -C /VIVADO-INSTALLER_UP2 && \
  /VIVADO-INSTALLER_UP2/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER_UP2/install_config_up2.txt && \
  rm -rf /VIVADO-INSTALLER_UP2

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-c", "source /opt/Xilinx/Vivado/${VIVADO_VER}/settings64.sh;/bin/bash"]

