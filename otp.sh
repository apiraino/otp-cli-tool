#!/bin/bash

KEYFILE=$HOME/.otpkeys.gpg
GPG="gpg"
GPG_OPTS=( "--quiet" "--yes" "--compress-algo=none" "--no-encrypt-to" )
GPG_RECIPIENT="<YOUR_RECIPIENT@DOMAIN.NAME>"

die() {
    echo "$@" >&2
    exit 1
}

tmpdir() {
    [[ -n $SECURE_TMPDIR ]] && return
    local template="$PROGRAM.XXXXXXXXXXXXX"
    if [[ -d /dev/shm && -w /dev/shm && -x /dev/shm ]]; then
        SECURE_TMPDIR="$(mktemp -d "/dev/shm/$template")"
        remove_tmpfile() {
            rm -rf "$SECURE_TMPDIR"
        }
        trap remove_tmpfile INT TERM EXIT
    else
        echo "Your system does not have /dev/shm, which means that it may
              be difficult to entirely erase the temporary non-encrypted
              password file after editing."
        SECURE_TMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/$template")"
        shred_tmpfile() {
            find "$SECURE_TMPDIR" -type f -exec $SHRED {} +
            rm -rf "$SECURE_TMPDIR"
        }
        trap shred_tmpfile INT TERM EXIT
    fi

}

cmd_edit() {
    local path="$1"
    tmpdir # Defines $SECURE_TMPDIR
    local tmp_file="$(mktemp -u "$SECURE_TMPDIR/XXXXX")-${path//\//-}.txt"
    if [ -f $KEYFILE ]; then
        $GPG "${GPG_OPTS[@]}" -o "$tmp_file" -d $KEYFILE
    fi

    ${EDITOR:-editor} "$tmp_file"
    [[ -f $tmp_file ]] || die "New password not saved."
    while ! $GPG -e -r $GPG_RECIPIENT -o "$KEYFILE" "${GPG_OPTS=[@]}" "$tmp_file"; do
        echo -n "GPG encryption failed. Would you like to try again? [Y/n] "
        read line
        if [ "$line" == "n" ]; then
           exit 1
        fi
    done
    echo "File $KEYFILE saved"
}


if [ "$1" == "edit" ]; then
    echo "editing file..."
    cmd_edit
    exit 0
fi

[[ -f $KEYFILE ]] || die "Can't find keyring file. Bail out."

scriptname=`basename $0`
if [ -z $1 ]
then
    echo "$scriptname: Service Name Required"
    echo ""
    echo "Usage:"
    echo "   otp google [-c]"
    echo ""
    echo "Configuration: $KEYFILE"
    echo "Format: name=key"
    echo "-c : copy directly into clipboad"
    exit
fi

otpkey=` gpg --quiet -d $KEYFILE | grep ^$1 | cut -d"=" -f 2 | sed "s/ //g" `
if [ -z $otpkey ]
then
    echo "$scriptname: Bad Service Name"
    exit
fi

otp=`oathtool --totp -b $otpkey | tr -d '\n'`
if [ "$2" == "-c" ]; then
    echo -n $otp | xclip -sel clip
fi
echo $otp

exit 0
