#!/bin/bash

# re-reg-satellite.sh is centrally managed by Puppet version <%= @puppetversion %>
# do cleanup of sat6 if previouisly registered...
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:$PATH
if [ -f /usr/bin/katello-rhsm-consumer ] ; then
   yum erase -y katello-ca-consumer*
fi

# pre-reg install katello-ca-consumer for specific capsule
rpm -Uvh http://<%= @sat_server %>/pub/katello-ca-consumer-latest.noarch.rpm

########################################################################################
# register command for this host
{{ register_cmd }}
########################################################################################
 

yum -y install katello-agent

# Subscribe to TIAA repo, by default.
INDEX=1
/usr/sbin/subscription-manager list --available | egrep "^Subscription Name|^Pool ID" | while read LN
do
  if [ `expr $INDEX % 2` == 0 ]; then
    POOL="`echo $LN | cut -d: -f2 | tr -d ' '`"
    if [ "$NAME" == "tiaa" ]; then
      /usr/sbin/subscription-manager attach --pool=$POOL > /dev/null 2>&1
    fi
  else
    NAME="$(echo -e "${LN}" | cut -d: -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  fi
  INDEX=`expr $INDEX + 1`
done

 

# if registered,  disable reposync
for file in reposync base appstream tiaa tools supplementary
do
   if [ -f /etc/yum.repos.d/${file}.repo -a -f /etc/pki/consumer/cert.pem ] ; then
      sed -i s/enabled=1/enabled=0/g /etc/yum.repos.d/${file}.repo
   fi
done

