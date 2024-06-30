FROM ubuntu:20.04

#Update from repository
RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes

#Add locales
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes locales
RUN locale-gen uk_UA.UTF-8
RUN update-locale
ENV LANG=uk_UA.UTF-8

#Set POSTGRES variables
ENV PGDATA=/_data/pg_data

#Explicitly set user/group IDs and data dir
RUN groupadd -r postgres --gid=9999 ; \
    useradd -r -g postgres --uid=9999 postgres

#Install curl & wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes gnupg
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes curl
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes wget
#Install the repository PosrgesPRO-STD-13
RUN curl -o /opt/apt-repo-add.sh https://repo.postgrespro.ru/std/archive/std-13.4.1/keys/apt-repo-add.sh
RUN chmod +x /opt/apt-repo-add.sh
RUN sed -i "s|REPO=http://repo.postgrespro.ru/pgpro-archive/pgpro-13.4.1|REPO=https://repo.postgrespro.ru/std/archive/std-13.4.1|g" /opt/apt-repo-add.sh
RUN /opt/apt-repo-add.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes postgrespro-std-13-server postgrespro-std-13-contrib

#Change settings
RUN sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(logging_collector)\s*=\s*\S+.*!\1 = on!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(log_directory)\s*=\s*\S+.*!\1 = 'log'!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(lc_messages)\s*=\s*\S+.*!\1 = 'C.UTF-8'!" /opt/pgpro/std-13/share/postgresql.conf.sample

#Setup for start
ENV PATH $PATH:/opt/pgpro/std-13/bin
COPY container-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/container-entrypoint.sh

#Change user
USER postgres

EXPOSE 5432

ENTRYPOINT ["container-entrypoint.sh"]

CMD ["postgres"]
