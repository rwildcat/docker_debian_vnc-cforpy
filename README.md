# Debian-VNC-CForPy

A Linux workstation based on [Debian](https://hub.docker.com/_/debian). Provides tools for C, Fortran and Python developing, including [NetBeans](https://netbeans.org), [VS Code](https://code.visualstudio.com) and [Jupyter](https://jupyter.org).

Based on the [rsolano/debian-vnc-python](https://hub.docker.com/r/rsolano/debian-vnc-python) docker image.

*Ramon Solano (ramon.solano at gmail.com)*

**Last update:** May/07/2019

## Main packages

* VNC, SSH [1]
* Python[2,3] [2]
* Modules: Numpy, Matplotlib, Pandas, SciPy [2]
* IPython [2]
* Jupyter Notebook [2]
* Spyder IDE [2]
* MS Visual Studio Code [2]
* Firefox [2]
* C
* Fortran
* Netbeans (C, Fortran)
* C and Fortran plugins for MS Visual Studio Code

[1]: Inherited from [rsolano/debian-slim-vnc](https://hub.docker.com/r/rsolano/debian-slim-vnc).   
[2]: Iherited from [rsolano/debian-vnc-python](https://hub.docker.com/r/rsolano/debian-vnc-python).




## Users

User/pwd:

* root / debian
* debian / debian (sudoer)

## To build from `Dockerfile`

```sh
$ docker build -t rsolano/debian-vnc-cforpy .
```

## To run container

```
$ docker run [DBGFIX] [-it] [--rm] [--detach] [-h HOSTNAME] -p LVNCPORT:5900 -p LSSHPORT:22 -p LNOTEBOOKPORT:8888 [-v LDIR:DIR] [-e XRES=1280x800x24] rsolano/debian-vnc-cforpy
```

where:

* `DBGFIX`: Workarond for gdb error : `disabling address space randomization: Operation not permitted address space layout randomization`. There are at least two options:

	* Elevate the entire container privilege (may not be available on cloud servers). Run :
	
		```
		$ docker run --privileged ...
		```

	* Modify the container's Secure computing mode:

		```
		$ docker run --security-opt seccomp=unconfined [--cap-add=SYS_PTRACE] ...
		```


* `LVNCPORT`: Localhost VNC port to connect to (e.g. 5900 for display :0).

* `LSSHPORT`: local SSH port to connect to (e.g. 2222, as *well known ports* (those below 1024) may be reserved by your system).

* `XRES`: Screen resolution and color depth (e.g. 2560x1440x24, 2304x1440x24, 1024x768x24, etc).

* `LNOTEBOOKPORT`: Local HTTP Jupyter Notebook port to connecto to (e.g. 8888). Requires IP=0.0.0.0 when running Jupyter in your container for connecting from your locahost, otherwise IP=127.0.0.1 for internal access only.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/debian/workspace`.

### Examples

* Run container, keep terminal open (interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, no Jupyter Notebooks:

	```sh
	$ docker run -it --rm -p 5900:5900 -p 2222:22 rsolano/debian-vnc-cforpy
	```

* Run image, keep terminal open (interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, map Jupyter Notebooks to 8888; mount local `$HOME/workspace` on container's `/home/debian/workspace`:

	```sh
	$ docker run -it --rm -p 5900:5900 -p 2222:22 -p 8888:8888 -v $HOME/workspace:/home/debian/workspace rsolano/debian-vnc-cforpy
	```

* Run image, keep *console* open (non-interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, map Jupyter Notebooks to 8888:

	```sh
	$ docker run --rm -p 5900:5900 -p 2222:22  -p 8888:8888 rsolano/debian-vnc-cforpy
	```

* Run image, detach to background and keep running in memory (control returns to user immediately); map VNC to 5900 and SSH to 2222; map Jupyter Notebooks to 8888; change screen resolution to 1200x700x24

	```sh
	$ docker run --detach -p 5900:5900 -p 2222:22 -p 8888:8888 -e XRES=1200x700x24 rsolano/debian-vnc-cforpy
	```

**NOTES**

* Some graphical programs such as `Firefox`, `Spyder` and `Netbeans` can be ran by copying their corresponding icons from  `/usr/share/applications` to your desktop.

* Alternatively, you can find all your installed graphical applications from the `Application Finder` Panel dock (located just before your home folder icon).

## To stop container

* If running an interactive session:

  * Just press `CTRL-C` in the interactive terminal.

* If running a non-interactive session:

  * Just press `CTRL-C` in the console (non-interactive) terminal.


* If running *detached* (background) session:

	1. Look for the container Id with `docker ps`:   
	
		```
		$ docker ps
		CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                          NAMES
		ac46f0cf41d1        rsolano/debian-vnc-python   "/usr/bin/supervisor…"   58 seconds ago      Up 57 seconds       0.0.0.0:5900->5900/tcp, 0.0.0.0:2222->22/tcp   wizardly_bohr
		```

	2. Stop the desired container Id (ac46f0cf41d1 in this case):

		```sh
		$ docker stop ac46f0cf41d1
		```

 ## Container usage
 
1. First run the container as described above.

2. Connect to the running host (`localhost` if running in your computer):

	* Using VNC (workstation general access): 

		Connect to specified LVNCPORT (e.g. `localhost:0` or `localhost:5900`)
		 
	* Using SSH: 

		Connect to specified host (e.g. `localhost`) and SSHPORT (e.g. 2222) 
		
		```sh
		$ ssh -p 2222 debian@localhost
		```
	* Using Web browser (Jupyter Notebook general access): 

		1. First run the container and export the Jupyter IP port 8888 to a port on your host (e.g. if using 8888, specify at tun time:  `-p 8888:8888`).
		2. Login to the container and run Jupyter Notebook on the public network interface (IP=0.0.0.0).
		2. Connect to host computer (e.g. your localhost) and specified LVNCPORT (e.g. 8888):
		
		```http://localhost:8888```
		 


## Additional files

    ./etc/supervisor.conf

### File contents:    

	[supervisord]
	nodaemon = true
	user = root
	#loglevel = debug
	
	[program:sshd]
	command = /usr/sbin/sshd -D
	
	[program:xvfb]
	command = /usr/bin/Xvfb :1 -screen 0 %(ENV_XRES)s
	priority=100
	
	[program:x11vnc]
	environment = DISPLAY=":1",XAUTHLOCALHOSTNAME="localhost"
	command=/usr/bin/x11vnc -repeat -xkb -noxrecord -noxfixes -noxdamage -wait 10 -shared -permitfiletransfer -tightfilexfer
	autorestart = true
	priority=200 
	
	[program:startxfce4]
	environment=USER="debian",HOME="/home/debian",DISPLAY=":1"
	command=/usr/bin/startxfce4
	directory = /home/debian
	user=debian
	priority=300
