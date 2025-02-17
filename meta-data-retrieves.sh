#!/bin/bash

# Metadata URL
METADATA_URL="http://169.254.169.254/latest/meta-data"

# Function to fetch metadata
fetch_metadata() {
    local key=$1
    if [ -z "$key" ]; then
        # Fetch all top-level metadata keys
        curl -s "$METADATA_URL/"
    else
        # Fetch the specific key
        curl -s "$METADATA_URL/$key"
    fi
}

# Function to format output as JSON
format_output() {
    local key=$1
    local value=$2

    if [ -z "$value" ]; then
        echo "{\"error\": \"Key '$key' not found\"}"
    elif [[ "$value" == */ ]]; then
        echo "{\"$key\": {"
        # Recursively fetch nested keys
        nested_keys=$(fetch_metadata "$key")
        for nested_key in $nested_keys; do
            nested_value=$(fetch_metadata "$key/$nested_key")
            echo "\"$nested_key\": \"$nested_value\","
        done | sed '$ s/,$//'
        echo "}}"
    else
        echo "{\"$key\": \"$value\"}"
    fi
}

# Function to format all metadata keys as JSON
format_all_metadata() {
    echo "{"
    all_keys=$(fetch_metadata)
    for key in $all_keys; do
        value=$(fetch_metadata "$key")
        echo "\"$key\": \"$value\","
    done | sed '$ s/,$//'
    echo "}"
}

# Function to display usage instructions
show_usage() {
    echo "Usage:"
    echo "1. ./metadata_query.sh                 # Fetch all metadata keys"
    echo "2. ./metadata_query.sh -key <key>      # Fetch specific metadata by key"
    echo "3. ./metadata_query.sh -key <key/sub-key>  # Fetch nested metadata by key path"
    echo ""
    echo "Example:"
    echo "./metadata_query.sh -key instance-id"
    echo "./metadata_query.sh -key iam/security-credentials/my-role"
    echo ""
    echo "Error: Invalid usage. Please refer to the above examples."
    exit 1
}

# Main logic
if [ $# -eq 0 ]; then
    # Fetch and format all metadata as JSON
    echo "Fetching all metadata..."
    format_all_metadata
elif [ "$1" == "-key" ]; then
    if [ -n "$2" ]; then
        # Fetch and format specific key or sub-key as JSON
        value=$(fetch_metadata "$2")
        format_output "$2" "$value"
    else
        echo "Error: No key provided."
        show_usage
    fi
else
    # Invalid usage
    show_usage
fi
