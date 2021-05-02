#!/usr/bin/env python3
# coding=utf-8
import os.path
import sys
import assembler

# --------------------------------
#   Marco Ravelo
#   CSCE 434 - Compiler Design
#   Assignment #2 - 2/10/2021 
#   file: start.py
# --------------------------------

# Resources used:
#   NONE

if __name__ == '__main__':
        
    assember_opts = []
    print_hex = False

    # command line arguments
    if ('-help' in sys.argv):
        print ('\tThis program translates a hypothetical stack into machine code.\n\n\tCommand:\n\t>python start.py [file name] [options: -print -hex -help])\n\n\tAfter translation, the machine code is written to \'a.bin\'.')
        sys.exit()
    if ('-print' in sys.argv):
        assember_opts.append('-print')
    if ('-hex' in sys.argv):
        print_hex = True

    while (True):
        # prompt user for input file name
        input_file = input ('Input file name [Press \'Enter\' to user default - input.txt]: ')

        # check if blank, change to default
        if (input_file == ''):
            input_file = 'input.txt'

        if (os.path.isfile(input_file)):
            break
        else:
            print ('ImportError: could not find file', input_file)

    print ('[Found file %s]' % input_file)

    # open file and read all lines (removing any '\n' chars)
    with open (input_file, 'r') as open_file:
        lines = open_file.readlines()
    
    assembler = assembler.MyAssember(assember_opts)
    code = assembler.start(lines)

    if (code != None):
        # open output file and write code to it
        count = 0
        with open ('a.bin', 'wb+') as output_file:
            for line in code:
                if (print_hex):
                    print ('%i %s' %(count, line))
                count += 1
                output_file.write(line)