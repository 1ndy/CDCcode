#!/bin/bash


#initiaize out IP range
hosts=$(echo 0.0.0.0);
admin_passwd=""
server_ip=""
filename=""

#functions

#reboot
reboot () {
	exp_reboot admin@$1 "admin" $admin_passwd
}
change_admin_passwd () {
	exp_change_admin_passwd admin@$1 "admin" $admin_passwd $2
}

set_flag () {
	exp_set_flag admin@$1 "admin" $flag
}

get_flag () {
	exp_get_flag admin@$1 "admin"

}

program () {
	exp_program admin@$1 "admin" $admin_passwd $server_ip $filename
}
echo "What woud you ike to do:"
echo "	1. Reboot"
echo "	2. View programming"
echo "	3. Set programming"
echo "	4. Change Admin Password"
echo "	5. Update Firmware"
echo "	6. Get Flag"
echo "	7. Set Flag"
echo "	8. View Device info"
echo "	9. exit"

read -p "Choice: " choice

for i in ${hosts[@]}; do
	
	if [ $choice -eq 1 ]; then
		reboot $i
	elif [ $choice -eq 2 ]; then
		printf $i
		curl $i
	elif [ $choice -eq 3 ]; then
		atftpd --daemon /srv/tftp/
		program $i
	elif [ $choice -eq 4 ]; then
		if [ -z $new_admin_passwd ]; then
			read -p "New admin Password: " new_admin_passwd;
		fi
		change_admin_passwd $i $new_admin_passwd
		printf "\n"
	elif [ $choice -eq 5 ]; then
		update $i
	elif [ $choice -eq 6 ]; then
		get_flag $i 
	elif [ $choice -eq 7 ]; then
		flag=$(cat flag)
		echo $flag
		set_flag $i $flag
	elif [ $choice -eq 8 ]; then
		info $i
	else
		exit;
	fi
done


