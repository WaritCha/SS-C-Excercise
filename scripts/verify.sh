#!/bin/bash

# Usage: ./verify.sh <ALB_DNS_NAME>

URL=$1

if [ -z "$URL" ]; then
  echo "Usage: ./verify.sh <ALB_DNS_NAME>"
  exit 1
fi

echo "Checking health of $URL..."

response=$(curl -s -o /dev/null -w "%{http_code}" http://$URL/health)

if [ "$response" == "200" ]; then
  echo "Health Check Passed! (Status: 200)"
  exit 0
else
  echo "Health Check Failed! (Status: $response)"
  exit 1
fi
