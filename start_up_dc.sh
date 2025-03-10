#!/bin/bash

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found in current directory"
    exit 1
fi

# First run the startup script from containers/tools
echo "Setting up directories..."
chmod +x ./containers/tools/start_up.sh
sed -i '' "s|<USERNAME>|$(whoami)|g" .env
./containers/tools/start_up.sh

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to set up directories"
    exit 1
fi

# Run docker-compose
echo "Starting docker containers..."
docker-compose up --build

