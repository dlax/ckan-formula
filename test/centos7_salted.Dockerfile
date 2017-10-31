FROM dlaxalde/centos7-salt-minion

ADD test/minion.conf /etc/salt/minion.d/minion.conf
ADD test/salt /srv/salt
ADD test/pillar /srv/pillar
ADD ckan /srv/formula/ckan
ADD solr /srv/formula/solr
ADD _states /srv/formula/_states
RUN salt-call -l debug --hard-crash state.highstate
