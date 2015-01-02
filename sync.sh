#!/bin/bash
set -x
s3cmd sync public/ s3://waynewitzel-blog \
    --acl-public --delete-removed --guess-mime-type
