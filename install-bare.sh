#!/bin/bash
# Raspotify service installer

###
# Create raspotify user
###

userdel raspotify
useradd -Mr raspotify -G pulse-access -s /usr/sbin/nologin
echo "User raspotify created and added to the pulse-access group."

###
# Install configuration and service files
###

PWD="$PWD/$(dirname ${0})"

SRC=(
	"$PWD/raspotify/etc/default/raspotify"
	"$PWD/raspotify/lib/systemd/system/raspotify.service"
)

DST=(
	"/etc/default/raspotify"
	"/usr/lib/systemd/system/raspotify.service"
)

for (( i=0; i < ${#SRC[@]}; i++ )); do

	SRC_I=${SRC[$i]}
	DST_I=${DST[$i]}

	# Check whether source exists
	if [ ! -e $SRC_I ]; then
		continue;
	fi

	# Create destination base directory if non-existent
	mkdir -p $(dirname ${DST_I})
	
	# Remove destination path if it exists
	if [ -e $DST_I ]; then
		rm -r $DST_I;
	fi

	# Copy source to destination
	cp -r $SRC_I $DST_I;
	
	# Print success message
	echo "Installed '$DST_I'";

done

###
# Reload Systemd
###

systemctl daemon-reload
echo "Systemd daemon reloaded."
