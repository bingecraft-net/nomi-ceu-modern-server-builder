#!/bin/zsh
backup=$(ls -Av server/backups/*.zip | tail -1)
unzip -d server $backup
