### Purpose

Find all commands that match the provided name that appear in the  current directory and its subordinates.  Once found, make the directory containing the command the current working directory and then execute the command.

### Conventions

[SOLID bash](https://github.com/WhisperingChaos/SOLID_Bash)

### How to Use

- Download the [recurcmd.source.sh](./component/recurcmd.source.sh) to an appropriate directory.
- use the bash ["**.**" (A.K.A: source)](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) command to include its functions into an aggregate bash script.

In addition to the above, this repository has been structured to adhere to component composition conventions supported by [sourcer.sh](https://github.com/WhisperingChaos/sourcer.sh/blob/master/component/base/sourcer.source.sh) which provides a framework to construct a script from any number of bash components.
