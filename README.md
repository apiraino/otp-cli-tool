### A simple CLI tool for generating OTP for 2FA

### What's this

A simple command line tool to generate a [One Time Password](https://en.wikipedia.org/wiki/One-time_password) to perform
[Two-Factor Authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication), __something everyone should use if available__.

### Why

Since I'm always at a command line, an easy way to generate OTPs is using the same workstation I'm already on.

**Pay attention that in order to generate an OTP, a secret key stored on the computer/device is needed. If this key is stolen, anyone can generate keys for you.**

In order to mitigate this security issue, the keys should be stored as encrypted with GPG with a passphrase.

#### Installation and configuration
* Install [oathtool](http://www.nongnu.org/oath-toolkit) for the OTP generate function
* Install [yq](https://github.com/mikefarah/yq/releases) to parse the config files
* If using automatic clipboard action install [xclip](https://linux.die.net/man/1/xclip)
* Install [gpg](https://gnupg.org) to be able to encrypt the key file
* Configure your GPG recipient in the script, editing `GPG_RECIPIENT="<YOUR_RECIPIENT@DOMAIN.NAME>"`
* If using the QR code print function install [qrc](https://github.com/fumiyas/qrc)

#### Usage
 - `otp -a edit` to edit or create the keyring.
    The format for the config file is stored in YAML, and a sample looks like this

```
gmail:
  # valid totp or hotp
  type: totp
  # the key, no spaces
  otpSecret: aaabbbcccddd111222333
  # in case scaned in an app
  label: office@domain.tld
  # for the logo
  issuer: gmail
```
    For a valid issuer list check for example https://github.com/bilelmoussaoui/Authenticator/blob/master/data/data.json

    The keyring default place will be `$HOME/.otpkeys.gpg`
 - `otp service_name` to generate an OTP for the service
 - `otp service_name -a print-and-copy` to copy the key directly into the main clipboad

### Credit

 - This kind guy on [superuser](https://superuser.com/questions/462478/is-there-a-google-authenticator-desktop-client/853318#853318) that triggered the idea
 - [pass](https://linux.die.net/man/1/pass): a great utility to store securely your passwords offline, don't use cloud keyrings such as LastPass or any other similar product. Some code is verbatim borrowed from that script.
