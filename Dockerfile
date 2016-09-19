FROM golang:wheezy

# install pagkages
RUN apt-get update                                                      && \
    apt-get install -y ncurses-dev libtolua-dev exuberant-ctags         && \
    cd /tmp                                                             && \
# build and install vim
    git clone https://github.com/vim/vim.git                            && \
    cd vim                                                              && \
    ./configure --with-features=huge 			     	                    \
        --enable-gui=no --without-x --prefix=/usr                       && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim74                             && \
    make install                                                        && \
    rm -rf /tmp                                                         && \
    apt-get remove ncurses-dev libtolua-dev

# add dev user
RUN adduser dev --disabled-password --gecos ""                          && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers     && \
    chown -R dev:dev /home/dev /go                                      

# dev config
USER dev
ENV HOME /home/dev

# get dotfiles
RUN cd $HOME                                                            && \
    git clone https://github.com/adamryman/dotfiles --depth 1
