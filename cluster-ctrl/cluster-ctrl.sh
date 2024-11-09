#!/bin/bash

scp 192.168.1.31:/root/.kube/config /root/.kube/
sed -i 's/127.0.0.1/192.168.1.31/' /root/.kube/config
