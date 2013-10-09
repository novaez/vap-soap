#!/bin/bash

# install libs with RPMs
mkdir tmp
pushd tmp

libs[1]="zlib-1.2.3-7"
urls[1]="ftp://rpmfind.net/linux/centos/5.9/os/x86_64/CentOS/zlib-1.2.3-7.el5.x86_64.rpm"

libs[2]="zlib-devel-1.2.3-7"
urls[2]="ftp://rpmfind.net/linux/centos/5.9/os/x86_64/CentOS/zlib-devel-1.2.3-7.el5.x86_64.rpm"

libs[3]="libxml2-2.6.26-2.1.21"
urls[3]="ftp://rpmfind.net/linux/centos/5.9/updates/x86_64/RPMS/libxml2-2.6.26-2.1.21.el5_9.3.x86_64.rpm"

libs[4]="libxml2-devel-2.6.26-2.1.21"
urls[4]="ftp://rpmfind.net/linux/centos/5.9/updates/x86_64/RPMS/libxml2-devel-2.6.26-2.1.21.el5_9.3.x86_64.rpm"

for index in 1 2 3 4
do
    result=$(rpm -qa | grep ${libs[$index]})
    if [ -z "$result" ]
    then
        wget ${urls[$index]}
    fi
done

if [ -n "$(find . -maxdepth 1 -name '*.rpm' -print -quit)" ]
then
    rpm -Uvh *.rpm
fi

popd
rm -rf tmp

# install Perl modules
curl -kL http://cpanmin.us | perl - App::cpanminus

cpanm -q Test::Tester Test::NoWarnings Test::Deep  Log::Report XML::Compile XML::Compile::Cache XML::Compile::Tester XML::Compile::SOAP XML::Compile::SOAP::Daemon 
