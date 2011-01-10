#!/bin/bash

scp -r index.html problems msk@typhoon.xnet.com:public_html/domains/mathematicspracticeproblems.com/

SCRIPT=upload-script.$$
cat <<- ! >$SCRIPT
ls public_html/domains
cd public_html/domains/mathematicspracticeproblems.com
chmod go+x problems
chmod go+r index.html problems/*
ls -l *
exit 0
!

ssh msk@typhoon.xnet.com < $SCRIPT
rm $SCRIPT

