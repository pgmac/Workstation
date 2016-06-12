#!/bin/bash

if [ `id -u` -ne 0 ]
then
	echo "This must be run as root, or via sudo"
	exit 10
fi

fonts() {
	apt-get install fonts-droid
	apt-get install fonts-inconsolata
}

check_installed() {
	#echo "Checking if $1 is installed"
	apt-cache policy $1 | grep Installed 2>&1 > /dev/null
	RET=$?
	if [ $RET -eq 0 ]
	then
		echo "${APPNAME} is already installed.  Skipping."
		return 10
	else
		echo "Installing ${APPNAME}"
	fi
	echo -n ${RET}
}

i3() {
	echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
	apt-get update
	apt-get --allow-unauthenticated install sur5r-keyring
	apt-get update
	apt-get install i3
}

gnome() {
	apt-get install gnome devilspie
	gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
	#gsettings set org.gnome.desktop.wm.preferences auto-raise true
	#gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 0
	gsettings set org.gnome.desktop.wm.preferences focus-mode "mouse"
	gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
	gsettings set org.gnome.settings-daemon.plugins.xrandr active false
	# dconf write /org/gnome/settings-daemon/plugins/xrandr/active false
}

urxvt() {
	APPNAME=rxvt
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	APPNAME=rxvt-unicode
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	apt-get install rxvt rxvt-unicode
	#update-alternatives --set x-terminal-emulator /usr/bin/urxvt
}

dropbox() {
	APPNAME=dropbox
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	# Install Dropbox
	if [ -d	 /etc/apt/sources.list.d ]
	then
		echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main" >> /etc/apt/sources.list.d/dropbox.list
		#echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main"
	else
		echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main" >> /etc/apt/sources.list
		#echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main"
	fi
	sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
	apt-get update
	apt-get install dropbox
}

chrome() {
	APPNAME=google-chrome-stable
	#[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	# Install Google Chrome
	cd ~/Downloads
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome-stable_current_amd64.deb
	apt-get -f install
	rm google-chrome-stable_current_amd64.deb
	xdg-mime default google-chrome.desktop x-scheme-handler/http
	xdg-mime default google-chrome.desktop x-scheme-handler/https
	update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
	update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable
}

darktable() {
	APPNAME=darktable
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	# Install Darktable
	apt-add-repository ppa:pmjdebruijn/darktable-release
	apt-get update
	apt-get install darktable
	ln -s /home/paul/Dropbox/servers/config/darktable/ /home/paul/.config/darktable
}

pidgin() {
	add-apt-repository ppa:pidgin-gnome-keyring/ppa
	apt-get update
	apt-get install pidgin-gnome-keyring
}

apps() {
	apt-get install rxvt rxvt-unicode xdotool scrot cheese gimp youtube-dl handbrake handbrake-cli smbclient cifs-utils pidgin pidgin-sipe python-pip ec2-api-tools git icedtea-netx meld whois httpie weather-util traceroute evolution curl keepassx freerdp-x11
	pip install boto awscli
}

aws() {
	echo "Installing AWS"
	#export EC2_KEYPAIR=<your keypair name> # name only, not the file name
	#export EC2_URL=https://ec2.ap-southeast-2.amazonaws.com
	#export EC2_PRIVATE_KEY=$HOME/<where your private key is>/pk-XXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
	#export EC2_CERT=$HOME/<where your certificate is>/cert-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
	#export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/
}

oracle-java() {
	echo "Install Oracle Java"
	apt-add-repository ppa:webupd8team/java
	apt-get update
	apt-get install oracle-java8-installer
}

restrictedaudio() {
	apt-get install libdvdread4
	/usr/share/doc/libdvdread4/install-css.sh
	addgroup paul audio
}

openshot() {
	sudo add-apt-repository ppa:openshot.developers/ppa
	sudo apt-get update
	sudo apt-get install openshot openshot-doc
}

nagstamon() {
	cd ~/Downloads
	wget https://nagstamon.ifw-dresden.de/files-nagstamon/stable/nagstamon_1.0.1_all.deb
	dpkg -i nagstamon_1.0.1_all.deb
	rm nagstamon_1.0.1_all.deb
}

fitbit() {
	add-apt-repository ppa:cwayne18/fitbit
	apt-get update
	apt-get install galileo
	start galileo
}

calibre() {
	wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
}

atom() {
	nodejs
	apt-add-repository ppa:webupd8team/atom
	apt-get update
	apt-get install atom
}

nodejs() {
	curl -sL https://deb.nodesource.com/setup_0.12 | bash -
	apt-get install nodejs
}

ssh_config() {
	apt-get install openssh-server
	echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config
	echo "    ServerAliveInterval 120" >> /etc/ssh/ssh_config
	ssh-keygen
	ssh-copy-id marvin.pgmac.net
	ssh-copy-id samadams.int.mt
	ssh-copy-id bluetongue.web.mt
	ssh-copy-id raddler.web.mt
	ssh-copy-id hopinator.web.mt
	ssh-copy-id growler.web.mt
	ssh-copy-id bintang.web.mt
	ssh-copy-id fireship.canstar.internal
	ssh-copy-id colony.canstar.internal
	ssh-copy-id webtest.canstar.internal
	ssh-copy-id webtest2.canstar.internal
}

hipchat() {
	# Previous hipchat version
	#echo "deb http://downloads.hipchat.com/linux/apt stable main" > /etc/apt/sources.list.d/atlassian-hipchat.list
	#wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
	#apt-get update
	#apt-get install hipchat
	# HipChat 4
	sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
	wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install hipchat4
}

if [ $# -eq 0 ]
then
	i3
	urxvt
	dropbox
	apps
	chrome
	darktable
	restrictedaudio
	openshot
	pidgin
	nagstamon
	ssh_config
else
	$1
fi