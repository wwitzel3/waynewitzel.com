#!/bin/bash
set -x
rm -rf public
hugo
s3cmd sync public/ s3://waynewitzel-blog \
    --acl-public --delete-removed --no-mime-magic --guess-mime-type --cf-invalidate
