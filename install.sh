#!/bin/bash
# Very simple, slightly stupid install script
echo "Making ~/.config/..."
mkdir --parents --verbose ~/.config
echo "Copying jekyll-upload.conf..."
cp --verbose --interactive jekyll-upload.conf ~/.config/
printf "%s\n" "jekyll-upload will be installed momentarily!" "I just need to ask you a few questions about the install."\
 "Would you like me to use a symlink? This means if you update the script here by using git pull, there will be no need to reinstall"
asking=true
while $asking; do
	read -p "Use symlink? [y/n] > " yn
	case $yn in
		y)
			symlink=true
			asking=false
			;;
		n)
			symlink=false
			asking=false
			;;
	esac
done
if $symlink; then echo "OK, using a symlink."; else echo "OK, hard copying."; fi
havebin=$(sed -ne'/~\/bin/p' -e"/\\/home\\/$(whoami)\\/bin/p" <<EOF
$PATH
EOF
)
if [ $havebin = "" ] 
then
	read -p "Install path? > " install
else
	echo "As far as I can tell you have ~/bin"
	install="~/bin/"
fi
comm=""
if $symlink; then
	comm="ln -s \"$(pwd)/jekyll-upload\" $install"
else
	comm="cp \"$(pwd)/jekyll-upload\" $install"
fi
printf "Here's the command to run:\n%s\n(You may need to use sudo, if you lack the permissions to make files in %s)\n" "$comm" "$install"
asking=true
while $asking; do
	read -p "Run the command now?? [y/n] > " yn
	case $yn in
		y)
			run=true
			asking=false
			;;
		n)
			run=false
			asking=false
			;;
	esac
done
