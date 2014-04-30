# I know, this is ain't nice but an empty prefix leads to much confusion
# In most cases ezjail is being installed from ports anyway. If you REALLY REALLY
# want / as your install location, DO set PREFIX before invoking this Makefile

PREFIX?=/usr/local

all:

install:
	mkdir -p ${DESTDIR}${PREFIX}/etc/ezjail/ ${DESTDIR}${PREFIX}/man/man5/ ${DESTDIR}${PREFIX}/man/man7 ${DESTDIR}${PREFIX}/man/man8 ${DESTDIR}${PREFIX}/etc/rc.d/ ${DESTDIR}${PREFIX}/bin/ ${DESTDIR}${PREFIX}/share/examples/ezjail ${DESTDIR}${PREFIX}/share/zsh/site-functions
	cp -p ezjail.conf.sample ${DESTDIR}${PREFIX}/etc/
	cp -R -p examples/example ${DESTDIR}${PREFIX}/share/examples/ezjail/
	cp -R -p examples/nullmailer-example ${DESTDIR}${PREFIX}/share/examples/ezjail/
	cp -R -p share/zsh/site-functions/ ${DESTDIR}${PREFIX}/share/zsh/site-functions/
	sed s:EZJAIL_PREFIX:${DESTDIR}${PREFIX}: ezjail.sh > ${DESTDIR}${PREFIX}/etc/rc.d/ezjail
	sed s:EZJAIL_PREFIX:${DESTDIR}${PREFIX}: ezjail-admin > ${DESTDIR}${PREFIX}/bin/ezjail-admin
	sed s:EZJAIL_PREFIX:${DESTDIR}${PREFIX}: man8/ezjail-admin.8 > ${DESTDIR}${PREFIX}/man/man8/ezjail-admin.8
	sed s:EZJAIL_PREFIX:${DESTDIR}${PREFIX}: man5/ezjail.conf.5 > ${DESTDIR}${PREFIX}/man/man5/ezjail.conf.5
	sed s:EZJAIL_PREFIX:${DESTDIR}${PREFIX}: man7/ezjail.7 > ${DESTDIR}${PREFIX}/man/man7/ezjail.7
	chmod 755 ${DESTDIR}${PREFIX}/etc/rc.d/ezjail ${DESTDIR}${PREFIX}/bin/ezjail-admin
	chown -R root:wheel ${DESTDIR}${PREFIX}/man/man8/ezjail-admin.8 ${DESTDIR}${PREFIX}/man/man5/ezjail.conf.5 ${DESTDIR}${PREFIX}/man/man7/ezjail.7 ${DESTDIR}${PREFIX}/share/examples/ezjail/
	chmod 0440 ${DESTDIR}${PREFIX}/share/examples/ezjail/example/usr/local/etc/sudoers
