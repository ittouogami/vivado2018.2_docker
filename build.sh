IPADDRESS=$(ip addr show $( netstat -rn | grep UG | awk -F' ' '{print $8}')\
     | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
     | grep -o [0-9].*)
VIVADO_VER=2018.2
docker image build \
    --rm \
    --build-arg IP=${IPADDRESS} \
    --build-arg VIVADO_VER \
    --no-cache \
    -t vivado${VIVADO_VER} .
