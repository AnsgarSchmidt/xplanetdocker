FROM ubuntu:18.04

ENV TZ 'Europe/Berlin'
RUN echo $TZ > /etc/timezone                       && \
    apt update                                     && \
    apt install -y tzdata xplanet curl             && \
    rm /etc/localtime                              && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata      && \
    apt clean

ADD  http://xplanet.sourceforge.net/Extras/night_jk.jpg /usr/share/xplanet/images/night.jpg
COPY earth /etc/xplanet/markers/earth
COPY xplanet.conf xplanet.conf
COPY build.sh build.sh

VOLUME /xplanet

CMD /build.sh
