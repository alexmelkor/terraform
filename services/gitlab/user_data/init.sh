#!/bin/bash

# Workaround to surevive on t2.micro instance
sudo dd if=/dev/zero of=/swapfile bs=100M count=40
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Prepare mount points for GitLab
sudo mkdir /mnt/gitlab

# Mount swap and
sudo chmod 777 /etc/fstab
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
echo "/dev/xvdh   /mnt/gitlab  xfs    defaults,nofail  0  2" >> /etc/fstab
sudo chmod 644 /etc/fstab
sudo mount -a
sudo chmod -R 0755 /mnt/gitlab

# Install docker
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Run GitLab
sudo docker run --detach --restart always \
  --hostname gitlab.gavno \
  --publish 443:443 --publish 80:80 \
  --name gitlab \
  --restart always \
  --mount type=bind,source="/mnt/gitlab/config",target=/etc/gitlab \
  --mount type=bind,source="/mnt/gitlab/logs",target=/var/log/gitlab \
  --mount type=bind,source="/mnt/gitlab/data",target=/var/opt/gitlab \
  gitlab/gitlab-ce:latest
