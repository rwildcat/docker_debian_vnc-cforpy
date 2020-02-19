# Debian-VNC-C+Fortran+Python

A personal Linux workstation based on [Debian](https://hub.docker.com/_/debian). Provides tools for C/C++, Fortran and Python developing.

Includes Python2, Python3, C/C++, Fortran;  [Jupyter](https://jupyter.org), [Spyder](https://www.spyder-ide.org),  [VS Code](https://code.visualstudio.com) and [NetBeans](https://netbeans.org).

Based on the [rsolano/debian-vnc-python](https://hub.docker.com/r/rsolano/debian-vnc-python) docker image.

*Ramon Solano <<ramon.solano@gmail.com>>*

**Last update:** Feb/19/2020   
**Debian version:** 10.2


## Main packages

* VNC, SSH
* Python[2,3]
	* Modules: Numpy, Matplotlib, Pandas, SciPy, Plotly
* IPython[2,3]
* Jupyter Notebook[2,3]
* Spyder IDE[2,3]
* MS Visual Studio Code (C, Fortran)
* Firefox
* C (gcc)
	* [GNU Scientific Library (GSL)](https://www.gnu.org/software/gsl/doc/html/index.html)
* Fortran (gfortran)
	* [OGPF Plotting library](https://github.com/kookma/ogpf)
	* [Open Coarrays](https://github.com/sourceryinstitute/OpenCoarrays#overview) HPC multithread library
* Netbeans (C, Fortran)


## Users

| User | Password|
| --- | --- |
| root | debian |
| debian | debian (sudoer) |


## Usage (synopsis)

Usage is split in two main sections:

* Docker image usage
* Python usage


### Docker image usage

1. Download (*pull*) the image from its [docker hub repository](https://cloud.docker.com/u/rsolano/repository/docker/rsolano/debian-vnc-cforpy) (optional):
   
	```sh
	$ docker pull rsolano/debian-vnc-cforpy
	```
   
2. Run the container (the image will be *pulled* first if not previously downloaded).

	For example:

	* To run an ephemeral VNC session (port 5900):

		```sh
	   $ docker run --rm -p 5900:5900 rsolano/debian-vnc-cforpy
	   ```
	   
	* To run an ephemeral VNC + SSH session (port 5900 and 2222):

		```sh
	   $ docker run --rm -p 5900:5900 -p 2222:22 rsolano/debian-vnc-cforpy
	   ```

	* To run an ephemeral VNC + SSH session (port 5900 and 2222), and mounting my personal `$HOME/Documents` directory into remote `/Documents` :

		```sh
	   $ docker run --rm -p 5900:5900 -p 2222:22 -v HOME/Documents:/Docuents rsolano/debian-vnc-cforpy
	   ```

3. Use a VNC Viewer (such as the [RealVNC viewer](https://www.realvnc.com/en/connect/download/viewer/)) to connect to the host server (usually the `localhost`), port 5900:

	```
	localhost:5900
	```

### Python usage

| Program  | Python2      | Python3      |
| -------- | :----------- | :----------- |
| Python  | `$ python2`   | `$ python3`  |
| IPython  | `$ ipython2` | `$ ipython3` |
| Spyder   | `$ spyder`   | `$ spyder3`  |
| PIP      | `$ pip2`     | `$ pip3`     |

**Jupyter Notebook**

| Mode					  | Command 							|
| --- 					  | --- 								|
| Local usage (localhost) | `$ jupyter-notebook --ip 127.0.0.1` |
| Public usage (network): | `$ jupyter-notebook --ip 0.0.0.0` 	|

### Fortran Coarrays usage

| Action     | Command                              |
| ---------- | ------------------------------------ |
| To compile | `$ caf [-o <progexe>] <progsrc.f90>` |
| To run     | `$ cafrun -np <nproc> <progexe>`     |


### OGPF graphics library usage

| Action         | Command                              |
| -------------- | ------------------------------------ |
| Source program | `use ogpf`
| To compile     | `$ gfortran -I/usr/lib [-o <progexe>] <progsrc.f90> -logpf` |


## To build the image from the `Dockerfile` (optional, for Dockerfile developers)

If you want to customize the image or use it for creating a new one, you can download (clone) it from the [corresponding github repository](https://github.com/rwildcat/docker_debian-vnc-cforpy). 

```sh
# clone git repository
$ git clone https://github.com/rwildcat/docker_debian-vnc-cforpy.git

# build image
$ cd docker_debian-vnc-cforpy
$ docker build -t rsolano/debian-vnc-cforpy .
```

Otherwise, you can *pull it* from its [docker hub repository](https://cloud.docker.com/u/rsolano/repository/docker/rsolano/debian-vnc-cforpy):

```
$ docker pull rsolano/debian-vnc-cforpy
```

**NOTE:** If you run the image without downloading it first (*e.g.* with `$docker run ..`), Docker will *pull it* from the docker repository for you if it does not exist in your local image repository.


## To run the container (full syntax)

```
$ docker run [DBGFIX] [-it] [--rm] [--detach] [-h HOSTNAME] [-p LVNCPORT:5900] [-p LSSHPORT:22] [-p LNOTEBOOKPORT:8888] [-v LDIR:DIR] [-e XRES=1280x800x24] rsolano/debian-vnc-cforpy
```

where:

* `DBGFIX`: Workarond for gdb error "`Error disabling address space randomization: Operation not permitted
`". There are at least two options:

	* `--security-opt`: Modify the container's Secure computing mode:

		```
		$ docker run --security-opt seccomp=unconfined [--cap-add=SYS_PTRACE] ...
		```

	* `--privileged`: Elevate the entire container privilege (may not be available on cloud servers):
	
		```
		$ docker run --privileged ...
		```


* `LVNCPORT`: Localhost VNC port to connect to (e.g. 5900 for display :0).

* `LSSHPORT`: local SSH port to connect to (e.g. 2222, as ports below 1024 may be reserved by your system).

* `XRES`: Screen resolution and color depth (e.g. 2560x1440x24, 2304x1440x24, 1024x768x24, etc).

* `LNOTEBOOKPORT`: Local HTTP Jupyter Notebook port to connecto to (e.g. 8888). Requires IP=0.0.0.0 when running Jupyter in your container for connecting from your locahost, otherwise IP=127.0.0.1 for internal access only.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/debian/workspace`.

### Usage examples

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

* Run image, detach to background and keep running in memory (control returns to user immediately); map VNC to 5900; mount local `$HOME/workspace` directory as `/home/debian/workspace` remote directory and `$HOME/NetBeansProjects` as `/home/debian` NetBeansProjects:

	```sh
	$ docker run --detach -p 5900:5900 -v $HOME/workspace:/home/debian/workspace -v $HOME/NetBeansProjects:/home/debian rsolano/debian-vnc-cforpy
	```

#### To run a ***secured*** VNC session

This container is intended to be used as a *personal* graphic workstation, running in your local Docker engine. For this reason, no encryption for VNC is provided. 

If you need to have an encrypted connection as for example for running this image in a remote host (*e.g.* AWS, Google Cloud, etc.), the VNC stream can be encrypted through a SSH connection:

```sh
$ ssh [-p SSHPORT] [-f] -L 5900:REMOTE:5900 debian@REMOTE sleep 60
```
where:

* `SSHPORT`: SSH port specified when container was launched. If not specified, port 22 is used.

* `-f`: Request SSH to go to background afte the command is issued

* `REMOTE`: IP or qualified name for your remote container

This example assume the SSH connection will be terminated after 60 seconds if no VNC connection is detected, or just after the VNC connection was finished.

**EXAMPLES:**

* Establish a secured VNC session to the remote host 140.172.18.21, keep open a SSH terminal to the remote host. Map remote 5900 port to local 5900 port. Assume remote SSH port is 22:

	```sh
	$ ssh -L 5900:140.172.18.21:5900 debian@140.172.18.21
	```

* As before, but do not keep a SSH session open, but send the connecction to the background. End SSH channel if no VNC connection is made in 60 s, or after the VNC session ends:

	```sh
	$ ssh -f -L 5900:140.172.18.21:5900 debian@140.172.18.21 sleep 60
	```

Once VNC is tunneled through SSH, you can connect your VNC viewer to you specified localhot port (*e.g.* port 5900 as in this examples).



## To stop container

* If running an interactive session  (option `--it`):

  * Just press `CTRL-C` in the interactive terminal.

* If running a non-interactive session (no  `--it` nor `--detach` options provided):

  * Just press `CTRL-C` in the console (non-interactive terminal).


* If running *detached* (background) session (option `--detach` provided):

	1. Look for the `Container Id` with the command `docker ps`:   
	
		```
		$ docker ps
		CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                          NAMES
		ac46f0cf41d1        rsolano/debian-vnc-python   "/usr/bin/supervisor…"   58 seconds ago      Up 57 seconds       0.0.0.0:5900->5900/tcp, 0.0.0.0:2222->22/tcp   wizardly_bohr
		```

	2. Stop the desired container Id (`ac46f0cf41d1` in this case):

		```
		$ docker stop ac46f0cf41d1
		```

**NOTES:**

* A stopped contained remains *hybernating* in your computer, similar to a laptop when it is closed. All data and program remain.

	*Warning*: all programs will be closed.

* A stopped container can be *waked up* or *launched* again with the command `docker start`. For example:

	```
	$ docker start ac46f0cf41d1
	```

* You can list all *running* containers with the command `docker ps`.

* You can list all *stopped* containers with the command ` docker ps -a`.

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
			