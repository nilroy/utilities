#!/usr/bin/env bash
git pull && git fetch -p && git branch -vv | grep -i gone | awk '{print $1}' | xargs git branch -d
