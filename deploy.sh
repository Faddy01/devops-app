#!/bin/bash

set -e

LOGFILE=deploy.log
DATE=$(date)

echo "===== Deployment Started $DATE =====" >> $LOGFILE

OLD_PORT=3000
NEW_PORT=3001

echo "Building image..." >> $LOGFILE
docker build -t devops-app . >> $LOGFILE 2>&1

echo "Removing old green if exists..." >> $LOGFILE
docker rm -f app-green >/dev/null 2>&1 || true

echo "Starting green container..." >> $LOGFILE
docker run -d --name app-green -p $NEW_PORT:3000 devops-app >> $LOGFILE 2>&1

sleep 5

echo "Running health check..." >> $LOGFILE

if curl -f http://localhost:$NEW_PORT/health; then

    echo "Health check passed." >> $LOGFILE

    sudo sed -i 's/3000/3001/g' /etc/nginx/sites-available/default
    sudo nginx -t
    sudo systemctl reload nginx

    echo "Traffic switched to green." >> $LOGFILE

    docker rm -f app-blue >/dev/null 2>&1 || true
    docker rename app-green app-blue

    echo "Old version removed." >> $LOGFILE

else

    echo "Health check FAILED. Rolling back." >> $LOGFILE

    docker rm -f app-green >/dev/null 2>&1 || true

fi

echo "===== Deployment Finished =====" >> $LOGFILE
