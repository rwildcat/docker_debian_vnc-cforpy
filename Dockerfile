# Debian-based VNC C+Fortran+Python dev wokstation
#
# Updated on 2020-02-19
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-vnc-python:10.2

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -q update \
	&& apt-get -qy upgrade \
	&& apt-get -qy install gfortran gdb cmake libtool autoconf \
	   gnuplot gawk pkg-config libgsl-dev nano curl \
	   mpich \ 
	&& apt-get clean

# opencoarrays
RUN cd /tmp \
	&& git clone https://github.com/sourceryinstitute/OpenCoarrays.git \
	&& cd OpenCoarrays \
	&& mkdir build \
	&& cd build \
	&& CC=gcc cmake .. \
	&& make \
	&& make test \
	&& make install

# netbeans
RUN \
	# openjdk
	mkdir -p /usr/share/man/man1 \
	&& apt install -y default-jdk \
	# netbeans
	&& wget -q -O /tmp/netbeans-install.sh https://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-cpp-linux-x64.sh \
	&& DISPLAY=:1 bash /tmp/netbeans-install.sh --silent

# ogpf - fortran plotting wrap for gnuplot
# usage: gfortran -I/usr/include <progname>.f90 -logpf
USER debian
RUN cd /tmp \
	&& git clone https://github.com/kookma/ogpf.git \
	&& cd ogpf \
	&& sed -i 's/\.exe//; s/-Wall//' Makefile \
	&& make \
	&& ar -crs libogpf.a obj/Debug/ogpf.o \
	&& cd /

# ogpf install
USER root
RUN cp /tmp/ogpf/obj/Debug/ogpf.mod /usr/include \
	&& cp /tmp/ogpf/libogpf.a /usr/lib

# vscode extensions
USER debian
RUN code --install-extension ms-vscode.cpptools \ 	
	&& code --install-extension krvajalm.linter-gfortran \
	&& code --install-extension DavidAnson.vscode-markdownlint

# return to root
USER root

# clean
RUN rm -rf /var/lib/apt/lists/*  \
	&& rm -rf /tmp/*

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
