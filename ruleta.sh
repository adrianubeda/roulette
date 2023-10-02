#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
whiteColour='\033[01;37m'

# Ctrl+C
trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm; exit 1
	
}


function helpPanel(){
	echo -e "\n ${greenColour}[+]${endColour} ${grayColour}Uso:${endColour}${purpleColour} $0${endColour}\n"
	echo -e "\t ${blueColour}-m)${endColour} ${grayColour}Dinero con el que se desea jugar${endColour}"
	echo -e "\t ${blueColour}-t)${endColour} ${grayColour}Técnica con la que se desea jugar${endColour}${blueColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${blueColour})${endColour}\n"
	exit 1
}

function martingala(){
	echo -e "\n${greenColour}[+]${endColour}${grayColour} Dinero actual:${endColour} ${purpleColour}$money$ ${endColour}\n"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero quieres apostar? ->${endColour} " && read initial_bet
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? ->${endColour}" && read par_impar

	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inical de${endColour} ${purpleColour}$initial_bet$ ${endColour}${grayColour}a${endColour}${turquoiseColour} $par_impar${endColour}"
	
	tput civis

	while true; do
		random_number="$(($RANDOM % 37))"
		echo -e "\n[+] Ha salido el número $random_number"
	
		if [ "$(($random_number % 2))" -eq 0 ]; then
			if [ "$random_number" -eq 0 ]; then
				echo "[+] El número que ha salido es 0"
			else
				echo "[+] El número que ha salido es par"
			fi
		else
			echo "[+] El número que ha salido es impar"
		fi

		sleep 0.2
	done

	tput cnorm
}

while getopts "m:t:h" arg; do
	case $arg in 
		m) money=$OPTARG;;
	  	t) technique=$OPTARG;;
	  	h) helpPanel;;
	esac
done


if [ $money ] && [ $technique ]; then
	if [ "$technique" == "martingala" ]; then
		martingala
	else
		echo -e "\n ${redColour}[!] La técnica introducida no existe${endColour}"
		helpPanel
	fi

else
	helpPanel
fi


