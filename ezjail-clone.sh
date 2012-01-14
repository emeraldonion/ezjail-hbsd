#!/bin/sh

ezjail_dirlist="bin boot lib libexec rescue sbin usr/bin usr/include usr/lib usr/libdata usr/libexec usr/sbin usr/src usr/share usr/lib32 usr/ports"

ezjail_name=`uname -n`
ezjail_safename=`echo -n "${ezjail_name}" | tr -c '[:alnum:]' _`
ezjail_archive_tag="${ezjail_safename}-`date +%Y%m%d%H%M.%S`"
ezjail_archive="${ezjail_archive_tag}.tar.gz"
ezjail_archive_opt="-f `pwd -P`/${ezjail_archive}"

# Create soft links needed in all ezjails
mkdir -p /tmp/ezjail_fakeroot/usr /tmp/ezjail_fakeroot/basejail
for dir in ${ezjail_dirlist}; do
  ln -s /basejail/${dir} /tmp/ezjail_fakeroot/${dir}
done

# Construct regex that excludes directories from newjail
# Also excludes the directories themself, they will be added as softlinks
repl=""
for dir in ${ezjail_dirlist}; do
  repl="${repl} -s:^./${dir}/.*::p -s:^./${dir}$::p"
done

# Do not want to archive the archive itself
repl="${repl} -s:.*/${ezjail_archive}$::p"

# Must not archive content of /dev and /proc
repl="${repl} -s:^./dev/.*::p -s:^./proc/.*::p"

# Map the softlinks found in our fake root into the jails root
# exclude fakeroot's /usr
repl="${repl} -s:^./tmp/ezjail_fakeroot/usr$::p -s:^./tmp/ezjail_fakeroot/:ezjail/:p"

# Finally re-locate all files under ezjail/ so that the restore command find them
repl="${repl} -s:^\.:ezjail:p"

echo $repl

cd /
pax -wt -x cpio ${ezjail_archive_opt} ${repl} .
ezjail_paxresult=$?

rm -rf /tmp/ezjail_fakeroot/

#unset LANG LC_CTYPE
#find -dE / ! -regex "/(dev|proc|${ezjail_dirlist})/.*" -a ! -regex "/(${ezjail_dirlist})" -a ! -path /tmp/ezjail_fakeroot/usr -a ! -name "${ezjail_archive}" \
