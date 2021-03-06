# Deprecation Notice!

NB: This project is no longer maintained and the repository is archived.

---

# LDAP Docker Container

## Status

Work in progress.

## Configuration

- `DEBUG` - set to `true` to enable verbose logging
- `LDAP_ORG` - Organisation default `ACME Corp`
- `LDAP_DOMAIN` - Domain default `example.com`
- `LDAP_USER` - Bind User, default `admin` (not used)
- `LDAP_PASSWORD` - Bind Password (required)

## Usage Example

```
docker run -t -i --rm --name ldap -e LDAP_PASSWORD=foo -e DEBUG=true panubo/ldap
```

## Further reading

See https://wiki.debian.org/LDAP/OpenLDAPSetup
