FROM ubuntu:18.04
MAINTAINER Jussi Heikkilä <jussih@gmail.com>
ENV OTP_VERSION="22.1.8"
ENV OTP_HASH="7302be70cee2c33689bf2c2a3e7cfee597415d0fb3e4e71bd3e86bd1eff9cfdc"
ENV ELIXIR_VERSION="1.9.4"
ENV ELIXIR_HASH="f3465d8a8e386f3e74831bf9594ee39e6dfde6aa430fe9260844cfe46aa10139"
ENV NODE_VERSION="node_12.x"
ENV PHOENIX_VERSION="1.4.11"
ENV DISTRIBUTION="bionic"

# Fix locales
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install Erlang
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y build-essential gcc g++ libc6-dev m4 make libncurses5-dev openssl libssl1.0-dev autoconf git
RUN curl -fSL -o otp-src.tar.gz "https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz"
RUN echo "$OTP_HASH  otp-src.tar.gz" | sha256sum -c -
ENV ERL_TOP="/usr/local/src/erlang"
RUN mkdir -p $ERL_TOP
RUN tar -zxC $ERL_TOP -f otp-src.tar.gz --strip-components=1
RUN rm otp-src.tar.gz
RUN cd $ERL_TOP && ./otp_build autoconf && ./configure && make -j$(nproc) && make install

# Install Elixir
RUN curl -fSL -o elixir-src.tar.gz "https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz"
RUN echo "$ELIXIR_HASH  elixir-src.tar.gz" | sha256sum -c -
RUN mkdir -p /usr/local/src/elixir
RUN tar -zxC /usr/local/src/elixir/ -f elixir-src.tar.gz --strip-components=1
RUN rm elixir-src.tar.gz
RUN cd /usr/local/src/elixir/ && make && make install

# Install NodeJS
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRIBUTION main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRIBUTION main" | tee -a /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get -y install nodejs

# Install inotify-tools for live reload dev server
RUN apt-get -y install inotify-tools

# Create non-root user
# NOTE uid and gid should match the host user
RUN groupadd -g 1001 user && useradd --no-log-init -u 1001 -m -g user user

# Switch to non-root user. Commands here on will be executed as the new user.
USER user

# Install Hex
RUN mix local.hex --force

# Install Rebar
RUN mix local.rebar --force

# Install Phoenix tools
RUN mix archive.install --force hex phx_new $PHOENIX_VERSION

CMD ["iex"]
