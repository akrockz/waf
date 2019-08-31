#!/bin/bash
set -e

echo "core-waf package script running."

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"  # project folder
echo "REPO_DIR=${REPO_DIR}"
STAGING_DIR="${REPO_DIR}/_staging"
LAMBDA_DIR="${REPO_DIR}/lambdas"
echo "STAGING_DIR=${STAGING_DIR}" # Debug.

# Setup, cleanup.
mkdir -p $STAGING_DIR # Eventual deployspec package contents.
rm -rf $STAGING_DIR/*

# Copy this branch's deployspec and CFN templates into staging folder.
cp -p $REPO_DIR/deployspec-${BRANCH}.yaml $STAGING_DIR/deployspec.yaml
cp -p $REPO_DIR/cfn-* $STAGING_DIR/

# Install deps for all lambdas.
# cd $REPO_DIR
# python3 $REPO_DIR/bin/install-lambda-dependencies.py

# Create Lambda zip packages
cd $LAMBDA_DIR
for LAMBDA_NAME in */; do
    LAMBDA_NAME=${LAMBDA_NAME%*/}
    if [ $LAMBDA_NAME != "_common" ]; then
	    echo "Packaging lambda $LAMBDA_NAME"
	    cd "$LAMBDA_DIR/$LAMBDA_NAME"
	    # (optional) nodejs deps support
	    if [ -f "package.json" ]; then
	    	npm install --production
	    fi
	    >/dev/null zip -9 -r $STAGING_DIR/$LAMBDA_NAME.zip * -x \*.pyc \*.md \*.zip \*.log \*__pycache__\* \*.so
	fi
done

echo "core-waf package step complete, run.sh can be executed now."
