FROM fedora:23

MAINTAINER Paolo Patierno <ppatierno@live.com>

# required dependencies
RUN dnf -y install gcc make cmake libuuid-devel

# dependencies needed for ssl support
RUN dnf -y install openssl-devel

# dependencies needed for Cyrus SASL support
RUN dnf -y install cyrus-sasl-devel

# dependencies needed for Python binding
RUN dnf -y install swig python-devel

# set Qpid Proton library version
ENV PROTON_VERSION 0.12.1

# downloading/extracting Qpid Proton library
RUN dnf -y install wget
RUN dnf -y install tar
RUN wget http://apache.panu.it/qpid/proton/$PROTON_VERSION/qpid-proton-$PROTON_VERSION.tar.gz
RUN tar xvfz qpid-proton-$PROTON_VERSION.tar.gz

# build Qpid Proton library
RUN mkdir /qpid-proton-$PROTON_VERSION/build
WORKDIR /qpid-proton-$PROTON_VERSION/build

RUN cmake .. -DSYSINSTALL_BINDINGS=ON -DCMAKE_INSTALL_PREFIX=/usr && make install

WORKDIR /
CMD ["bash"]
