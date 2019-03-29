ARG CUDA_VERSION
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu18.04

LABEL maintainer "Shoma Kokuryo <s-kokuryo@se.is.kit.ac.jp>"

ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND noninteractive

COPY init.sh /init.sh

RUN chmod u+x /init.sh

# Install base tools
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        python-dev \
        python-pip \
        python-setuptools \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libpng-dev \
        libjpeg8-dev \
        libfreetype6-dev \
        tzdata \
        git \
        sudo \
        software-properties-common && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get remove -y --purge tzdata && \
    apt-get clean -y && \
    apt-get autoremove -y

# Install sshd and configure LDAP auth
RUN mkdir -p /var/run/sshd && \
    apt-get install -y \
        openssh-server \
        libnss-ldap \
        libpam-ldap \
        ldap-utils \
        nslcd && \
    sed -i -e 's/^passwd:\(.*\)$/passwd:\1 ldap/g' /etc/nsswitch.conf && \
    sed -i -e 's/^group:\(.*\)$/group:\1 ldap/g' /etc/nsswitch.conf && \
    sed -i -e 's/^shadow:\(.*\)$/shadow:\1 ldap/g' /etc/nsswitch.conf && \
    apt-get clean -y && \
    apt-get autoremove -y

# Install some tools
RUN apt-add-repository ppa:neovim-ppa/stable && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        vim \
        neovim \
        less \
        tmux \
        screen \
        wget && \
    pip install --no-cache-dir pynvim && \
    pip3 install --no-cache-dir pynvim && \
    apt-get clean -y && \
    apt-get autoremove -y

EXPOSE 22

CMD ["/init.sh"]
