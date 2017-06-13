#!/bin/bash -e

if [ ! -e /usr/local/bin/terraform-provider-docker-image ]; then
    if [ ! -d ~/go ]; then
        echo "Creating Go working directory"
        mkdir ~/go
    fi
    echo "Getting github.com/diosmosis/terraform-provider-docker-image"
    go get github.com/diosmosis/terraform-provider-docker-image
    echo "Building github.com/diosmosis/terraform-provider-docker-image"
    go build github.com/diosmosis/terraform-provider-docker-image
    echo "Moving terraform-provider-docker-image binary file into /usr/local/bin"
    mv terraform-provider-docker-image /usr/local/bin/

    if [ ! -e  ~/.terraformrc ]; then
        echo "Creating terraform plugins config"
        cat > $FILE <<- EOM
        providers {
          dockerimage = "/path/to/terraform-provider-docker-image"
        }
EOM
    fi
fi