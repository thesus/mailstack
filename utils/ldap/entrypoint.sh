#!/bin/sh

if [ -z ${1+x} ]; then
    cat << EOF
usage of LDAP-Helper:

init    Create Organizational Units and Users for postfix, dovecot and SoGo
add     Push ldif into directory. Input via pipe.
EOF
    exit 2
fi

if [ $1 = "init" ]; then
    echo "Initializing LDAP-Directory..."
    dockerize -template /base.template.ldif:/base.ldif -template /services.template.ldif:/services.ldif

    ldapadd -D $ADMIN -h ldap:389 -w $ADMIN_PW -f base.ldif
    ldapadd -D $ADMIN -h ldap:389 -w $ADMIN_PW -f services.ldif
elif [ $1 = "add" ]; then
    # Allow input via pipe or as a filename
    if [ -z "$2" ]; then
        ldif=`cat`
    else
        ldif=`cat $2`
        if [ -z "$ldif" ]; then
            exit 1
        fi

    fi

    echo "Adding...the following ldif"
    echo "---------------------------------"
    echo "$ldif"
    echo "----------------------------------"

    echo "$ldif" | ldapadd -D $ADMIN -h ldap:389 -w $ADMIN_PW
fi
