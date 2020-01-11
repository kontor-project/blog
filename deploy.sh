#!/bin/bash
#
#by Eduardo"

# remove previous build
rm -rf deployment/www

# build again
hugo

# copy build to deployment folder
cp -r public deployment/www

#deploy
cd deployment && gcloud app deploy
