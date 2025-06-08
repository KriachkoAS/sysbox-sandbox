# development sandbox

Project meant to be used as [Sysbox](https://github.com/nestybox/sysbox) based sandbox for development.
This [Dockerfile](https://github.com/nestybox/dockerfiles/blob/f27a6f2b4a97377f932968d2897ba1603680036a/ubuntu-noble-systemd-docker/Dockerfile)
and it`s dependencies being used as base of project. Added installation of Visual Studio Code, importing Git configuration, mounting of
specific workspace, script for easy start and Ssh configuration consistance.

## use

Usage quite complicated and probably longer to describe then rewrite project, so simplified version:
  - rewrite Dockerfile by commenting new parts and uncomment them back as you ready to check them
  - copy `/etc/ssh` from working sandbox for use as consistent fingerprint
  - config Ssh client to use sandbox with the same key that is added to auhtentic ones
  - add rewrited `run.sh` script to any folder in `$PATH` and run it with Sudo