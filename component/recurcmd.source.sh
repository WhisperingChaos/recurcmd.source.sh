#!/bin/bash
###############################################################################
#
#	Purpose:
#		Find all commands that match the provided name that appear in the 
#               current directory and its subordnates.  Once found, make the directory
#		containing the command the current working directory and then execute
#               the command.
#
#	Conventions
#		https://github.com/WhisperingChaos/SOLID_Bash
#
###############################################################################

recurcmd_list_gen(){
	local pipeSTATE
	recurcmd__pipe_option_save pipeSTATE
	set -o pipefail
	find -name "$1" | grep  "[^\.]"
	recurcmd__pipe_option_restore pipeSTATE
}

recurcmd_report (){
	echo
	echo "Cmd='$1' Work_Directory='$2'"
}

recurcmd_run(){
	local -r cmmdNAME="$1"
	local -r cmmdIS_RECURCMD="$2"
	local pipeSTATE
	recurcmd__pipe_option_save pipeSTATE
	set -o pipefail
	recurcmd_list_gen "$cmmdNAME" | recurcmd__run "$cmmdIS_RECURCMD"
	recurcmd__pipe_option_restore pipeSTATE
}

recurcmd__pipe_option_save(){
	eval $1=\"\$\(\set\ \+o \| \grep pipefail\)\"
}

recurcmd__pipe_option_restore(){
	eval \$$1
}

recurcmd__run(){
	local cmmdIS_RECURCMD="$1"
	if [ "$cmmdIS_RECURCMD" != 'true' ]; then
		cmmdIS_RECURCMD='false'
	fi
	local -r cmmdIS_RECURCMD

	local cmmdDIR
	local cmmdFILE_PATH
	local cmmdNAME
	while read -r cmmdFILE_PATH; do
		cmmdDIR="$(dirname "$cmmdFILE_PATH")"
		cmmdNAME="$(basename "$cmmdFILE_PATH")"
		if $cmmdIS_RECURCMD && [ "$cmmdDIR" = '.' ]; then
			# avoid infinite recursion
			continue
		fi
		recurcmd_report "$cmmdNAME" "$cmmdDIR"
		(
			cd "$cmmdDIR"
			./"$cmmdNAME"
		)
	done
}
