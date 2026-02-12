#!/bin/bash

source myenv/bin/activate
nohup python3 app.py > app.log 2>&1 &
# Make scripts executable:

# chmod +x scripts/*.sh