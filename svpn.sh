#!/bin/bash

#####################################################
### Script author: https://github.com/ToyoDAdoubi ###
### Modified by: https://github.com/Lunatik-cyber ###
#####################################################

filepath=$(cd "$(dirname "$0")"; pwd)
file=$(echo -e "${filepath}"|awk -F "$0" '{print $1}')
ssr_folder="/usr/local/shadowsocksr"
config_file="${ssr_folder}/config.json"
language_file="/var/log/language.txt"
config_user_file="${ssr_folder}/user-config.json"
config_user_api_file="${ssr_folder}/userapiconfig.py"
config_user_mudb_file="${ssr_folder}/mudb.json"
ssr_log_file="${ssr_folder}/ssserver.log"
Libsodiumr_file="/usr/local/lib/libsodium.so"
Libsodiumr_ver_backup="1.0.15"
jq_file="${ssr_folder}/jq"

Font_end="\033[0m"
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue='\033[34m'
Purple='\033[35m'
Ocean='\033[36m'
Black='\033[37m'
Morg="\033[5m"
Reverse="\033[7m"
Font="\033[1m"
Separator_1="——————————————————————————————"

###################################

language_en=( "English" # 0
			  "Current status: ${Green}Running${Font_end}" # 1
			  "Current status: ${Red}Not running${Font_end}" # 2
			  "Current status: ${Red}Not installed${Font_end}" # 3
			  "
Modified by: ${Green}https://github.com/Lunatik-cyber${Font_end}

Server IP: ${Ocean}$(curl -s https://2ip.ru)${Font_end} | ${Ocean}$(cat ${config_user_api_file} | grep "SERVER_PUB_ADDR = " | awk -F "[']" '{print $2}')${Font_end}

————————————————————————————————————
${Purple}[0]${Font_end} Exit
—————————— ${Purple}Key management${Font_end} ——————————  
${Purple}[1]${Font_end} Change port password 
${Purple}[2]${Font_end} Port info 
${Purple}[3]${Font_end} Connections
${Purple}[4]${Font_end} Change the server address
————————— ${Purple}Status management${Font_end} ————————
${Purple}[5]${Font_end} Enable ShadowSocks 
${Purple}[6]${Font_end} Disable ShadowSocks
${Purple}[7]${Font_end} Restart ShadowSocks
———————— ${Purple}Shadowsocks control${Font_end} ———————
${Purple}[8]${Font_end} Install ShadowSocks 
${Purple}[9]${Font_end} Remove ShadowSocks 
————————————————————————————————————
${Purple}[10]${Font_end} Change language
————————————————————————————————————" # 5
			  "Option: " #6 
)

message_en=( "English" # 0
			 "Press [Enter] to return to the menu..." # 1
			 "Port:" # 2
			 "${Red}Failed to get user information ${Font_end}" # 3
			 "Unlimited" # 4
			 "SS Key" # 5
			 "SS QR code" # 6
			 "SSR Key" # 7
			 "SSR QR code" # 8
			 "${Red}The user with this port was not found${Font_end}" # 9
			 "Cancelled..." # 10
			 "${Red}Enter the correct port!${Font_end}" # 11
			 "User Information" # 12
			 "IP" # 13
			 "Port" # 14
			 "Password:" # 15
			 "Used Traffic: Upload:" # 16
			 "Download:" # 17
			 "User name" # 18
			 "[Default: AstroFic]: " # 19
			 "
  ${Green}[1]${Font_end} Auto [By default]
  ${Purple}[2]${Font_end} Manually" # 20
    		 "Input type: " # 21
   			 "
  ${Green}[1]${Font_end} Random password [By default]
  ${Purple}[2]${Font_end} Password = port
  ${Purple}[3]${Font_end} Enter manually
" # 22
    		 "The port is automatically generated" # 23
    		 "${Red}Enter the correct port [1-65535] !${Font_end}" # 24
    		 "Enter the password: " # 25
    		 "${Red}Failed to get the server IP!${Font_end}" # 26
    		 "Current IP:" # 27
    		 "Enter the domain or IP address of the server: " # 28
    		 "[Automatic IP detection when pressing Enter]: " # 29
    		 "${Red}Enter the server IP manually!${Font_end}" # 30
    		 "${Red}The field cannot be empty!${Font_end}" # 31
    		 "Server IP:" # 32
    		 "Failed to change user password" # 33
    		 "The user's password has been successfully changed" # 34
    		 "User:" # 35
    		 "${Red}User not found!${Font_end}" # 36
    		 "Total IP addresses:" # 37
    		 "Number of IP addresses:" # 38
    		 "Connected:" # 39
    		 "Traffic:" # 40
)

setup_en=( "English" # 0
		   "${Red}Not enough rights. Run the script with${Font_end}: sudo bash $0" # 1
		   "${Red}ShadowSocks not found!${Font_end}" # 2
		   "Python is not installed, start of installation..." # 3
		   "${Red}Shadowsocks unpacking error!${Font_end}" # 4
		   "${Red}Failed to rename ShadowSocks folder!${Font_end}" # 5
		   "${Red}Failed to copy apiconfig.py for Shadowsocks!${Font_end}" # 6
		   "${Green}Shadowsocks has been successfully installed!${Font_end}" # 7
		   "${Red}Failed to download the ShadowSocks archive!${Font_end}" # 8
		   "${Red}Failed to load Shadowsocks script!${Font_end}" # 9
		   "${Red}Failed to install unzip!${Font_end}" # 10
		   "${Green}ShadowSocks is already installed!${Font_end}" # 11
		   "Loading..." # 12
		   "Downloading..." # 13
		   "Unpacking..." # 14
		   "Installation..." # 15
		   "${Red}Libsodium installation error!${Font_end}" # 16
		   "${Green}Libsodium has been successfully installed!${Font_end}" # 17
		   "Remove ShadowSocks？[${Green}Y${Font_end}|${Red}N${Font_end}]" # 18
		   "[Default: N]: " # 19
		   "${Green}ShadowSocks has been successfully removed!${Font_end}" # 20
		   "Installing the latest version of Libsodium..." # 21
		   "The latest version of Libsodium: " # 22
		   "${Red}ShadowSocks is already running!${Font_end}" # 23
		   "${Red}ShadowSocks is not running!${Font_end}" # 24
		   "This system is not supported: " # 25
)

language_ru=( "Русский" # 0
			  "Текущий статус: ${Green}Запущен${Font_end}" # 1
			  "Текущий статус: ${Red}Не запущен${Font_end}" # 2
			  "Текущий статус: ${Red}Не установлен${Font_end}" # 3
			  "
Скрипт модифицировал: ${Green}https://github.com/Lunatik-cyber${Font_end}

IP сервера: ${Ocean}$(curl -s https://2ip.ru)${Font_end} | ${Ocean}$(cat ${config_user_api_file} | grep "SERVER_PUB_ADDR = " | awk -F "[']" '{print $2}')${Font_end}

————————————————————————————————————
${Purple}[0]${Font_end} Выход
———————— ${Purple}Управление ключами${Font_end} ———————— 
${Purple}[1]${Font_end} Изменить пароль            
${Purple}[2]${Font_end} Данные ключа          
${Purple}[3]${Font_end} Подключенные                      
${Purple}[4]${Font_end} Изменить адрес сервера
———————— ${Purple}Управление статусом${Font_end} ———————
${Purple}[5]${Font_end} Включить ShadowSocks            
${Purple}[6]${Font_end} Выключить ShadowSocks           
${Purple}[7]${Font_end} Перезапустить ShadowSocks 
—————— ${Purple}Контроль ShadowSocks'a${Font_end} ——————
${Purple}[8]${Font_end} Установить ShadowSocks          
${Purple}[9]${Font_end} Удалить ShadowSocks       
————————————————————————————————————
${Purple}[10]${Font_end} Изменить язык
————————————————————————————————————" #4
			  "Опция: " #5
)

message_ru=( "Русский" # 0
			 "Нажмите [Enter] для возврата в меню..."  # 1
			 "Порт:" #  2
			 "${Red}Не удалось получить информацию о пользователе${Font_end} " # 3
			 "Неограниченно" # 4
			 "SS Ключ" # 5
			 "SS QR код" # 6
			 "SSR Ключ" # 7
			 "SSR QR код" # 8
			 "${Red}Пользователь с данным портом не найден${Font_end}" # 9
			 "Отменено..." # 10
			 "${Red}Введите правильный порт!${Font_end}" # 11
			 "Информация о пользователе" # 12
			 "IP" # 13
			 "Порт" # 14
			 "Пароль  :" # 15
			 "Использованный трафик: Отдано:" # 16
			 "Скачано:" # 17
			 "Имя пользователя" # 18
			 "[По умолчанию: AstroFic]: " # 19
			 "
  ${Green}[1]${Font_end} Авто [По умолчанию]
  ${Purple}[2]${Font_end} Вручную
" # 20
			 "Тип ввода: " # 21
			 "
  ${Green}[1]${Font_end} Рандомный пароль [По умолчанию]
  ${Purple}[2]${Font_end} Пароль = порт
  ${Purple}[3]${Font_end} Ввести вручную
" #  22
			 "Порт автоматически сгенерирован" # 23
			 "${Red}Введите правильный порт [1-65535] !${Font_end}" # 24
			 "Введите пароль: " # 25
			 "${Red}Не удалось получить IP сервера!${Font_end}" # 26
			 "Текущий IP:" # 27
			 "Введите домен или IP-адрес сервера: " # 28
			 "[Автоматическое определение IP при нажатии Enter]: " # 29
			 "${Red}Введите IP сервера вручную!${Font_end}" # 30
			 "${Red}Поле не может быть пустым!${Font_end}" # 31
			 "IP сервера:" # 32
			 "${Red}Не удалось изменить пароль пользователя${Font_end}" # 33
			 "Пароль пользователя успешно изменен" # 34
			 "Пользователь:" # 35
			 "${Red}Пользователь не найден!${Font_end}" # 36
			 "Всего IP адресов:" # 37
			 "Кол-во IP:" # 38
			 "Подключенные:" # 39
			 "Трафик:" # 40
 )

setup_ru=( "Русский" # 0
		   "${Red}Недостаточно прав. Запустите скрипт командой:${Font_end} sudo bash $0"  # 1
		   "${Red}ShadowSocks не найден!${Font_end}" # 2
		   "Python не установлен, начало установки..." # 3
		   "${Red}Shadowsocks unpacking error!${Font_end}" # 4
		   "${Red}Не удалось переименовать папку ShadowSocks!${Font_end}" # 5
		   "${Red}Не удалось скопировать apiconfig.py для Shadowsocks!${Font_end}" # 6
		   "${Green}Shadowsocks успешно установлен!${Font_end}"  # 7
		   "${Red}Не удалось скачать архив ShadowSocks!${Font_end}"  # 8
		   "${Red}Не удалось загрузить скрипт Shadowsocks!${Font_end}" # 9
		   "${Red}Не удалось установить unzip!${Font_end}"  # 10
		   "${Green}ShadowSocks уже установлен!${Font_end}"  # 11
		   "Загрузка..."  # 12
		   "Скачивание..." # 13
		   "Распаковка..." # 14
		   "Установка..." # 15
		   "${Red}Ошибка установки Libsodium!${Font_end}"  # 16
		   "${Green}Libsodium успешно установлен!${Font_end}" # 17
		   "Удалить ShadowSocks？[${Green}Y${Font_end}|${Red}N${Font_end}]"  # 18
		   "[По умолчанию: N]: " # 19
		   "${Green}ShadowSocks успешно удален!${Font_end}" # 20
		   "Установка последней версии Libsodium..." # 21
		   "Последняя версия libsodium: " # 22
		   "${Red}ShadowSocks уже запущен!${Font_end}" # 23
		   "${Red}ShadowSocks не запущен!${Font_end}" # 24
		   "Данная система не поддерживается: " # 25
)

###################################

languages() {
    lng="language_$langset[@]"; lng=("${!lng}")
    msg="message_$langset[@]"; msg=("${!msg}")
    set="setup_$langset[@]"; set=("${!set}")
    for b in ${!language_en[@]} ${!message_en[@]} ${!setup_en[@]}; do
        if [[ ! ${lng[$b]} ]] ; then
            lng[$b]=${language_en[$b]}
        fi
        if [[ ! ${msg[$b]} ]] ; then
            msg[$b]=${message_en[$b]}
        fi
        if [[ ! ${set[$b]} ]] ; then
            set[$b]=${setup_en[$b]}
        fi
    done
}

check_language(){
	if [[ ! -e ${language_file} ]]; then
		echo -e "
${Green}[1]${Font_end} English [Default]
${Purple}[2]${Font_end} Русский
"
		read -p "> " language
		[[ -z "$language" ]] && language="1"
		if [[ ${language} == "1" ]]; then
			echo "en" > ${language_file}
			langset=en
		elif [[ ${language} == "2" ]]; then
			echo "ru" > ${language_file}
			langset=ru
		fi
	else
		langset=$(cat ${language_file})
	fi
}

check_root() {
	[[ $EUID != 0 ]] && echo -e "${set[1]}" && exit 1
}

check_sys() {
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	fi
	bit=$(uname -m)
}

check_pid() {
	PID=$(ps -ef | grep -v grep | grep server.py | awk '{print $2}')
}

SSR_installation_status() {
	[[ ! -e ${ssr_folder} ]] && echo -e "${set[2]}" && exit 1
}

Check_Libsodium_ver() {
	echo -e "${set[21]}"
	Libsodiumr_ver=$(wget -qO- "https://github.com/jedisct1/libsodium/tags" | grep "/jedisct1/libsodium/releases/tag/" | head -1 | sed -r 's/.*tag\/(.+)\">.*/\1/')
	[[ -z ${Libsodiumr_ver} ]] && Libsodiumr_ver=${Libsodiumr_ver_backup}
	echo -e "${set[22]}${Libsodiumr_ver}!"
}

menu_status() {
	if [[ -e ${ssr_folder} ]]; then
		check_pid
		if [[ ! -z "${PID}" ]]; then
			echo -e "${lng[1]}"
		else
			echo -e "${lng[2]}"
		fi
		cd "${ssr_folder}"
	else
		echo -e "${lng[3]}"
	fi
}

###################################

Start_SSR() {
	SSR_installation_status
	check_pid
	[[ ! -z ${PID} ]] && echo -e "${set[23]}"
	/etc/init.d/ssrmu start
}

Stop_SSR() {
	SSR_installation_status
	check_pid
	[[ -z ${PID} ]] && echo -e "${set[24]}"
	/etc/init.d/ssrmu stop
}

Restart_SSR() {
	SSR_installation_status
	check_pid
	[[ ! -z ${PID} ]] && /etc/init.d/ssrmu stop
	/etc/init.d/ssrmu start
}

###################################

Check_python() {
	python_ver=$(python -h)
	if [[ -z ${python_ver} ]]; then
		echo -e "${set[3]}"
		apt-get install -y python
	fi
}

Debian_apt() {
	apt-get update
	cat /etc/issue | grep 9\..* >/dev/null
	apt-get install -y vim unzip net-tools

}

Download_SSR() {
	cd "/usr/local"
	wget -N --no-check-certificate "https://github.com/ToyoDAdoubiBackup/shadowsocksr/archive/manyuser.zip"
	[[ ! -e "manyuser.zip" ]] && echo -e "${set[4]}" && rm -rf manyuser.zip && exit 1
	unzip "manyuser.zip"
	[[ ! -e "/usr/local/shadowsocksr-manyuser/" ]] && echo -e "${set[4]}" && rm -rf manyuser.zip && exit 1
	mv "/usr/local/shadowsocksr-manyuser/" "/usr/local/shadowsocksr/"
	[[ ! -e "/usr/local/shadowsocksr/" ]] && echo -e "${set[5]}" && rm -rf manyuser.zip && rm -rf "/usr/local/shadowsocksr-manyuser/" && exit 1
	rm -rf manyuser.zip
	cd "shadowsocksr"
	cp "${ssr_folder}/config.json" "${config_user_file}"
	cp "${ssr_folder}/mysql.json" "${ssr_folder}/usermysql.json"
	cp "${ssr_folder}/apiconfig.py" "${config_user_api_file}"
	[[ ! -e ${config_user_api_file} ]] && echo -e "${set[6]}" && exit 1
	sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" ${config_user_api_file}
	server_pub_addr="127.0.0.1"
	Modify_user_api_server_pub_addr
	sed -i 's/ \/\/ only works under multi-user mode//g' "${config_user_file}"
	echo -e "${set[7]}"
}

Service_SSR() {
	if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubiBackup/doubi/master/service/ssrmu_debian -O /etc/init.d/ssrmu; then
		echo -e "${set[8]}" && exit 1
	fi
	chmod +x /etc/init.d/ssrmu
	update-rc.d -f ssrmu defaults
}

Installation_dependency() {
	Debian_apt
	[[ ! -e "/usr/bin/unzip" ]] && echo -e "${set[9]}" && exit 1
	Check_python
}

JQ_install(){
    if [[ ! -e ${jq_file} ]]; then
        cd "${ssr_folder}"
        if [[ ${bit} = "x86_64" ]]; then
            mv "jq-linux64" "jq"
        else
            mv "jq-linux32" "jq"
        fi
        chmod +x ${jq_file}
        echo
    else
        echo
    fi
}

Install_SSR() {
	check_root
	[[ -e ${ssr_folder} ]] && echo -e "${set[11]}" && exit 1
	echo -e "${set[12]}"
	clear
	Set_user_api_server_pub_addr
	Set_config_all
	echo -e "${set[12]}"
	Installation_dependency
	echo -e "${set[12]}"
	Download_SSR
	echo -e "${set[12]}"
	Service_SSR
	echo -e "${set[12]}"
	JQ_install
	Add_port_user "install"
	echo -e "${set[12]}"
	Set_iptables
	echo -e "${set[12]}"
	Add_iptables
	echo -e "${set[12]}"
	Save_iptables
	echo -e "${set[12]}"
	Start_SSR
	Check_Libsodium_ver
	apt-get update -y
	echo -e "${set[12]}"
	apt-get install -y build-essential
	echo -e "${set[13]}"
	wget --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}-RELEASE/libsodium-${Libsodiumr_ver}.tar.gz"
	echo -e "${set[14]}"
	tar -xzf libsodium-${Libsodiumr_ver}.tar.gz && cd libsodium-${Libsodiumr_ver}
	echo -e "${set[15]}"
	./configure --disable-maintainer-mode && make -j2 && make install
	ldconfig
	cd .. && rm -rf libsodium-${Libsodiumr_ver}.tar.gz && rm -rf libsodium-${Libsodiumr_ver}
	[[ ! -e ${Libsodiumr_file} ]] && echo -e "${set[16]}" && exit 1
	echo && echo -e "${set[17]}" && echo
}

Uninstall_SSR() {
	[[ ! -e ${ssr_folder} ]] && echo -e "${set[2]}" && exit 1
	echo -e "${set[18]}" && echo
	read -e -p "${set[19]}" answer
	[[ -z ${answer} ]] && answer="n"
	if [[ ${answer} == [Yy] ]]; then
		check_pid
		[[ ! -z "${PID}" ]] && kill -9 ${PID}
		if [[ ! -z ${user_info} ]]; then
               rm ${ssr_folder}/mudb.json
		fi
		update-rc.d -f ssrmu remove
		rm -rf ${ssr_folder} && rm -rf /etc/init.d/ssrmu
		echo && echo -e "${set[20]}" && echo
	else
		echo -e "${msg[10]}" && echo
		read -n1 -r -p "${msg[1]}"	
		menu
	fi
}

###################################

Add_iptables(){
    if [[ ! -z "${ssr_port}" ]]; then
        iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${ssr_port} -j ACCEPT
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${ssr_port} -j ACCEPT
        ip6tables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${ssr_port} -j ACCEPT
        ip6tables -I INPUT -m state --state NEW -m udp -p udp --dport ${ssr_port} -j ACCEPT
    fi
}

Del_iptables(){
    if [[ ! -z "${port}" ]]; then
        iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
        iptables -D INPUT -m state --state NEW -m udp -p udp --dport ${port} -j ACCEPT
        ip6tables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
        ip6tables -D INPUT -m state --state NEW -m udp -p udp --dport ${port} -j ACCEPT
    fi
}

Save_iptables(){
    iptables-save > /etc/iptables.up.rules
    ip6tables-save > /etc/ip6tables.up.rules
}

Set_iptables(){
    iptables-save > /etc/iptables.up.rules
    ip6tables-save > /etc/ip6tables.up.rules
    echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules' > /etc/network/if-pre-up.d/iptables
    chmod +x /etc/network/if-pre-up.d/iptables
}

Set_config_user() {
	clear
	echo -e "${msg[18]}"
	read -e -p "${msg[19]}" ssr_user
	[[ -z "${ssr_user}" ]] && ssr_user="AstroFic"
	ssr_user=$(echo "${ssr_user}" | sed 's/ //g')
	echo && echo ${Separator_1} && echo -e "	${msg[18]}: ${Green}${ssr_user}${Font_end}" && echo ${Separator_1} && echo
}

Set_config_port() {
	echo -e "${msg[14]}
${msg[20]}"
	read -e -p "${msg[21]}" port
	[[ -z "${port}" ]] && port="1"
	if [[ ${port} == "1" ]]; then
		echo -e "${msg[22]}"
		ssr_port=$(shuf -i 100-999 -n 1)
		echo && echo ${Separator_1} && echo -e "	${msg[2]} ${Green}${ssr_port}${Font_end}" && echo ${Separator_1} && echo
	elif [[ ${how_to_port} == "2" ]]; then
		while true; do
			read -e -p "${msg[2]}" ssr_port
			[[ -z "$ssr_port" ]] && break
			echo $((${ssr_port} + 0)) &>/dev/null
			if [[ $? == 0 ]]; then
				if [[ ${ssr_port} -ge 1 ]] && [[ ${ssr_port} -le 65535 ]]; then
					echo && echo ${Separator_1} && echo -e "	${msg[2]} ${Green}${ssr_port}${Font_end}" && echo ${Separator_1} && echo
					break
				else
					echo -e "${msg[23]}"
				fi
			else
				echo -e "${msg[23]}"
			fi
		done
	fi
}

Set_config_password() {
	echo -e " ${msg[15]}
${msg[22]}"
	read -e -p "${msg[21]}" how_to_pass
	[[ -z "${how_to_pass}" ]] && how_to_pass="1"
	if [[ ${how_to_pass} == "1" ]]; then
		ssr_password=$(date +%s%N | md5sum | head -c 16)
	elif [[ ${how_to_pass} == "2" ]]; then
		ssr_password=${ssr_port}
	elif [[ ${how_to_pass} == "3" ]]; then
	  	read -e -p "${msg[24]}" pass
	  	ssr_password=$pass
	else
	  	ssr_password=$(date +%s%N | md5sum | head -c 16)
	fi
	echo && echo ${Separator_1} && echo -e "	${msg[15]} ${Green}${ssr_password}${Font_end}" && echo ${Separator_1} && echo
}

Set_config_method() {
	ssr_method="chacha20-ietf"
}

Set_config_protocol() {
	ssr_protocol="origin"
}

Set_config_obfs() {
	ssr_obfs="plain"
}

Set_config_protocol_param() {
	ssr_protocol_param=""
}
Set_config_speed_limit_per_con() {
	ssr_speed_limit_per_con=0
}
Set_config_speed_limit_per_user() {
	ssr_speed_limit_per_user=0
}
Set_config_transfer() {
	ssr_transfer="838868"
}
Set_config_forbid() {
	ssr_forbid=""
}

Set_user_api_server_pub_addr() {
	addr=$1
	if [[ "${addr}" == "Modify" ]]; then
		server_pub_addr=$(cat ${config_user_api_file} | grep "SERVER_PUB_ADDR = " | awk -F "[']" '{print $2}')
		if [[ -z ${server_pub_addr} ]]; then
			echo -e "${msg[25]}" && exit 1
		else
			echo -e "${msg[26]} ${Green}${server_pub_addr}${Font_end}"
		fi
	fi
	server_ip=$(curl -s https://2ip.ru)
	echo -e "${msg[27]} ${Ocean}${server_ip}${Font_end}"
	read -e -p "${msg[28]}" ssr_server_pub_addr
	[[ -z ${ssr_server_pub_addr} ]] && ssr_server_pub_addr="$server_ip"
	if [[ -z "${ssr_server_pub_addr}" ]]; then
		Get_IP
		if [[ ${ip} == "VPS_IP" ]]; then
			while true; do
				read -e -p "${msg[29]}" ssr_server_pub_addr
				if [[ -z "$ssr_server_pub_addr" ]]; then
					echo -e "${msg[30]}"
				else
					break
				fi
			done
		else
			ssr_server_pub_addr="${ip}"
		fi
	fi
	echo && echo ${Separator_1} && echo -e "	${msg[31]} ${Green}${ssr_server_pub_addr}${Font_end}" && echo ${Separator_1} && echo
}

Set_config_all() {
	Set_config_user
	Set_config_port
	Set_config_password
	Set_config_method
	Set_config_protocol
	Set_config_obfs
	Set_config_protocol_param
	Set_config_speed_limit_per_con
	Set_config_speed_limit_per_user
	Set_config_transfer
	Set_config_forbid
}

Add_port_user(){
    lalal=$1
    if [[ "$lalal" == "install" ]]; then
    	cd /usr/local/shadowsocksr
        match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
    else
    	echo
    fi
}

###################################

Get_IP() {
	ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
	if [[ -z "${ip}" ]]; then
		ip=$(wget -qO- -t1 -T2 api.ip.sb/ip)
		if [[ -z "${ip}" ]]; then
			ip=$(wget -qO- -t1 -T2 members.3322.org/dyndns/getip)
			if [[ -z "${ip}" ]]; then
				ip="VPS_IP"
			fi
		fi
	fi
}

Get_User_info() {
	Get_user_port=$1
	user_info_get=$(python mujson_mgr.py -l -p "${Get_user_port}")
	match_info=$(echo "${user_info_get}" | grep -w "### user ")
	if [[ -z "${match_info}" ]]; then
		echo -e "${msg[3]}[${msg[2]} ${ssr_port}] " && exit 1
	fi
	user_name=$(echo "${user_info_get}" | grep -w "user :" | awk -F "user : " '{print $NF}')
	port=$(echo "${user_info_get}" | grep -w "port :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	password=$(echo "${user_info_get}" | grep -w "passwd :" | awk -F "passwd : " '{print $NF}')
	method=$(echo "${user_info_get}" | grep -w "method :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	protocol=$(echo "${user_info_get}" | grep -w "protocol :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	protocol_param=$(echo "${user_info_get}" | grep -w "protocol_param :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	[[ -z ${protocol_param} ]] && protocol_param="${msg[4]}"
	obfs=$(echo "${user_info_get}" | grep -w "obfs :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	forbidden_port=$(echo "${user_info_get}" | grep -w "forbidden_port :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	[[ -z ${forbidden_port} ]] && forbidden_port="${msg[4]}"
	speed_limit_per_con=$(echo "${user_info_get}" | grep -w "speed_limit_per_con :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	speed_limit_per_user=$(echo "${user_info_get}" | grep -w "speed_limit_per_user :" | sed 's/[[:space:]]//g' | awk -F ":" '{print $NF}')
	Get_User_transfer "${port}"
}

Get_User_transfer() {
	transfer_port=$1
	all_port=$(${jq_file} '.[]|.port' ${config_user_mudb_file})
	port_num=$(echo "${all_port}" | grep -nw "${transfer_port}" | awk -F ":" '{print $1}')
	port_num_1=$(echo $((${port_num} - 1)))
	transfer_enable_1=$(${jq_file} ".[${port_num_1}].transfer_enable" ${config_user_mudb_file})
	u_1=$(${jq_file} ".[${port_num_1}].u" ${config_user_mudb_file})
	d_1=$(${jq_file} ".[${port_num_1}].d" ${config_user_mudb_file})
	transfer_enable_Used_2_1=$(echo $((${u_1} + ${d_1})))
	transfer_enable_Used_1=$(echo $((${transfer_enable_1} - ${transfer_enable_Used_2_1})))
	if [[ ${transfer_enable_1} -lt 1024 ]]; then
		transfer_enable="${transfer_enable_1} B"
	elif [[ ${transfer_enable_1} -lt 1048576 ]]; then
		transfer_enable=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_1}'/'1024'}')
		transfer_enable="${transfer_enable} KB"
	elif [[ ${transfer_enable_1} -lt 1073741824 ]]; then
		transfer_enable=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_1}'/'1048576'}')
		transfer_enable="${transfer_enable} MB"
	elif [[ ${transfer_enable_1} -lt 1099511627776 ]]; then
		transfer_enable=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_1}'/'1073741824'}')
		transfer_enable="${transfer_enable} GB"
	elif [[ ${transfer_enable_1} -lt 1125899906842624 ]]; then
		transfer_enable=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_1}'/'1099511627776'}')
		transfer_enable="${transfer_enable} TB"
	fi
	if [[ ${u_1} -lt 1024 ]]; then
		u="${u_1} B"
	elif [[ ${u_1} -lt 1048576 ]]; then
		u=$(awk 'BEGIN{printf "%.2f\n",'${u_1}'/'1024'}')
		u="${u} KB"
	elif [[ ${u_1} -lt 1073741824 ]]; then
		u=$(awk 'BEGIN{printf "%.2f\n",'${u_1}'/'1048576'}')
		u="${u} MB"
	elif [[ ${u_1} -lt 1099511627776 ]]; then
		u=$(awk 'BEGIN{printf "%.2f\n",'${u_1}'/'1073741824'}')
		u="${u} GB"
	elif [[ ${u_1} -lt 1125899906842624 ]]; then
		u=$(awk 'BEGIN{printf "%.2f\n",'${u_1}'/'1099511627776'}')
		u="${u} TB"
	fi
	if [[ ${d_1} -lt 1024 ]]; then
		d="${d_1} B"
	elif [[ ${d_1} -lt 1048576 ]]; then
		d=$(awk 'BEGIN{printf "%.2f\n",'${d_1}'/'1024'}')
		d="${d} KB"
	elif [[ ${d_1} -lt 1073741824 ]]; then
		d=$(awk 'BEGIN{printf "%.2f\n",'${d_1}'/'1048576'}')
		d="${d} MB"
	elif [[ ${d_1} -lt 1099511627776 ]]; then
		d=$(awk 'BEGIN{printf "%.2f\n",'${d_1}'/'1073741824'}')
		d="${d} GB"
	elif [[ ${d_1} -lt 1125899906842624 ]]; then
		d=$(awk 'BEGIN{printf "%.2f\n",'${d_1}'/'1099511627776'}')
		d="${d} TB"
	fi
	if [[ ${transfer_enable_Used_1} -lt 1024 ]]; then
		transfer_enable_Used="${transfer_enable_Used_1} B"
	elif [[ ${transfer_enable_Used_1} -lt 1048576 ]]; then
		transfer_enable_Used=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_1}'/'1024'}')
		transfer_enable_Used="${transfer_enable_Used} KB"
	elif [[ ${transfer_enable_Used_1} -lt 1073741824 ]]; then
		transfer_enable_Used=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_1}'/'1048576'}')
		transfer_enable_Used="${transfer_enable_Used} MB"
	elif [[ ${transfer_enable_Used_1} -lt 1099511627776 ]]; then
		transfer_enable_Used=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_1}'/'1073741824'}')
		transfer_enable_Used="${transfer_enable_Used} GB"
	elif [[ ${transfer_enable_Used_1} -lt 1125899906842624 ]]; then
		transfer_enable_Used=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_1}'/'1099511627776'}')
		transfer_enable_Used="${transfer_enable_Used} TB"
	fi
	if [[ ${transfer_enable_Used_2_1} -lt 1024 ]]; then
		transfer_enable_Used_2="${transfer_enable_Used_2_1} B"
	elif [[ ${transfer_enable_Used_2_1} -lt 1048576 ]]; then
		transfer_enable_Used_2=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_2_1}'/'1024'}')
		transfer_enable_Used_2="${transfer_enable_Used_2} KB"
	elif [[ ${transfer_enable_Used_2_1} -lt 1073741824 ]]; then
		transfer_enable_Used_2=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_2_1}'/'1048576'}')
		transfer_enable_Used_2="${transfer_enable_Used_2} MB"
	elif [[ ${transfer_enable_Used_2_1} -lt 1099511627776 ]]; then
		transfer_enable_Used_2=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_2_1}'/'1073741824'}')
		transfer_enable_Used_2="${transfer_enable_Used_2} GB"
	elif [[ ${transfer_enable_Used_2_1} -lt 1125899906842624 ]]; then
		transfer_enable_Used_2=$(awk 'BEGIN{printf "%.2f\n",'${transfer_enable_Used_2_1}'/'1099511627776'}')
		transfer_enable_Used_2="${transfer_enable_Used_2} TB"
	fi
}

urlsafe_base64() {
	date=$(echo -n "$1" | base64 | sed ':a;N;s/\n/ /g;ta' | sed 's/ //g;s/=//g;s/+/-/g;s/\//_/g')
	echo -e "${date}"
}

ss_link_qr() {
	SSbase64=$(urlsafe_base64 "${method}:${password}@${ip}:${port}")
	SSurl="ss://${SSbase64}"
	SSQRcode="https://api.qrserver.com/v1/create-qr-code/?data=${SSurl}"
	ss_link=" ${msg[5]} : ${Ocean}${SSurl}${Font_end}"
}

ssr_link_qr() {
	SSRprotocol=$(echo ${protocol} | sed 's/_compatible//g')
	SSRobfs=$(echo ${obfs} | sed 's/_compatible//g')
	SSRPWDbase64=$(urlsafe_base64 "${password}")
	SSRbase64=$(urlsafe_base64 "${ip}:${port}:${SSRprotocol}:${method}:${SSRobfs}:${SSRPWDbase64}")
	SSRurl="ssr://${SSRbase64}"
	SSRQRcode="https://api.qrserver.com/v1/create-qr-code/?data=${SSRurl}"
	ssr_link=" ${msg[7]}: ${Ocean}${SSRurl}${Font_end}"
}

ss_ssr_detimeine(){
    protocol_suffix=`echo ${protocol} | awk -F "_" '{print $NF}'`
    obfs_suffix=`echo ${obfs} | awk -F "_" '{print $NF}'`
    if [[ ${protocol} = "origin" ]]; then
        if [[ ${obfs} = "plain" ]]; then
            ss_link_qr
            ssr_link=""
        else
            if [[ ${obfs_suffix} != "compatible" ]]; then
                ss_link=""
            else
                ss_link_qr
            fi
        fi
    else
        if [[ ${protocol_suffix} != "compatible" ]]; then
            ss_link=""
        else
            if [[ ${obfs_suffix} != "compatible" ]]; then
                if [[ ${obfs_suffix} = "plain" ]]; then
                    ss_link_qr
                else
                    ss_link=""
                fi
            else
                ss_link_qr
            fi
        fi
    fi
    ssr_link_qr
}

View_User() {
	SSR_installation_status
	List_port_user && echo
	while true; do
		read -e -p "${msg[2]} " View_user_port
		[[ -z "${View_user_port}" ]] && echo -e "${msg[10]}" && read -n1 -r -p "${msg[1]}" && menu
		View_user=$(cat "${config_user_mudb_file}" | grep '"port": '"${View_user_port}"',')
		if [[ ! -z ${View_user} ]]; then
			Get_User_info "${View_user_port}"
			View_User_info
			break
		else
			echo -e "${msg[11]}"
			read -n1 -r -p "${msg[1]}"
			menu
		fi
	done
}

User_connection_info() {
	format_1=$1
	user_info=$(python mujson_mgr.py -l)
	user_total=$(echo "${user_info}" | wc -l)
	[[ -z ${user_info} ]] && echo -e "${msg[35]}" && read -n1 -r -p "${msg[1]}"	&& menu
	IP_total=$(netstat -anp | grep 'ESTABLISHED' | grep 'python' | grep 'tcp6' | awk '{print $5}' | awk -F ":" '{print $1}' | sort -u | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | wc -l)
	user_list_all=""
	for ((integer = 1; integer <= ${user_total}; integer++)); do
		user_port=$(echo "${user_info}" | sed -n "${integer}p" | awk '{print $4}')
		user_IP_1=$(netstat -anp | grep 'ESTABLISHED' | grep 'python' | grep 'tcp6' | grep ":${user_port} " | awk '{print $5}' | awk -F ":" '{print $1}' | sort -u | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
		if [[ -z ${user_IP_1} ]]; then
			user_IP_total="0"
		else
			user_IP_total=$(echo -e "${user_IP_1}" | wc -l)
			if [[ ${format_1} == "IP_address" ]]; then
				get_IP_address
			else
				user_IP=$(echo -e "\n${user_IP_1}")
			fi
		fi
		user_info_233=$(python mujson_mgr.py -l | grep -w "${user_port}" | awk '{print $2}' | sed 's/\[//g;s/\]//g')
		user_list_all=${user_list_all}"${msg[34]} ${Green}"${user_info_233}"${Font_end} | ${msg[2]} ${Green}"${user_port}"${Font_end} | ${msg[37]} ${Green}"${user_IP_total}"${Font_end} | ${msg[38]} ${Green}${user_IP}${Font_end}\n"
		user_IP=""
	done
	echo -e "${msg[36]} ${Green}"${IP_total}"${Font_end}  "
	echo -e "${user_list_all}"
	read -n1 -r -p "${msg[1]}"	
	menu
}

List_port_user(){
	user_info=$(python mujson_mgr.py -l)
	user_total=$(echo "${user_info}"|wc -l)
	[[ -z ${user_info} ]] && echo -e "${msg[35]}" && read -n1 -r -p "${msg[1]}"	&& menu
	user_port=$(echo "${user_info}"|sed -n "1p"|awk '{print $4}')
	user_username=$(echo "${user_info}"|sed -n "1p"|awk '{print $2}'|sed 's/\[//g;s/\]//g')
	Get_User_transfer "${user_port}"
	transfer_enable_Used_233=$(echo $((${transfer_enable_Used_233}+${transfer_enable_Used_2_1})))
	echo -e "${msg[35]} ${Green}${user_username}${Font_end} | ${msg[2]} ${Green}${user_port}${Font_end} | ${msg[40]} ${Green}${transfer_enable_Used_2}${Font_end}"
}

View_User_info() {
	ip=$(cat ${config_user_api_file} | grep "SERVER_PUB_ADDR = " | awk -F "[']" '{print $2}')
	[[ -z "${ip}" ]] && Get_IP
	ss_ssr_detimeine && clear 
	echo -e "
——————————————————————————————

${msg[12]} [${Green}${user_name}${Font_end}] ：

 ${msg[13]}      : ${Ocean}${ip}${Font_end}
 ${msg[14]}    : ${Ocean}${port}${Font_end}
 ${msg[15]} ${Ocean}${password}${Font_end}

 ${msg[16]} ${Ocean}${u}${Font_end} + ${msg[17]} ${Ocean}${d}${Font_end} = ${Ocean}${transfer_enable_Used_2}${Font_end}

${ss_link}

${ssr_link}

——————————————————————————————"
	echo
	read -n1 -r -p "${msg[1]}"
	menu
}


###################################

Modify_config_password() {
	match_edit=$(python mujson_mgr.py -e -p "${ssr_port}" -k "${ssr_password}" | grep -w "edit user ")
	if [[ -z "${match_edit}" ]]; then
		echo -e "${msg[32]} [${msg[2]} ${Green}${ssr_port}${Font_end}] "
		read -n1 -r -p "${msg[1]}"
		menu
	else
		echo -e "${msg[33]} [${msg[2]} ${Green}${ssr_port}${Font_end}]"
		read -n1 -r -p "${msg[1]}"
		menu
	fi
}

Modify_language(){
	echo -e "
${Green}[1]${Font_end} English [Default]
${Purple}[2]${Font_end} Русский
"
	read -p "> " language
	[[ -z "$language" ]] && language="1"
	if [[ ${language} == "1" ]]; then
		echo "en" > ${language_file}
		langset=en
	elif [[ ${language} == "2" ]]; then
		echo "ru" > ${language_file}
		langset=ru
	fi
	read -n1 -r -p "${msg[1]}"
	check_language && languages && menu
}

Modify_user_api_server_pub_addr() {
	sed -i "s/SERVER_PUB_ADDR = '${server_pub_addr}'/SERVER_PUB_ADDR = '${ssr_server_pub_addr}'/" ${config_user_api_file}
}

get_IP_address() {
	if [[ ! -z ${user_IP_1} ]]; then
		for ((integer_1 = ${user_IP_total}; integer_1 >= 1; integer_1--)); do
			IP=$(echo "${user_IP_1}" | sed -n "$integer_1"p)
			IP_address=$(wget -qO- -t1 -T2 http://freeapi.ipip.net/${IP} | sed 's/\"//g;s/,//g;s/\[//g;s/\]//g')
			user_IP="${user_IP}\n${IP}(${IP_address})"
			sleep 1s
		done
	fi
}

Modify_port() {
	List_port_user
	while true; do
		read -e -p "${msg[2]} " ssr_port
		[[ -z "${ssr_port}" ]] && echo -e "${msg[10]}" && read -n1 -r -p "${msg[1]}" && menu
		Modify_user=$(cat "${config_user_mudb_file}" | grep '"port": '"${ssr_port}"',')
		if [[ ! -z ${Modify_user} ]]; then
			break
		else
			echo -e "${msg[11]}"
		fi
	done
}

###################################

menu(){
	cd /usr/local/shadowsocksr
	check_sys
	[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${set[24]}${release}!" && exit 1
	domain=$(cat ${config_user_api_file} | grep "SERVER_PUB_ADDR = " | awk -F "[']" '{print $2}')
	ip=$(curl -s https://2ip.ru)
	clear
	echo -e "${lng[4]}"               
	echo
	menu_status
	echo && read -e -p "${lng[5]}" num
	case "$num" in
		0)
			clear
			exit
		;;
		1)
			clear
			Set_config_all
			Add_port_user "install"
			Set_iptables
			Add_iptables
			Save_iptables
		;;
		2)
			clear
			Modify_port
			Set_config_password
			Modify_config_password
		;;
		3)
			clear
			View_User
		;;
		4)
			clear
			User_connection_info
		;;
		5)
			clear
			Set_user_api_server_pub_addr "Modify"
			Modify_user_api_server_pub_addr
		;;
		6)
			clear
			Start_SSR
			read -n1 -r -p "${msg[1]}"	
			menu
		;;
		7)
			clear
			Stop_SSR
			read -n1 -r -p "${msg[1]}"	
			menu
		;;
		8)
			clear
			Restart_SSR
			read -n1 -r -p "${msg[1]}"	
			menu
		;;
		9)
			clear
			Install_SSR
		;;
		10)
			clear
		 	Uninstall_SSR
	  	;;
	  	11)
			clear
			Modify_language
		;;
		*)
			clear
			menu
		;;
	esac
}

###################################

clear && check_language && languages && menu
