#!/bin/bash

if [ `id -u` -eq 0 ]
then
	echo "You are running this as root.  This may not work as you expect.  Are your sure?"
	exit 10
fi

mcd() {
	if [ ! -d $1 ]
	then
		mkdir -p $1
		cd $1
	fi
}

fonts() {
	sudo apt install fonts-droid-fallback
	sudo apt install fonts-inconsolata
}

check_installed() {
	#echo "Checking if $1 is installed"
	sudo apt-cache policy $1 | grep Installed 2>&1 > /dev/null
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
	APPNAME=i3
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	sudo echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
	sudo apt update
	sudo apt --allow-unauthenticated install sur5r-keyring
	sudo apt update
	sudo apt install i3
}

gnome-settings() {
	gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
	gsettings set org.gnome.desktop.wm.preferences focus-mode "mouse"
	gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 300

	gsettings set org.gnome.settings-daemon.plugins.media-keys terminal '<Super>Return'
	gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver '<Super>l'
	gsettings set org.gnome.settings-daemon.plugins.media-keys logout '<Shift><Super>q'
	gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>e'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'SSH Server'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/home/paul/bin/ssh-server.sh'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>backslash'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'RDP Server'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command '/home/paul/bin/rdp-session'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Shift><Super>bar'

	#gsettings set org.gnome.desktop.wm.preferences auto-raise true
	#gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
	#gsettings set org.gnome.settings-daemon.plugins.xrandr active false
	# dconf write /org/gnome/settings-daemon/plugins/xrandr/active false
}

gnome() {
	APPNAME=gnome
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	APPNAME=chrome-gnome-shell
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	gnome-settings
	##sudo apt install gnome devilspie
	#gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
	##gsettings set org.gnome.desktop.wm.preferences auto-raise true
	##gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 0
	##gsettings set org.gnome.desktop.wm.preferences focus-mode "mouse"
	##gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
	##gsettings set org.gnome.settings-daemon.plugins.xrandr active false
	## dconf write /org/gnome/settings-daemon/plugins/xrandr/active false
	sudo add-apt-repository ppa:ne0sight/chrome-gnome-shell
	sudo apt update
	sudo apt install chrome-gnome-shell
}

urxvt() {
	APPNAME=rxvt
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	APPNAME=rxvt-unicode
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	sudo apt install rxvt rxvt-unicode
	#update-alternatives --set x-terminal-emulator /usr/bin/urxvt
}

dropbox() {
	APPNAME=dropbox
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	# Install Dropbox
	if [ -d	 /etc/apt/sources.list.d ]
	then
		sudo echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main" >> /etc/apt/sources.list.d/dropbox.list
		#echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main"
	else
		sudo echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main" >> /etc/apt/sources.list
		#echo "deb http://linux.dropbox.com/ubuntu `lsb_release -cs` main"
	fi
	sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
	sudo apt update
	sudo apt install dropbox
}

chrome() {
	APPNAME=google-chrome-stable
	#[ $(check_installed ${APPNAME}) -eq 0 ] && return 10

	# Install Google Chrome
	mcd ~/Downloads
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	sudo apt -f install
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
	sudo apt-add-repository ppa:pmjdebruijn/darktable-release && \
	sudo apt update && \
	sudo apt install darktable
	ln -s ~/Dropbox/servers/config/darktable/ ~/.config/darktable
}

pidgin() {
	APPNAME=pidgin
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	sudo apt install pidgin pidgin-sipe
	sudo add-apt-repository ppa:pidgin-gnome-keyring/ppa
	sudo apt update
	sudo apt install pidgin-gnome-keyring
}

apps() {
	sudo apt install xdotool scrot cheese gimp youtube-dl handbrake handbrake-cli smbclient cifs-utils python-pip ec2-api-tools git icedtea-netx meld whois httpie weather-util traceroute evolution curl keepassx freerdp-x11 acpi openvpn default-jre libgnome-keyring-dev epiphany-browser awscli
	sudo pip install boto awscli awsclpy awscli-keyring awscli-cwlogs
	sudo -c "cd /usr/share/doc/git/contrib/credential/gnome-keyring/ && make"

	# Config user specific options
	git config --global user.email "pgmac@pgmac.net"
	git config --global user.name "Paul Macdonnell"
	git config --global push.default simple
	git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
}

aws() {
	echo "Installing AWS"
	echo "This has been deprecated and no longer does anything"
	#export EC2_KEYPAIR=<your keypair name> # name only, not the file name
	#export EC2_URL=https://ec2.ap-southeast-2.amazonaws.com
	#export EC2_PRIVATE_KEY=$HOME/<where your private key is>/pk-XXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
	#export EC2_CERT=$HOME/<where your certificate is>/cert-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem
	#export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/
}

oracle-java() {
	APPNAME=oracle-java8-installer
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	echo "Install Oracle Java"
	sudo apt-add-repository ppa:webupd8team/java && \
	sudo apt update && \
	sudo apt install oracle-java8-installer
}

restrictedaudio() {
	sudo apt install libdvdread4 && \
	sudo /usr/share/doc/libdvdread4/install-css.sh
	sudo addgroup paul audio
}

openshot() {
	APPNAME=openshot
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	sudo add-apt-repository ppa:openshot.developers/ppa && \
	sudo apt update && \
	sudo apt install openshot openshot-doc
}

nagstamon() {
	mcd ~/Downloads
	wget https://nagstamon.ifw-dresden.de/files-nagstamon/stable/nagstamon_1.0.1_all.deb
	sudo dpkg -i nagstamon_1.0.1_all.deb
	rm nagstamon_1.0.1_all.deb
}

fitbit() {
	sudo add-apt-repository ppa:cwayne18/fitbit && \
	sudo apt update && \
	sudo apt install galileo
	start galileo
}

calibre() {
	sudo wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
}

atom_packages() {
	apm install activate-power-mode
	apm disable activate-power-mode
	apm install atom-hg
	apm install git-time-machine
	apm install minimap
	apm install open-on-bitbucket
	apm install qolor
	apm install remote-edit
	apm install language-batchfile
	apm install language-powershell
	apm install linter-jsonlint
	apm install editorconfig
}

atom() {
	nodejs
	sudo apt-add-repository ppa:webupd8team/atom && \
	sudo apt update && \
	sudo apt install atom
	atom_packages
}

nodejs() {
	APPNAME=nodejs
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	#curl -sL https://deb.nodesource.com/setup_0.12 | bash -
	#apt install nodejs
	curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
	sudo apt-get install -y nodejs npm
}

ssh_config() {
	APPNAME=openssh-server
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	sudo apt install openssh-server

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
	APPNAME=hipchat4
	[ $(check_installed ${APPNAME}) -eq 0 ] && return 10
	# Previous hipchat version
	#echo "deb http://downloads.hipchat.com/linux/apt stable main" > /etc/apt/sources.list.d/atlassian-hipchat.list
	#wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
	#apt update
	#apt install hipchat
	# HipChat 4
	sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
	wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
	sudo apt update
	sudo apt install hipchat4
}

liquidprompt() {
	mcd ~/Development/
	git clone https://github.com/nojhan/liquidprompt.git
	echo "[[ $- = *i* ]] && source ~/Development/liquidprompt/liquidprompt" >> ~/.bashrc
	cp ~/Development/liquidprompt/liquidpromptrc-dist ~/.config/liquidpromptrc
}

alt_editor() {
	update-alternatives --set editor /usr/bin/vim.tiny
}

keybase() {
	mcd ~/Downloads/
	sudo curl -O https://prerelease.keybase.io/keybase_amd64.deb
	sudo dpkg -i keybase_amd64.deb
	sudo apt install -f
	run_keybase
}

if [ $# -eq 0 ]
then
	alt_editor
	gnome
	#i3
	urxvt
	dropbox
	apps
	oracle-java
	chrome
	darktable
	restrictedaudio
	openshot
	#pidgin
	nagstamon
	ssh_config
else
	while [ $# -gt 0 ]
	do
		$1
		shift
	done
fi
