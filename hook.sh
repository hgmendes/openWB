#!/bin/bash
hook(){

if (( hook1_aktiv == "1" )); then
	if (( hook1akt == 0 )); then
		hook1einschaltverzcounter=$(</var/www/html/openWB/ramdisk/hook1einschaltverzcounter)
		if (( uberschuss > hook1ein_watt )); then
			if (( hook1einschaltverzcounter > hook1einschaltverz)); then
				echo 0 > /var/www/html/openWB/ramdisk/hook1einschaltverzcounter
				echo 0 > /var/www/html/openWB/ramdisk/hook1counter
				if [ ! -e ramdisk/hook1aktiv ]; then
					touch ramdisk/hook1aktiv
					echo 1 > ramdisk/hook1akt
					curl -s --connect-timeout 5 $hook1ein_url > ramdisk/hookmsg
					echo "$date WebHook 1 aktiviert" >> ramdisk/ladestatus.log
					cat ramdisk/hookmsg >> ramdisk/ladestatus.log
					rm ramdisk/hookmsg
					if [[ $debug == "1" ]]; then
						echo "Gerät 1 aktiviert"
					fi
					if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
						./runs/pushover.sh "Gerät 1 eingeschaltet bei $uberschuss"
					fi
				fi
			else
				hook1einschaltverzcounter=$((hook1einschaltverzcounter +10))
				echo $hook1einschaltverzcounter > /var/www/html/openWB/ramdisk/hook1einschaltverzcounter
			fi
		else
			hook1einschaltverzcounter=0
		fi
	fi


	if [ -e ramdisk/hook1aktiv  ]; then
		if test $(find "ramdisk/hook1aktiv" -mmin +$hook1_dauer); then
			if (( uberschuss < hook1aus_watt )); then
				hook1counter=$(</var/www/html/openWB/ramdisk/hook1counter)
				if (( hook1counter < hook1_ausverz )); then
					hook1counter=$((hook1counter + 10))
					echo $hook1counter > /var/www/html/openWB/ramdisk/hook1counter
				else
					rm ramdisk/hook1aktiv
					echo 0 > ramdisk/hook1akt
					curl -s --connect-timeout 5 $hook1aus_url > ramdisk/hookmsg
					echo "$date WebHook 1 deaktiviert" >> ramdisk/ladestatus.log
					cat ramdisk/hookmsg >> ramdisk/ladestatus.log
					rm ramdisk/hookmsg
					if [[ $debug == "1" ]]; then
						echo "Gerät 1 deaktiviert"
					fi
					if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
						./runs/pushover.sh "Gerät 1 ausgeschaltet bei $uberschuss"
					fi
				fi
			fi
		fi
	fi
fi
if (( hook2_aktiv == "1" )); then
	if (( uberschuss > hook2ein_watt )); then
		echo 0 > /var/www/html/openWB/ramdisk/hook2counter
		if [ ! -e ramdisk/hook2aktiv ]; then
			touch ramdisk/hook2aktiv
			echo 1 > ramdisk/hook2akt
			curl -s --connect-timeout 5 $hook2ein_url > /dev/null
			echo "$date WebHook 2 aktiviert" >> ramdisk/ladestatus.log
			if [[ $debug == "1" ]]; then
				echo "Gerät 2 aktiviert"
			fi
			if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
				./runs/pushover.sh "Gerät 2 eingeschaltet bei $uberschuss"
			fi
		fi
	fi
	if [ -e ramdisk/hook2aktiv  ]; then
		if test $(find "ramdisk/hook2aktiv" -mmin +$hook2_dauer); then
			if (( uberschuss < hook2aus_watt )); then
				hook2counter=$(</var/www/html/openWB/ramdisk/hook2counter)
				if (( hook2counter < hook2_ausverz )); then
					hook2counter=$((hook2counter + 10))
					echo $hook2counter > /var/www/html/openWB/ramdisk/hook2counter
				else
					rm ramdisk/hook2aktiv
					echo 0 > ramdisk/hook2akt
					curl -s --connect-timeout 5 $hook2aus_url > /dev/null
					echo "$date WebHook 2 deaktiviert" >> ramdisk/ladestatus.log
					if [[ $debug == "1" ]]; then
						echo "Gerät 2 deaktiviert"
					fi
					if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
						./runs/pushover.sh "Gerät 2 ausgeschaltet bei $uberschuss"
					fi
				fi
			fi
		fi
	fi
fi
if (( hook3_aktiv == "1" )); then
	if (( uberschuss > hook3ein_watt )); then
		echo 0 > /var/www/html/openWB/ramdisk/hook3counter
		if [ ! -e ramdisk/hook3aktiv ]; then
			touch ramdisk/hook3aktiv
			echo 1 > ramdisk/hook3akt
			curl -s --connect-timeout 5 $hook3ein_url > /dev/null
			echo "$date WebHook 3 aktiviert" >> ramdisk/ladestatus.log
			if [[ $debug == "1" ]]; then
				echo "Gerät 3 aktiviert"
			fi
			if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
				./runs/pushover.sh "Gerät 3 eingeschaltet bei $uberschuss"
			fi
		fi
	fi
	if [ -e ramdisk/hook3aktiv  ]; then
		if test $(find "ramdisk/hook3aktiv" -mmin +$hook3_dauer); then
			if (( uberschuss < hook3aus_watt )); then
				hook3counter=$(</var/www/html/openWB/ramdisk/hook3counter)
				if (( hook3counter < hook3_ausverz )); then
					hook3counter=$((hook3counter + 10))
					echo $hook3counter > /var/www/html/openWB/ramdisk/hook3counter
				else
					rm ramdisk/hook3aktiv
					echo 0 > ramdisk/hook3akt
					curl -s --connect-timeout 5 $hook3aus_url > /dev/null
					echo "$date WebHook 3 deaktiviert" >> ramdisk/ladestatus.log
					if [[ $debug == "1" ]]; then
						echo "Gerät 3 deaktiviert"
					fi
					if ((pushbsmarthome == "1")) && ((pushbenachrichtigung == "1")); then
						./runs/pushover.sh "Gerät 3 ausgeschaltet bei $uberschuss"
					fi
				fi
			fi
		fi
	fi
fi
if (( verbraucher1_aktiv == "1")); then
	echo "1" > /var/www/html/openWB/ramdisk/verbraucher1vorhanden
	if [[ $verbraucher1_typ == "http" ]]; then
		verbraucher1_watt=$(curl --connect-timeout 3 -s $verbraucher1_urlw )
		if ! [[ "$verbraucher1_watt" =~ '^[+-]?[0-9]+([.][0-9]+)?$' ]]; then
	   		echo $verbraucher1_watt > /var/www/html/openWB/ramdisk/verbraucher1_watt
		fi
		verbraucher1_wh=$(curl --connect-timeout 3 -s $verbraucher1_urlh &)
		if ! [[ "$verbraucher1_wh" =~ '^[+-]?[0-9]+([.][0-9]+)?$' ]]; then
			echo $verbraucher1_wh > /var/www/html/openWB/ramdisk/verbraucher1_wh
		fi

	fi
	if [[ $verbraucher1_typ == "mpm3pm" ]]; then
		if [[ $verbraucher1_source == *"dev"* ]]; then
			sudo python modules/verbraucher/mpm3pmlocal.py 1 $verbraucher1_source $verbraucher1_id &
		else
			sudo python modules/verbraucher/mpm3pmremote.py 1 $verbraucher1_source $verbraucher1_id &
		fi
	fi
	if [[ $verbraucher1_typ == "sdm630" ]]; then
		if [[ $verbraucher1_source == *"dev"* ]]; then
			sudo python modules/verbraucher/mpm3pmlocal.py 1 $verbraucher1_source $verbraucher1_id &
		else
			sudo python modules/verbraucher/mpm3pmremote.py 1 $verbraucher1_source $verbraucher1_id &
		fi
	fi

	if [[ $verbraucher1_typ == "sdm120" ]]; then
		if [[ $verbraucher1_source == *"dev"* ]]; then
			sudo python modules/verbraucher/sdm120local.py 1 $verbraucher1_source $verbraucher1_id &
		else
			sudo python modules/verbraucher/sdm120remote.py 1 $verbraucher1_source $verbraucher1_id &
		fi
	fi
	if [[ $verbraucher1_typ == "tasmota" ]]; then
		verbraucher1_out=$(curl --connect-timeout 3 -s $verbraucher1_ip/cm?cmnd=Status%208 )
		verbraucher1_watt=$(echo $verbraucher1_out | jq '.StatusSNS.ENERGY.Power')
			echo $verbraucher1_watt > /var/www/html/openWB/ramdisk/verbraucher1_watt
		verbraucher1_wh=$(echo $verbraucher1_out | jq '.StatusSNS.ENERGY.Total')
		verbraucher1_totalwh=$(echo "scale=0;(($verbraucher1_wh * 1000) + $verbraucher1_tempwh)  / 1" | bc)
		echo $verbraucher1_totalwh > /var/www/html/openWB/ramdisk/verbraucher1_wh
	fi
else
	verbraucher1_watt=0
fi
if (( verbraucher2_aktiv == "1")); then
	echo "1" > /var/www/html/openWB/ramdisk/verbraucher2vorhanden
	if [[ $verbraucher2_typ == "http" ]]; then
		verbraucher2_watt=$(curl --connect-timeout 3 -s $verbraucher2_urlw )
		if [[ "$verbraucher2_watt" =~ "^[-+]?[0-9]+\.?[0-9]*$" ]]; then
			echo $verbraucher2_watt > /var/www/html/openWB/ramdisk/verbraucher2_watt
		fi
		verbraucher2_wh=$(curl --connect-timeout 3 -s $verbraucher2_urlh &)
		if [[ "$verbraucher2_wh" =~ "^[-+]?[0-9]+\.?[0-9]*$" ]]; then
			echo $verbraucher2_wh > /var/www/html/openWB/ramdisk/verbraucher2_wh
		fi
	fi
	if [[ $verbraucher2_typ == "mpm3pm" ]]; then
		if [[ $verbraucher2_source == *"dev"* ]]; then
			sudo python modules/verbraucher/mpm3pmlocal.py 2 $verbraucher2_source $verbraucher2_id &
		else
			sudo python modules/verbraucher/mpm3pmremote.py 2 $verbraucher2_source $verbraucher2_id &
		fi
	fi
	if [[ $verbraucher2_typ == "sdm630" ]]; then
		if [[ $verbraucher2_source == *"dev"* ]]; then
			sudo python modules/verbraucher/mpm3pmlocal.py 2 $verbraucher2_source $verbraucher2_id &
		else
			sudo python modules/verbraucher/mpm3pmremote.py 2 $verbraucher2_source $verbraucher2_id &
		fi
	fi

	if [[ $verbraucher2_typ == "sdm120" ]]; then
		if [[ $verbraucher2_source == *"dev"* ]]; then
			sudo python modules/verbraucher/sdm120local.py 2 $verbraucher2_source $verbraucher2_id &
		else
			sudo python modules/verbraucher/sdm120remote.py 2 $verbraucher2_source $verbraucher2_id &
		fi
	fi
	if [[ $verbraucher2_typ == "tasmota" ]]; then
		verbraucher2_out=$(curl --connect-timeout 3 -s $verbraucher2_ip/cm?cmnd=Status%208 )
		verbraucher2_watt=$(echo $verbraucher2_out | jq '.StatusSNS.ENERGY.Power')
			echo $verbraucher2_watt > /var/www/html/openWB/ramdisk/verbraucher2_watt
		verbraucher2_wh=$(echo $verbraucher2_out | jq '.StatusSNS.ENERGY.Total')
		verbraucher2_totalwh=$(echo "scale=0;(($verbraucher2_wh * 1000) + $verbraucher2_tempwh)  / 1" | bc)
		echo $verbraucher2_totalwh > /var/www/html/openWB/ramdisk/verbraucher2_wh
	fi
else
	verbraucher2_watt=0
fi

if (( angesteckthooklp1 == 1 )); then
	plugstat=$(<ramdisk/plugstat)
	if (( plugstat == 1 )); then
		if [ ! -e ramdisk/angesteckthooklp1aktiv ]; then
			touch ramdisk/angesteckthooklp1aktiv
			curl -s --connect-timeout 5 $angesteckthooklp1_url > /dev/null
			echo "$date angesteckt Hook LP1 ausgeführt" >> ramdisk/ladestatus.log
			if [[ $debug == "1" ]]; then
				echo "$date angesteckt Hook LP1 ausgeführt"
			fi
		fi
	else
		if [  -e ramdisk/angesteckthooklp1aktiv ]; then
			rm ramdisk/angesteckthooklp1aktiv
		fi
	fi
fi











}
