#!/bin/bash
echo "Cheking resolv.conf file"
grep "research.ravenpack.com" /etc/resolv.conf >> /dev/null
if [ $? -eq 0 ];then
    echo "resolv.conf looks fine"
else
    echo "Adding FQDN to your resolv.conf file"
    echo "search research.ravenpack.com private.aws.ravenpack.com development.ravenpack.com" >> /etc/resolv.conf
fi
