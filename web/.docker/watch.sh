#!/bin/bash
# This script is used to watch the changes of the code and run the tests
# It is used in the Test Container.
# Author: Arvin Yang
# Date: 2023/12/16

monitor_recursive() {
    inotifywait -mr -e  modify,create,delete,move $1 |
    while read dir event file ; do
        if [[ -f "$dir" ]];  then
            echo "[Recursive] File $dir was changed by Event $event. Run tests..."
        else
            echo "[Recursive] File $file was changed by Event $event in directory $dir. Run tests..."
        fi
        pnpm test-ct;
    done
}

monitor() {
    inotifywait -m -e  modify,create,delete,move $1 |
    while read dir event file ; do
        if [[ -f "$dir" ]]; then
            echo "[No Recursive] File $dir was changed by Event $event. Run tests..."
        else
            echo "[No Recursive] File $file was changed by Event $event in directory $dir. Run tests..."
        fi
        pnpm test-ct;
    done
}

pnpm exec playwright show-report --host 0.0.0.0 &
pnpm test-ct
monitor_recursive /app/app &
monitor /app/playwright/*.tsx &
