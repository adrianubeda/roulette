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
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inical de${endColour} ${purpleColour}$initial_bet$ ${endColour}${grayColour}a${endColour}${turquoiseColour} $par_impar${endColour}"
	
	backup_bet=$initial_bet
	play_counter=1
	bad_plays=""
	max_money=$money
	tput civis

	while true; do
		money=$(($money-$initial_bet))
		#echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour} ${purpleColour}$initial_bet$ ${endColour} ${grayColour}y tienes${endColour} ${blueColour}$money$ ${endColour}"
		
		random_number="$(($RANDOM % 37))"
		#echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour} ${turquoiseColour}$random_number${endColour}"


		if [ ! "$money" -lt 0 ]; then
			# Apostando para numeros pares
			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
			#			echo -e "${redColour}[+] El número que ha salido es 0${endColour}"
			#			echo -e "${yellowColour}[+]${endColour}${grayColour} Pierdes un total de${endColour} ${redColour}$initial_bet$ ${endColour}${grayColour}, cantidad total de dinero${endColour} ${blueColour}$money$ ${endColour}"
						initial_bet=$(($initial_bet*2))	
						bad_plays+="$random_number "
					else
			#			echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par,¡Has ganado!${endColour}"
						reward=$(($initial_bet*2))
						money=$(($money+$reward))
						initial_bet=$backup_bet
			#			echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${greenColour}$reward$ ${endColour}${grayColour}, cantidad total de dinero${endColour} ${blueColour}$money$ ${endColour}"
						bad_plays=""
					fi
				else
			#		echo -e "${yellowColour}[+]${endColour}${redColour} El número que ha salido es impar, ¡Has perdido!${endColour}"
			#		echo -e "${yellowColour}[+]${endColour}${grayColour} Pierdes un total de${endColour} ${redColour}$initial_bet$ ${endColour}${grayColour}, cantidad total de dinero${endColour} ${blueColour}$money$ ${endColour}"
					initial_bet=$(($initial_bet*2))	
					bad_plays+="$random_number "
				fi
			
			# Apostando para numeros impares
			else
				if [ "$(($random_number % 2))" -eq 1 ]; then
			#		echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es impar,¡Has ganado!${endColour}"
			#		echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${greenColour}$reward$ ${endColour}${grayColour}, cantidad total de dinero${endColour} ${blueColour}$money$ ${endColour}"
						
					reward=$(($initial_bet*2))
					money=$(($money+$reward))
					initial_bet=$backup_bet
					bad_plays=""
				else
			#		echo -e "${yellowColour}[+]${endColour}${redColour} El número que ha salido es par, ¡Has perdido!${endColour}"
			#		echo -e "${yellowColour}[+]${endColour}${grayColour} Pierdes un total de${endColour} ${redColour}$initial_bet$ ${endColour}${grayColour}, cantidad total de dinero${endColour} ${blueColour}$money$ ${endColour}"

					initial_bet=$(($initial_bet*2))	
					bad_plays+="$random_number "

				fi
			fi
		else
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de ${endColour}${yellowColour}$(($play_counter-1))${endColour} ${grayColour}jugadas${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${grayColour} Malas jugadas consecutivas que han salido:${endColour}\n"

			echo -e "${blueColour}[ $bad_plays]${endColour}"

			echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La máxima cantidad de dinero acumulado ha sido de:${endColour} ${yellowColour}$max_money${endColour}"
			
			tput cnorm; exit 0
		fi

		if [ "$money" -gt "$max_money" ]; then
			max_money=$money
		fi


		let play_counter+=1
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

i
