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
	assert_output_true test_report_expected Command Directory --- recurcmd_report Command Directory
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

test_list_gen(){

	assert_true test_list_gen_shell
}
test_list_gen_shell(){
	(
		cd ./testroot
		assert_output_true test_list_gen_expected --- recurcmd_list_gen "test.sh" 
	)
}
test_list_gen_expected(){
	echo "./test.sh"
	echo "./level1/test.sh"
	echo "./level1/level2/test.sh"
}

test_run(){

	assert_true test_run_shell
}
test_run_shell() {
	(
		cd ./testroot
		assert_output_true test_run_expected --- recurcmd_run "test.sh" 
	)
}
test_run_expected(){
	recurcmd_report "test.sh" '.'
	echo "testroot"
	recurcmd_report "test.sh" './level1'
	echo "level1"
	recurcmd_report "test.sh" './level1/level2'
	echo "level2"
}

test_run_recursive(){

	assert_true test_run_recursive_shell
}
test_run_recursive_shell() {
	(
		cd ./testroot
		assert_output_true test_run_recursive_expected --- recurcmd_run "test.sh" 'true'
	)
}
test_run_recursive_expected(){
	recurcmd_report "test.sh" './level1'
	echo "level1"
	recurcmd_report "test.sh" './level1/level2'
	echo "level2"
}

main(){
	config_executeable "$(dirname "${BASH_SOURCE[0]}")"
	assert_bool_performant
	test_pipe_option_save
	test_pipe_option_restore
	test_pipe_option_save_restore
	test_report
	test_list_gen
	test_run
	test_run_recursive
	assert_return_code_set
}
main
