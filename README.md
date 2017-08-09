### A simple CLI tool for generating OTP for 2FA

### What's this

A simple command line tool to generate a [One Time Password](https://en.wikipedia.org/wiki/One-time_password) to perform [Two-Factor Authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication), something everyone should use when available.

### Why

I've always used [Google Authenticator](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2) to generate OTP tokens. Now my phone has died. Since I'm always at a command line, an easy way to generate OTPs is using the same workstation I'm already on.

**Pay attention that in order to generate an OTP, a secret key stored on the computer/device is needed. If this key is stolen, anyone can generate keys for you.**

In order to mitigate this security issue, the keys should be stored an encrypted with GPG with a passphrase.

#### Installation and configuration
* Install [oathtool](http://www.nongnu.org/oath-toolkit)
* Install [xclip](https://linux.die.net/man/1/xclip)
* Configure your GPG recipient in the script, editing `GPG_RECIPIENT="<YOUR_RECIPIENT@DOMAIN.NAME>"`
* Tested on Linux

#### Usage
 - `otp.sh edit` to edit or create the keyring.
    Key format is "KEYNAME=aaabbbccc", ex. "amazon=aaabbbccc"
 - `otp.sh service_name` to generate an OTP for the service
 - `otp.sh service_name -c` to copy the key directly into the main clipboad

#### Credits

- This kind guy on [superuser](https://superuser.com/questions/462478/is-there-a-google-authenticator-desktop-client/853318#853318) that triggered the idea
- [pass](https://linux.die.net/man/1/pass): a great utility to store securely your passwords offline, don't use cloud keyrings such as LastPass. Some code is verbatim borrowed from that script.
- My foolishness to push me to break my smartphone, so I discovered and learned something interesting.
