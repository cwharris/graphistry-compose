#!/usr/bin/env bash

printmsg() {
    local msg="$*"
    printf '%s%s#%s %b%s\n\n' \
        "$(tput bold)" "$(tput setaf 32)" \
        "$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"
}

printwarning() {
    local msg="$*"
    printf '%s%sWarning:%s %b%s\n\n' \
        "$(tput bold)" "$(tput setaf 227)" \
        "$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"
}

printerror() {
    local msg="$*"
    printf '%s%sError:%s %b%s\n\n' \
        "$(tput bold)" "$(tput setaf 196)" \
        "$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"
}


if [[ -x /usr/local/opt/openssl/bin/openssl ]]; then
    bin='/usr/local/opt/openssl/bin/openssl'
else
    bin='openssl'
fi

printmsg "Using OpenSSL version:$(tput sgr0) $($bin version)"


if [[ $# -gt 0 ]]; then
    subject="$1"
    printmsg "Will generate certificate for hostname: $subject"
else
    prompt="$(printf '%s%s %s%s' "$(tput bold)$(tput setaf 112)" '==>' "$(tput setaf 15)" 'Enter website hostname:' "$(tput sgr0)")"
    read -p "$prompt" subject
    printf '\n\n'
fi


outdir="$PWD/etc/ssl"

printmsg "Creating output directory '$outdir'"
if ! mkdir -p -m 700 "$outdir"; then
    printerror "could not create output directory '$outdir'"
    exit 10
fi


printmsg "Generating certificate & key"
ssloutput="$($bin req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout "$outdir/ssl.key" -out "$outdir/ssl.crt" -subj "/C=US/ST=California/L=Oakland/O=Graphistry, Inc./CN=$subject" 2>&1)"

if [[ $? -ne 0 ]]; then
    printerror "could not generate SSL certificate & key for '$subject'"
    echo "OpenSSL output:"
    echo "$ssloutput"
    exit 1
fi


printmsg "Done"
