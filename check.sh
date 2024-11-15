#!/bin/bash
# Disediakan oleh : Abdul Wahid bin Ani
# Skrip untuk memudahkan semakan info server

# dt_1. Contoh -> 20221116 12:53:55
dt_1=$(date "+%Y%m%d %H:%M:%S");
# dt_2. Contoh -> Rabu 16 Nov 2022 12:53:55 +08
dt_2=$(date -d "$dt_1");
# dt_3. Contoh -> 20221116-125355
dt_3=$(date -d "$dt_1" "+%Y%m%d-%H%M%S");

BASEDIR=$(dirname "$0");

f_hash () { echo "##############################################################################################"; }

f_section () {
	echo
	echo
	echo
	echo "### $1 ###";
	echo "............................................................................................";
	echo
}

f_main () {
	f_hash
	echo
	echo "CHECK SERVER";
	echo "Hostname          : $(hostname)";
	echo "Date              : $dt_2";
	echo "Log File          : $dt_3.log";
	echo
	f_hash

	cd /;

	f_section "Network Status";
	echo "### 1. Fail /ect/resolv.conf";
	tail -n 3 /etc/resolv.conf;
	echo
	echo "### 2. Network card & IP";
	ip a;

	f_section "Hard Disk Utilization";
	df -h;

	f_section "CPU Utilization";
	top -b -n 1|head -n 30;

	f_section "Memory Utilization";
	free -m;

	f_section "I/O Status";
	vmstat 5 15

	f_section "User Last login";
	last -n 100;

	f_section "OS & Kernel";
	lsb_release -a;
	cat /etc/redhat-release;
	uname -a;

        f_section "Apache version";
        apache2 -v
        httpd -v

        f_section "PHP version";
        for php in /usr/bin/php /usr/bin/php[0-9]*; do
          if [ -x "$php" ] && [[ "$php" =~ ^/usr/bin/php[0-9.]*$ ]]; then
            echo "$php version: $($php -v 2>/dev/null | head -n1)"
	  fi
        done

	f_section "MariaDB/MySQL";
	mysql --version;

	f_section "Maldet";
	maldet --report list;

	echo
	echo
	echo "###### END ######";
}

#Panggil fungsi utama
f_main > $BASEDIR/logs/$dt_3.log;
