# -*- coding: utf-8 -*-
"""
# Copyright (c) 2018, Thiago de Melo. All rights reserved.
# Thanks to people from 
# https://stackoverflow.com/a/29992065/1778537
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
"""

def is_matched(expression):
    """
    Finds out how balanced an expression is.
    With a string containing only brackets.

    >>> is_matched('[]()()(((([])))')
    False
    >>> is_matched('[](){{{[]}}}')
    True
    """
    
    opening = tuple('([')
    closing = tuple(')]')
    mapping = dict(zip(opening, closing))
    queue = []
    
    for letter in expression:
        if letter in opening:
            queue.append(mapping[letter])
        elif letter in closing:
            if not queue or letter != queue.pop():
                return False
    
    return not queue

def find_parens(s):
    
    toret = {}
    pstack = []

    for i, c in enumerate(s):
        if c in '([':
            pstack.append(i)
        elif c in ')]':
            if len(pstack) == 0:
                fc_arrow(s,i)
                #raise IndexError("No matching closing parens at: " + str(i))
            else:
                if c == ")" and s[pstack[-1]-1] == "\\" and s[pstack[-1]] == "[":
                    fc_arrow(s,i)
                if c == "]" and s[i-1] == "\\" and s[pstack[-1]] == "(":
                    #fc_arrow(s,pstack[-1])
                    None
                else:
                    toret[pstack.pop()] = i
    
    if len(pstack) > 0:
        for i in pstack:
            #j = s[:i].rfind("\n")
            #print s[j+1:i+1]
            fc_arrow(s,i)
        
        #raise IndexError("No matching opening parens at: " + str(pstack.pop()))

    return toret

def fc_arrow(s,i):
    j = s[:i].rfind("\n")
    jup = s[:j-1].rfind("\n")
    print s[jup+1:j]
    print s[j+1:i+1]
    arrow = " "*(i-j-1)+u"\u25B2".encode("utf-8")+'  *** no matching'
    print arrow

if __name__ == '__main__':
    import sys
    #import doctest
    #doctest.testmod()
    
    delimchk="delimchk"
    author="Thiago de Melo"
    github="https://github.com/tmelorc/delimctr"
    text1 = "This is {delimchk}. Created by {author}.".format(author=author, delimchk=delimchk.upper())
    text2 = "Visit {github} for updates.".format(github=github)
    dashed_line = "-"*len(text2)
    print '%s\n%s\n%s\n' % (text1,text2,dashed_line)
    
    input_file = sys.argv[1]
    #input_file = '/home/thiago/fastex-temp.tex'
    #input_file='/home/thiago/Dropbox/pesquisa/obstruction/transversality-01.tex'
    
    with open(input_file, 'r') as myfile:
        data = myfile.read()
    
    match = is_matched(data)
    print "Matching delimiters? %s\n" % str(match).upper()
    
    #print "There is/are %d non matching", len(pstack)
    if not match: find_parens(data)
