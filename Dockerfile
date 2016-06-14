FROM debian:jessie

MAINTAINER Andrew Cutler <andrew@panubo.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install slapd ldap-utils ldapscripts && \
    apt-get -y install vim && \
    mkdir -p /etc/ldap/slapd.d /ldap.d && \
    rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap/slapd.d /etc/ldap/slapd.d.cache

EXPOSE 389

COPY entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["slapd", "-h", "ldap:/// ldapi:///", "-g", "openldap", "-u", "openldap", "-F", "/etc/ldap/slapd.d" ]
