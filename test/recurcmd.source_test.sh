#!/bin/bash
config_executeable(){
	local -r myRoot="$1"
	# include components required to create this executable
	local mod
	for mod in $( "$myRoot/sourcer/sourcer.sh" "$myRoot"); do
		source "$mod"
	done
}

test_report (){
	assert_output_true recurcmd_report Command Directory --- test_report_expected Command Directory
}
test_report_expected(){
	echo
	echo "Cmd='$1' Work_Directory='$2'"
}

test_pipe_option_save(){
	local pipeSTATE

	assert_false '[ "$pipeSTATE" = "$( set +o | grep pipefail )" ]'

	recurcmd__pipe_option_save pipeSTATE
	assert_true '[ "$pipeSTATE" = "$( set +o | grep pipefail )" ]'
}

test_pipe_option_restore(){
	local -r pipeSTATE="$( set +o | grep pipefail )"
	
	recurcmd__pipe_option_restore pipeSTATE
	assert_true '[ "$pipeSTATE" = "$( set +o | grep pipefail )" ]'

	set +o pipefail
	if [ "$pipeSTATE" = "${pipeSTATE##+o}" ]; then
		set -o pipefail
	fi
	assert_true '[ "$pipeSTATE" != "$( set +o | grep pipefail )" ]'
	recurcmd__pipe_option_restore pipeSTATE
	assert_true '[ "$pipeSTATE" = "$( set +o | grep pipefail )" ]'
}

test_pipe_option_save_restore(){
	local -r pipeSTATE_CUR="$( set +o | grep pipefail )"

	local pipeSTATE
	recurcmd__pipe_option_save pipeSTATE
	assert_true '[ "$pipeSTATE_CUR" = "$( set +o | grep pipefail )" ]'
	recurcmd__pipe_option_restore pipeSTATE
	assert_true '[ "$pipeSTATE_CUR" = "$( set +o | grep pipefail )" ]'
}

main(){
	config_executeable "$(dirname "${BASH_SOURCE[0]}")"
	assert_bool_detailed
	test_report
	test_pipe_option_save
	test_pipe_option_restore
	test_pipe_option_save_restore
	assert_return_code_set
}
main
