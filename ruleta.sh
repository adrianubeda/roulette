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

function inverseLabrouchere(){
	echo -e "\n${greenColour}[+]${endColour}${grayColour} Dinero actual:${endColour} ${purpleColour}$money$ ${endColour}\n"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

	declare -a my_sequence=(1 2 3 4)	

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

	bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

	jugadas_totales=0
	bet_to_renew=$(($money + 50))

	echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope de renovar la secuencia está establecido por encima en${grayColour} ${purpleColour}$bet_to_renew$ ${purpleColour}"	

	tput civis
	while true; do
		random_number=$(($RANDOM % 37))
		money=$(($money - $bet))
		let jugadas_totales+=1

		if [ ! "$money" -lt 0 ]; then
		
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${purpleColour} $bet$ ${endColour}"
			echo -e "${yellowColour}[+]${endColour} ${grayColour}Tenemos${endColour} ${purpleColour}$money$ ${endColour}"

			echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${yellowColour}$random_number${endColour}"

			if [ "$par_impar" == "par" ]; then 
				if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ] ; then
					echo -e "${yellowColour}[+]${endColour}${grayColour} El número es par ganas${endColour}"
					reward=$(($bet*2))
					let money+=$reward
					echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${purpleColour}$money$ ${endColour}"
					
					if [ $money -gt $bet_to_renew ]; then
						echo -e "${yellowColour}[+]${endColour}${grayColour} Se ha superado el tope establecido de${endColour} ${purpleColour}$bet_to_renew$ ${endColour}${grayColour}para renovar nuestra secuencia${endColour}"
						bet_to_renew=$(($bet_to_renew + 50))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}El nuevo tope establecido es${endColour} ${purpleColour}$bet_to_renew$ ${endColour}"
						my_sequence=(1 2 3 4)
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia ha sido restablecida a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
					elif [ $money -lt $(($bet_to_renew-100)) ]; then
						echo -e "${yellowColour}[+]${endColour}${grayColour} Se ha alcanzado a un mímimo crítico, se procede a reajustar el tope${endColour}"
						bet_to_renew=$(($bet_to_renew - 50))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${purpleColour}$bet_to_renew$ ${endColour}"
						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})
						
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]} -ne 0" ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1 ]; then
							bet=${my_sequence[0]}
						else
							echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
							my_sequence=(1 2 3 4)
							echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))	
						fi

					else
						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})
						
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]} -ne 0" ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1 ]; then
							bet=${my_sequence[0]}
						else
							echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
							my_sequence=(1 2 3 4)
							echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))	
						fi
					fi
				elif [ "$(($random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
					if [ "$(($random_number % 2))" -eq 1 ]; then
						echo -e "${redColour}[!] El número es impar, ¡Has perdido!${endColour}"
					else
						echo -e "${redColour}[!] Ha salido el número 0, ¡Has perdido!${endColour}"
					fi

		#				echo -e "${redColour}[!] Has perdido${endColour}"

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null

					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es:${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						
					if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi
				fi
			else
				if [ "$(($random_number % 2))" -eq 1 ] && [ "$random_number" -ne 0 ] ; then
					echo -e "${yellowColour}[+]${endColour}${grayColour} El número es impar ganas${endColour}"
					reward=$(($bet*2))
					let money+=$reward
					echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${purpleColour}$money$ ${endColour}"
					
					if [ $money -gt $bet_to_renew ]; then
						echo -e "${yellowColour}[+]${endColour}${grayColour} Se ha superado el tope establecido de${endColour} ${purpleColour}$bet_to_renew$ ${endColour}${grayColour}para renovar nuestra secuencia${endColour}"
						bet_to_renew=$(($bet_to_renew + 50))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}El nuevo tope establecido es${endColour} ${purpleColour}$bet_to_renew$ ${endColour}"
						my_sequence=(1 2 3 4)
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia ha sido restablecida a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
					elif [ $money -lt $(($bet_to_renew-100)) ]; then
						echo -e "${yellowColour}[+]${endColour}${grayColour} Se ha alcanzado a un mímimo crítico, se procede a reajustar el tope${endColour}"
						bet_to_renew=$(($bet_to_renew - 50))
						echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${purpleColour}$bet_to_renew$ ${endColour}"
						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})
						
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]} -ne 0" ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1 ]; then
							bet=${my_sequence[0]}
						else
							echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
							my_sequence=(1 2 3 4)
							echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))	
						fi

					else
						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})
						
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]} -ne 0" ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1 ]; then
							bet=${my_sequence[0]}
						else
							echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
							my_sequence=(1 2 3 4)
							echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))	
						fi
					fi
				elif [ "$(($random_number % 2))" -eq 0 ] || [ "$random_number" -eq 0 ]; then
					if [ ! "$random_number" -eq 0 ]; then
						echo -e "${redColour}[!] El número es par, ¡Has perdido!${endColour}"
					else
						echo -e "${redColour}[!] Ha salido el número 0, ¡Has perdido!${endColour}"
					fi

		#				echo -e "${redColour}[!] Has perdido${endColour}"

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null

					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es:${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						
					if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi
				fi

			fi
		else
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}"
			echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour}${yellowColour} $jugadas_totales ${endColour}${grayColour}jugadas${endColour}\n"
			tput cnorm; exit 1
		fi

		#sleep 2
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
	elif [ "$technique" == "inverseLabrouchere" ]; then	
		inverseLabrouchere
	else
		echo -e "\n ${redColour}[!] La técnica introducida no existe${endColour}"
		helpPanel
	fi

else
	helpPanel
fi


