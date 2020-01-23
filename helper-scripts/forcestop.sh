#!/bin/bash

echo "==================================="
echo "Stopping containers if they exist"
echo "==================================="
sudo docker stop $(sudo docker ps -a | grep keptn-orders | awk '{ print $1 }')
echo ""
echo "==================================="
echo "Removing containers if they exist"
echo "==================================="
sudo docker rm -f $(sudo docker ps -a | grep keptn-orders | awk '{ print $1 }')
echo ""
echo "==================================="
echo "List of running containers"
echo "==================================="
sudo docker ps -a