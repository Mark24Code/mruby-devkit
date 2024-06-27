FROM alpine:latest

RUN apk update
RUN apk add \
  build-base tzdata \
  ruby-dev \
  git curl wget openssh
RUN echo "Asia/Shanghai" >  /etc/timezone
RUN apk add ruby
RUN gem install bundler
RUN gem install rake


RUN git clone https://github.com/Mark24Code/mruby-devkit.git
RUN cd mruby-devkit && rake build

