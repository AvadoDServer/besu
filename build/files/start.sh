#!/bin/sh

# Create JWTToken if it does not exist yet
JWT_TOKEN="/data/jwttoken"
if [ ! -f ${JWT_TOKEN} ]; then
    echo "Creating JWT Token"
    mkdir -p "/data/"
    openssl rand -hex 32 | tr -d "\n" >${JWT_TOKEN}
    cat ${JWT_TOKEN}
fi

# make JWT token available via nginx
mkdir -p /usr/share/nginx/wizard/
cat ${JWT_TOKEN} | tail -1 >/usr/share/nginx/wizard/jwttoken
chmod 644 /usr/share/nginx/wizard/jwttoken

export BESU_CMD="/opt/besu/bin/besu \
    --data-path=/data \
    --network=mainnet \
    --rpc-http-enabled=true \
    --rpc-http-api=ETH,NET,WEB3,TXPOOL \
    --rpc-http-cors-origins=\"*\"
    --rpc-http-host=\"0.0.0.0\" \
    --rpc-ws-enabled=true \
    --rpc-ws-host=\"0.0.0.0\" \
    --host-allowlist=\"*\" \
    --engine-host-allowlist=\"*\" \
    --engine-rpc-port=8551 \
    --Xmerge-support=true \
    --engine-jwt-secret=\"${JWT_TOKEN}\" \
    ${EXTRA_OPTS}"

echo "EXTRA_OPTS=$EXTRA"
echo "BESU_CMD=$BESU_CMD"

# Print version to the log
/opt/besu/bin/besu --version

# Start supervisor
/usr/bin/supervisord -c /etc/supervisord.conf
