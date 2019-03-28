#!/bin/bash

/usr/sbin/nslcd
/usr/sbin/rsyslogd
/usr/sbin/sshd

tail -F /var/log/auth.log

