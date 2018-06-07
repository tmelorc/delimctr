def is_matched(expression):
    """
    Finds out how balanced an expression is.
    With a string containing only brackets.

    >>> is_matched('[]()()(((([])))')
    False
    >>> is_matched('[](){{{[]}}}')
    True
    """
    opening = tuple('({[')
    closing = tuple(')}]')
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
    ''' 
    https://stackoverflow.com/a/29992065/1778537
    '''
    
    toret = {}
    pstack = []

    for i, c in enumerate(s):
        if c in '([{':
            pstack.append(i)
        elif c in ')]}':
            if len(pstack) == 0:
                print s[:i+1]
                print "No matching closing parens at: " + str(i)
                #raise IndexError("No matching closing parens at: " + str(i))
            
            toret[pstack.pop()] = i

    if len(pstack) > 0:
        tmp = 0
        for i in pstack:
            print s[tmp:i+1],"<--- no matching\n"
            
            tmp = i+1
        print s[tmp:]
        
        #raise IndexError("No matching opening parens at: " + str(pstack.pop()))

    return toret

if __name__ == '__main__':
    import sys
    #import doctest
    #doctest.testmod()
    
    input_file = sys.argv[1]
    
    with open(input_file, 'r') as myfile:
        data = myfile.read()
    
    print "Matching delimiters? ", is_matched(data), "\n"
    #print "There is/are %d non matching", len(pstack)
    find_parens(data)
