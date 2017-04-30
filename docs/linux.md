## Linux

#### Contents
- [Install Swift on Linux](#install-swift-on-linux)
- [Install and run CouchDB](#install-and-run-couchdb)
- [Run server swift](#run-server-swift)

#### Install Swift on Linux
1. Install packages:
```
sudo apt-get install build-essential clang git libpython2.7 libicu-dev wget libcurl4-openssl-dev vim libxml2 openssl libssl-dev pkg-config curl
```
2. Download Swift source from swift.org for current version of Ubuntu (last release):
```
wget https://swift.org/builds/swift-3.1.1-release/ubuntu1604/swift-3.1.1-RELEASE/swift-3.1.1-RELEASE-ubuntu16.04.tar.gz
```
3. Extract archive, delete archive, rename directory for shorter name:
```
tar -zxvf swift-3.1.1-RELEASE-ubuntu16.04.tar.gz
rm swift-3.1.1-RELEASE-ubuntu16.04.tar.gz
mv swift-3.1.1-RELEASE-ubuntu16.04 swift-3.1.1
```
4. Add Swift to PATH:
```
cd ~
nano .bash_profile
alias ls='ls --color=auto'
export PATH=/root/swift-3.1.1/usr/bin:"${PATH}"
```
5. Relogin to shell:
```
logout
```
6. Check access to Swift:
```
swift --version
```

#### Install and run CouchDB
1. Install and run CouchDB:
```
sudo apt-get install couchdb
/etc/init.d/couchdb start
```
2. Check couchdb:
```
curl http://localhost:5984
```

#### Run server swift
1. Build again each run:
```
swift package clean && swift build --configuration release && ./.build/release/FoodTruckServer
```
2. Build one time and then run:
```
swift build --configuration release
./.build/release/FoodTruckServer
```
