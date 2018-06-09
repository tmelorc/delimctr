#!/bin/bash

# Copyright (c) 2018, Thiago de Melo. All rights reserved.
# Thanks to people from 
# https://stackoverflow.com/q/50648833/1778537
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, 
# this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
# Neither the name of the {organization} nor the names of its contributors may 
# be used to endorse or promote products derived from this software without 
# specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY 
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

delimctr="delimctr"
thiago="Thiago de Melo"
github="https://github.com/tmelorc/delimctr"

input_file=${@: -1}

while getopts "ic" opt; do
  case $opt in
    i)
      ignore="true"
      ;;
    c)
      color="false"
      ;;
    \?)
      echo "Invalid option: -$OPTARG."
      exit 1
      ;;
	:)
	  echo "Option -$OPTARG requires an argument." && exit 1
	  ;;
  esac
done

if [ "$color" != "false" ]; then
      Red='\033[0;31m'          # Red
      BRed='\033[1;31m'         # Red
      BBlue='\033[1;34m'        # Blue
      BWhite='\033[1;37m'       # White
      off='\033[0m'             # off
fi
clear

printf "This is %s. Created by %s.\\n" "${delimctr^^}" "$thiago"
printf "Visit %s for updates\\n\\n" "$github"

printf "Checking delimiters on file:\\n${BBlue}%s\\n" "${input_file}"
[[ "$ignore" == "true" ]] && 
printf "${Red}** Ignoring commented lines\\n"


if [[ "$ignore" = "true" ]]; then
o_brace=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o '{'  | wc -l)
c_brace=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o '}'  | wc -l)
o_bracket=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o '\['  | wc -l)
c_bracket=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o '\]'  | wc -l)
o_paren=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o '('  | wc -l)
c_paren=$(grep '^[[:blank:]]*[^[:blank:]%]' "${input_file}" | grep  -o ')'  | wc -l)
else
o_brace=$(grep  -o '{' "${input_file}" | wc -l)
c_brace=$(grep  -o '}' "${input_file}" | wc -l)
o_bracket=$(grep  -o '\[' "${input_file}" | wc -l)
c_bracket=$(grep  -o '\]' "${input_file}" | wc -l)
o_paren=$(grep  -o '(' "${input_file}" | wc -l)
c_paren=$(grep  -o ')' "${input_file}" | wc -l)
fi

gap_brace=$(( o_brace - c_brace ))
gap_bracket=$(( o_bracket - c_bracket ))
gap_paren=$(( o_paren - c_paren ))

printf ${BWhite}""
printf        "\\nopening parenthesis (  %d" "${o_paren}"
printf        "\\nclosing parenthesis )  %d" "${c_paren}"
[ $gap_paren != 0 ] && 
printf ${BRed}"\\n   missing or extra    %d" "${gap_paren#-}"

xymatrix=0
[ $gap_paren != 0 ] && xymatrix=$(grep -c -o 'xymatrix' "${input_file}" )
if [ "$xymatrix" != 0 ]; then
    l_hook=$(grep -o '\^{(}' "${input_file}" | wc -l)
    r_hook=$(grep -o '\^{)}' "${input_file}" | wc -l)
    l_hook_lineno=$(grep -n '\^{(}' "${input_file}" | grep -Eo '^[^:]+')
    r_hook_lineno=$(grep -n '\^{)}' "${input_file}" | grep -Eo '^[^:]+')
    [ "$r_hook" != 0 ] || [ "$l_hook" != 0 ] && printf "\\n\\n** xymatrix inclusion arrows found; it uses unpaired ( )\\n** see line(s): "
    echo -n $l_hook_lineno $r_hook_lineno
fi

item=0
[ "$gap_paren" != 0 ] && item=$(grep -c -E '\s*\[\s*\w+\)\s*\]' "${input_file}")
if [ "$item" != 0 ]; then
    item_lineno=$(grep -n -E '\s*\[\s*\w+\)\s*\]' "$input_file" | grep -Eo '^[^:]+')
    printf "\\n\\n** labeled items found; it could use unpaired ( )\\n** see line(s): "
    echo -n $item_lineno
fi

l_paren=0
r_paren=0
[ "$gap_paren" != 0 ] && l_paren=$(grep -c -E '\\left\(' "${input_file}")
[ "$gap_paren" != 0 ] && r_paren=$(grep -c -E '\\right\)' "${input_file}")
if [ "$l_paren" != 0 ] || [ "$r_paren" != 0 ]; then
    l_lineno=$(grep -n -E '\\left\(' "$input_file" | grep -Eo '^[^:]+')
    r_lineno=$(grep -n -E '\\right\)' "$input_file" | grep -Eo '^[^:]+')
    printf "\\n\\n** left( or right) found; it could use unpaired ( ); not a problem\\n** see line(s): "
    echo -n $l_lineno $r_lineno
fi

printf ${BWhite}"\\n"
printf        "\\nopening brackets [  %d" "${o_bracket}"
printf        "\\nclosing brackets ]  %d" "${c_bracket}"
[ $gap_bracket != 0 ] && 
printf ${BRed}"\\nmissing or extra    %d" "${gap_bracket#-}"

l_bracket=0
r_bracket=0
[ "$gap_bracket" != 0 ] && l_bracket=$(grep -c -E '\\left\[' "${input_file}")
[ "$gap_bracket" != 0 ] && r_bracket=$(grep -c -E '\\right\]' "${input_file}")
if [ "$l_bracket" != 0 ] || [ "$r_bracket" != 0 ]; then
    l_lineno=$(grep -n -E '\\left\[' "$input_file" | grep -Eo '^[^:]+')
    r_lineno=$(grep -n -E '\\right\]' "$input_file" | grep -Eo '^[^:]+')
    printf "\\n\\n** left[ or right] found; it could use unpaired [ ]; not a problem\\n** see lines: "
    echo -n $l_lineno $r_lineno
fi


printf ${BWhite}"\\n"
printf        "\\n  opening braces { %d" "${o_brace}"
printf        "\\n  closing braces } %d" "${c_brace}"
[ $gap_brace != 0 ] && 
printf ${BRed}"\\nmissing or extra   %d" "${gap_brace#-}"

l_brace=0
r_brace=0
[ "$gap_brace" != 0 ] && l_brace=$(grep -c -E '\\left\\{' "${input_file}")
[ "$gap_brace" != 0 ] && r_brace=$(grep -c -E '\\right\\}' "${input_file}")
if [ "$l_brace" != 0 ] || [ "$r_brace" != 0 ]; then
    l_lineno=$(grep -n -E '\\left\\{' "$input_file" | grep -Eo '^[^:]+')
    r_lineno=$(grep -n -E '\\right\\}' "$input_file" | grep -Eo '^[^:]+')
    printf "\\n\\n** left\{ or right\} found; it could use unpaired { }; not a problem\\n** see line(s): "
    echo -n $l_lineno $r_lineno
fi

#
printf ${off}"\\n\\n"
## end of file delimctr.sh
