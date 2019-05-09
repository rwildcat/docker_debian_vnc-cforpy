# Debian-based VNC C+Fortran+Python dev wokstation
# Updated on 2019-05-09
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-vnc-python

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update -q \
	&& apt-get install -qy gfortran gdb cmake libtool autoconf \
	gnuplot gawk pkg-config libgsl-dev vim nano curl \
	&& apt-get clean

RUN \	
	# openjdk
	mkdir -p /usr/share/man/man1 \
	&& apt install -y default-jdk \
	\
	# netbeans
	&& wget -q -O /tmp/netbeans.sh https://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-cpp-linux-x64.sh \
	&& DISPLAY=:1 bash /tmp/netbeans.sh --silent \
	&& rm -rf /var/lib/apt/lists/* /tmp/*

# personal stuff
USER debian

# vscode extensions
RUN code --install-extension ms-vscode.cpptools \ 	
	&& code --install-extension krvajalm.linter-gfortran \
	&& code --install-extension DavidAnson.vscode-markdownlint \
	&& rm -rf /tmp/*

# return to root
USER root
	
# add local config files
ADD etc /etc

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
