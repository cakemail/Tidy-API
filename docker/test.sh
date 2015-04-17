#!/bin/bash

IP=$1
SCHEME=${2:-"http"}

scheme=""
if [ "${SCHEME}" == "https" ]; then
	scheme="s"
fi

curl --header -k --insecure -v -X --header 'Host: tidy.wbsrvc.com' -v -X POST \
	http${scheme}://$IP/clean \
	-d 'html=<!--This is a comment. Comments are not displayed in the browser--> <p> Test Paragraph 2 </p>'
