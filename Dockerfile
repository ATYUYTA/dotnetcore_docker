FROM microsoft/dotnet:1.0.5-runtime
MAINTAINER Azure App Services Container Images <appsvc-images@microsoft.com>

COPY bin.zip /tmp
COPY init_container.sh /bin/
COPY hostingstart.html /home/site/wwwroot/
COPY sshd_config /etc/ssh/

RUN apt-get update \
  && apt-get install -y apt-utils --no-install-recommends \
  && apt-get install -y unzip --no-install-recommends \
  && apt-get install nuget \
  && apt-get update && apt-get install -y curl apt-transport-https  \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn \
  && mkdir -p /defaulthome/hostingstart \ 
  && unzip -q -o /tmp/bin.zip -d /defaulthome/hostingstart \
  && rm /tmp/bin.zip \
  && echo "root:Docker!" | chpasswd \
  && apt update \
  && apt install -y --no-install-recommends openssh-server \
  && chmod 755 /bin/init_container.sh \
  && mkdir -p /home/LogFiles/ 

EXPOSE 2222 8080

ENV PORT 8080
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance

WORKDIR /home/site/wwwroot

ENTRYPOINT ["/bin/init_container.sh"]