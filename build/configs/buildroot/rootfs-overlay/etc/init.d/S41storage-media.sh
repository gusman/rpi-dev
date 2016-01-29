#! /bin/sh


echo "Mount all defined devices in fstab"

#$ctr=0
#while [ $ctr -lt 10 ] do
	#if [ -r /dev/sda1 ]; then 
		#break;
	#fi

#	sleep 10
	#ctr=$[$ctr + 1]
#done

sleep 2 
mount -av
chown -R transmission.transmission /Downloads
