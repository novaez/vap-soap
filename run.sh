#!/bin/bash

echo "Usage: $0 [port]"

port=${1:-8180}

starman --disable-keepalive --port ${port}
