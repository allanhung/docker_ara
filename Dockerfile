FROM centos:7

ENV MYSQL_HOST myhost
ENV MYSQL_DB ara
ENV MYSQL_USER ara
ENV MYSQL_PASSWORD ara
ENV ARA_LISTEN_PORT 9191

RUN yum install -y epel-release
RUN yum install -y ansible openssh-clients python python-devel python-pip python-docopt python-winrm python-pbr gcc git
RUN yum clean all
RUN pip install -q setuptools --upgrade
RUN pip install -q ara==0.16.5 pymysql uwsgi

COPY ara_uwsgi.ini /etc/ansible
COPY mime.types /etc

RUN ARA_LOCATION=$(python -c "import os,ara; print(os.path.dirname(ara.__file__))") && \
    ANSIBLE_LOCATION=$(python -c "import os,ansible; print(os.path.dirname(ansible.__file__))") && \
    ARA_LOCATION=$(python -c "import os,ara; print(os.path.dirname(ara.__file__))") && \
    echo -e "[defaults]\naction_plugins=$ARA_LOCATION/plugins/action\ncallback_plugins = $ARA_LOCATION/plugins/callbacks" > /etc/ansible/ansible.cfg && \
    echo -e "\n\n[ara]\ndatabase=mysql+pymysql://$(MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DB}&binary_prefix=True" >> /etc/ansible/ansible.cfg && \
    cp /usr/bin/ara-wsgi /etc/ansible/wsgi.py && \
    sed -i -e "s/ARA_LISTEN_PORT/$ARA_LISTEN_PORT/g" /etc/ansible/ara_uwsgi.ini

EXPOSE $ARA_LISTEN_PORT

CMD ["uwsgi","--ini","/etc/ansible/ara_uwsgi.ini","--mime-file","/etc/mime.types"]
