#
# Builds an image for running NTT's Corevo
#
# Reference:
# https://corevo-api-portal.xfarm.jp/resources/corevo_ASR_SDK_Development_Guide_for_Linux_en.pdf
#

FROM centos:6.8
MAINTAINER Raymond Oung (r.oung@hapi-robo.com)

# install necessary tools
RUN yum install -y -v wget perl unzip cmake curl-devel

# install gcc with C++11 support
# https://people.centos.org/tru/devtools-2/readme
RUN yum install -y -v gcc
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -P /etc/yum.repos.d/
RUN yum install -y -v devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++ devtoolset-2-gcc-gfortran

# install OpenSSL
RUN wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz -P /home/
RUN cd /home/ && tar xzf openssl-1.0.2j.tar.gz 
RUN cd /home/openssl-1.0.2j && ./config --prefix=/usr/local --openssldir=/usr/local/openssl shared 
RUN cd /home/openssl-1.0.2j && make
RUN cd /home/openssl-1.0.2j && make test 
RUN cd /home/openssl-1.0.2j && make install 
RUN cd /home/ && rm -f openssl-1.0.2j.tar.gz

# install Boost
RUN wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz -P /home/
RUN cd /home/ && tar xzf boost_1_59_0.tar.gz

# download NTT's Corevo SDK
RUN wget https://corevo-api-portal.xfarm.jp/resources/corevo_ASR_SDK_for_Linux_v1.0.1.0.zip -P /home/
RUN cd /home/ && unzip corevo_ASR_SDK_for_Linux_v1.0.1.0.zip
COPY CMakeLists.txt /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/src/

# copy .sh file with credentials (added to .gitignore)
COPY AsrTestDriver.sh /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/bin/

# build NTT's Corevo testDriver
RUN cd /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/src/ && mkdir build && cd build && source /opt/rh/devtoolset-2/enable && cmake ../ && make
RUN cp /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/src/build/bin/AsrTestDriver /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/bin/.
RUN cd /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/bin/ && chmod u+x AsrTestDriver.sh

# set environment variables
ENV VRG_CLIENT_CA_PATH=/etc/pki/tls/certs/ca-bundle.crt 
ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

# set working directory
WORKDIR /home/corevo_ASR_SDK_for_Linux_v1.0.1.0/testDriver/bin/