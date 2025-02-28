#!/bin/bash

kubectl get pods | \
    fzf --header-lines=1 | \
    awk '{print $1}' | \
    xargs kubectl logs -f
