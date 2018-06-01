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

clear
input_file=/home/thiago/Dropbox/thiago-modelo-tematico[2017].tex
#input_file=$1
echo -e "Checking delimiters on file \033[1;34m${input_file}"

o_brace=$(grep  -o "{" ${input_file} | wc -l)
c_brace=$(grep  -o "}" ${input_file} | wc -l)
gap_brace=$(( o_brace - c_brace ))

o_bracket=$(grep  -o "\[" ${input_file} | wc -l)
c_bracket=$(grep  -o "\]" ${input_file} | wc -l)
gap_bracket=$(( o_bracket - c_bracket ))

o_paren=$(grep  -o "(" ${input_file} | wc -l)
c_paren=$(grep  -o ")" ${input_file} | wc -l)
gap_paren=$(( o_paren - c_paren ))

printf '\033[1;37m'""
printf             "\n  opening parentheses (  ${o_paren}"
printf             "\nclosening parentheses )  ${c_paren}"
[ $gap_paren != 0 ] && 
printf '\033[1;31m'"\n     missing or extra    ${gap_paren#-}"

xymatrix=0
[ $gap_paren != 0 ] && xymatrix=$(grep -c -o "xymatrix" ${input_file} )
if [ $xymatrix != 0 ]; then
    l_hook=$(grep -o "\^{(}" ${input_file} | wc -l)
    r_hook=$(grep -o "\^{)}" ${input_file} | wc -l)
    l_hook_lineno=$(grep -n "\^{(}" ${input_file} | grep -Eo '^[^:]+')
    r_hook_lineno=$(grep -n "\^{)}" ${input_file} | grep -Eo '^[^:]+')
    [ $r_hook != 0 ] || [ $l_hook != 0 ] && printf "\n\n** xymatrix inclusion arrows found; it uses unpaired ( )\n** see lines: "
    echo -n $l_hook_lineno $r_hook_lineno
fi

item=0
[ $gap_paren != 0 ] && item=$(grep -c -E '\s*\[\s*\w+\)\s*\]' ${input_file})
#item=$(tr -d " \t" < ${input_file} | grep -c '\[[0-9A-Za-z])\]'  )
if [ $item != 0 ]; then
    item_lineno=$(grep  -n -E '\s*\[\s*\w+\)\s*\]' ${input_file} | grep -Eo '^[^:]+' )
    #$(tr -d " \t" < ${input_file} | grep -n '\[[0-9A-Za-z])\]' | grep -Eo '^[^:]+')
    printf "\n\n** labeled items found; it could use unpaired ( )\n** see lines: "
    echo -n $item_lineno
fi

printf '\033[1;37m'"\n"
printf             "\n  opening brackets [  ${o_bracket}"
printf             "\nclosening brackets ]  ${c_bracket}"
[ $gap_bracket != 0 ] && 
printf '\033[1;31m'"\n missing or extra    ${gap_bracket#-}"

printf '\033[1;37m'"\n"
printf             "\n  opening braces { ${o_brace}"
printf             "\nclosening braces } ${c_brace}"
[ $gap_brace != 0 ] && 
printf '\033[1;31m'"\nmissing or extra   ${gap_brace#-}"
printf '\033[0;37m'"\n\n"
