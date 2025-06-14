to complie agi:
-------------- 
javac -cp "lib/*" -d out src/*.java

to run AGI:
-----------
java -cp "out:lib/*" IVRServer

move the sounds in folder asteriskNeed to --> /var/lib/asterisk/sounds/ivr 
for vxml files saves under --> /var/lib/asterisk/vxml

sudo mkdir -p /var/lib/asterisk/sounds/ivr 
sudo mkdir -p /var/lib/asterisk/vxml

---
change files permission to can write and read in this dir 
-------
sudo chmod -R 777 /var/lib/asterisk/sounds/ivr 
sudo chown -R user:user 	----> the user is linux user name like mibrahim 

Ex:
drwxrwsrwt 2 mibrahim mibrahim 153 Jun 14 21:11 vxml/

Astersik configrations:
-------------------------
put the configration for asterisk to could connect zpoiper with astersik 

in extention.conf will show this [ _X. ] 
[this _X. to can call asterisk with any number on zoiper]






