# Install chrome browser
## Chrome Repos

### google-chrome.repo

[google-chrome]
name=google-chrome

baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64

enabled=1

gpgcheck=1

gpgkey=https://dl.google.com/linux/linux_signing_key.pub

### google-chrome-mirrors.repo

[google-chrome-mirrors]

name=Google Chrome mirrors

**#baseurl=https://dl.google.com/linux/chrome/rpm/stable/$basearch**

**#gpgkey=https://dl.google.com/linux/linux_signing_key.pub**

baseurl=https://repo.fdzh.org/chrome/rpm/$basearch

gpgkey=https://repo.fdzh.org/chrome/linux_signing_key.pub

gpgcheck=1

enabled=1

skip_if_unavailable=1

