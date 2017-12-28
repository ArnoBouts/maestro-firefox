#!/bin/sh

if [ -n ${LDAP_HOST} ]; then
    sed -i "s/{{LDAP_HOST}}/${LDAP_HOST}/g" /etc/pam_ldap.conf
    sed -i "s/{{LDAP_BASE}}/${LDAP_BASE}/g" /etc/pam_ldap.conf
    sed -i "s/{{LDAP_BIND_DN}}/${LDAP_BIND_DN}/g" /etc/pam_ldap.conf
    sed -i "s/{{LDAP_BIND_PW}}/${LDAP_BIND_PW}/g" /etc/pam_ldap.conf
    sed -i "s/{{LDAP_FILTER}}/${LDAP_FILTER}/g" /etc/pam_ldap.conf
    pam-auth-update --force --package ldap
    pam-auth-update mkhomedir

    sed -i "s/{{LDAP_HOST}}/${LDAP_HOST}/g" /etc/ldap.conf
    sed -i "s/{{LDAP_BASE}}/${LDAP_BASE}/g" /etc/ldap.conf
    sed -i "s/{{LDAP_BIND_DN}}/${LDAP_BIND_DN}/g" /etc/ldap.conf
    sed -i "s/{{LDAP_BIND_PW}}/${LDAP_BIND_PW}/g" /etc/ldap.conf
    sed -i "s/{{LDAP_FILTER}}/${LDAP_FILTER}/g" /etc/ldap.conf
    sed -i "s/{{LDAP_HOST}}/${LDAP_HOST}/g" /etc/nslcd.conf
    sed -i "s/{{LDAP_BASE}}/${LDAP_BASE}/g" /etc/nslcd.conf
    sed -i "s/{{LDAP_BIND_DN}}/${LDAP_BIND_DN}/g" /etc/nslcd.conf
    sed -i "s/{{LDAP_BIND_PW}}/${LDAP_BIND_PW}/g" /etc/nslcd.conf
    sed -i "s/compat/compat ldap/1" /etc/nsswitch.conf
    /etc/init.d/nslcd restart
fi

xrdp-sesman

xrdp -ns
