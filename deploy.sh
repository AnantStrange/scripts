#!/bin/bash

# Define deployment configuration
DEPLOY_USER="noone"
DEPLOY_HOST="strangeworld.blog"
REGULAR_DIR="/srv/http/StrangeBlog/"
ONION_DIR="/srv/http/StrangeBlogOn/"

# Function to deploy to regular domain
deploy_regular_domain() {
    echo "Deploying to regular domain..."
    hugo -b "https://strangeworld.blog" && rsync -av --delete -e "ssh -i ~/Downloads/arch_web_serv.pem" ~/work/hugo/public/ "${DEPLOY_USER}"@"${DEPLOY_HOST}":"${REGULAR_DIR}"
}

# Function to deploy to Tor onion service
deploy_tor_onion_service() {
    echo "Deploying to Tor onion service..."
    hugo -b "http://strangesj6o7ey6kunwe5eqefksbqj6mwx6vcrcv2t6abmqtfikzsxyd.onion" && rsync -av --delete -e "ssh -i ~/Downloads/arch_web_serv.pem" ~/work/hugo/public/ "${DEPLOY_USER}"@"${DEPLOY_HOST}":"${ONION_DIR}"
}

# Function to run both deployments
deploy_all() {
    deploy_regular_domain
    deploy_tor_onion_service
}

# Function to run only the onion deployment
deploy_onion() {
    deploy_tor_onion_service
}

# Function to run only the clearnet deployment
deploy_clearnet() {
    deploy_regular_domain
}

# Main script logic
case "$1" in
    all)
        deploy_all
        ;;
    on)
        deploy_onion
        ;;
    cl)
        deploy_clearnet
        ;;
    *)
        echo "Usage: $0 {all|on|cl}"
        exit 1
        ;;
esac

exit 0

