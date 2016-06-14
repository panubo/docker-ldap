#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

# Defaults
: ${LDAP_ORG:='ACME Corp'}
: ${LDAP_DOMAIN:='example.com'}
: ${LDAP_BACKEND:='MDB'}
: ${LDAP_ALLOW_V2:='false'}
: ${LDAP_PURGE_DB:='false'}
: ${LDAP_MOVE_OLD_DB:='true'}
#: ${LDAP_USER:='admin'}
[ -z "$LDAP_PASSWORD" ] && echo "Error: LDAP_PASSWORD not specified" && exit 128
LDAP_DC="dc=$(echo $LDAP_DOMAIN | sed -e 's@\.@,dc=@g')"  # Convert to ldap DC

# Skip configuration if config exists
if [ ! -d "/etc/ldap/slapd.d" ]; then

cat <<-EOF | debconf-set-selections
    slapd shared/organization     string $LDAP_ORG
    slapd slapd/allow_ldap_v2     boolean $LDAP_ALLOW_V2
    slapd slapd/backend           string $LDAP_BACKEND
    slapd slapd/domain            string $LDAP_DOMAIN
    slapd slapd/dump_database     select when needed
    slapd slapd/internal/adminpw password $LDAP_PASSWORD
    slapd slapd/internal/generated_adminpw password $LDAP_PASSWORD
    slapd slapd/move_old_database boolean $LDAP_MOVE_OLD_DB
    slapd slapd/no_configuration  boolean false
    slapd slapd/password1         password $LDAP_PASSWORD
    slapd slapd/password2         password $LDAP_PASSWORD
    slapd slapd/purge_database    boolean $LDAP_PURGE_DB
    slapd slapd/purge_database    boolean $LDAP_PURGE_DB
EOF

  dpkg-reconfigure -f noninteractive slapd

  egrep -q '^BASE' /etc/ldap/ldap.conf || echo -e "BASE \t $LDAP_DC" >> /etc/ldap/ldap.conf

fi

# Fix permissions on Database
chown -R openldap:openldap /var/lib/ldap

# Allow bypass entrypoint
if [ "$1" == "slapd" ]; then

    # Set slapd log level
    if [ "$DEBUG" == 'true' ]; then
        set -- "$@" -d Any
    else
        set -- "$@" -d stats
    fi

fi

exec "$@"
