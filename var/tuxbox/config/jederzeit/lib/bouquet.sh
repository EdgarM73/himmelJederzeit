#!/bin/sh

createBouquet() {
	if  [ -d ${wgetDirectory} ];
	then
		rm -rf ${wgetDirectory}
	fi
	mkdir ${wgetDirectory}
	log "startin function: createBouquet" 
	wget -O ${wgetDirectory}eins "http://127.0.0.1/control/addbouquet?name=SkyAnytime"
	getHimmelJederzeitBouquet
	#wget -O ${wgetDirectory}eins.2 "http://127.0.0.1/control/setbouquet?selected=${bouquetId}&action=show"
	wget -O ${wgetDirectory}eins.2.1 "http://127.0.0.1/control/setbouquet?selected=${bouquetId}&action=unlock"

}
identifyAndAddChannels() {
	
	    log "startin function: identifyAndAddChannels" 
        wget -O ${wgetDirectory}channellist "http://127.0.0.1/control/channellist"
        sort -u ${wgetDirectory}channellist > ${wgetDirectory}channellist.sorted

        ids=`grep "Sky Cinema HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Action HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Hits HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Disney Channel HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Disney Cinemagic HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
                
        wget -O ${wgetDirectory}zwo  "http://127.0.0.1/control/changebouquet?selected=${bouquetId}&bchannels=${ids}"
        wget -O $${wgetDirectory}vier "http://127.0.0.1/control/savebouquet"
}

getHimmelJederzeitBouquet() {
	bouquetId=`pzapit | grep himmelJederzeit | cut -d":" -f1`
}