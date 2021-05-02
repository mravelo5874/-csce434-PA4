#!/usr/bin/env python3
# coding=utf-8
from enum import Enum

# --------------------------------
#   Marco Ravelo
#   CSCE 434 - Compiler Design
#   Assignment #2 - 2/10/2021 
#   file: SymbolTable.py
# --------------------------------

# Resources used:
#   NONE

# --------------------------------
#   CHAR LIST
# --------------------------------
whitespace = ' \n\t\r\v\f'
alpha_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
alphaNums_chars = '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
nums_chars = '01234567890'
valid_chars = '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'

# --------------------------------
#   SYMBOL STUFF
# --------------------------------

class SymbolError(Exception):
    def __init__(self, msg):
        self.msg = msg
    
    def __str__(self):
        return 'SymbolError: %s' % self.msg

class SymbolType(Enum):
    INT = 0
    CODE = 1

class TableEntry():
    def __init__(self, lexeme, symbol_type, address):
        self.lexeme = lexeme
        self.symbol_type = symbol_type
        self.address = address

# --------------------------------
#   SYMBOL TABLE
# --------------------------------

class SymbolTable():

    def __init__(self):
        self.list = []
    
    # adds a symbol to the table
    def add_symbol(self, lexeme, symbol_type, address):
        # check to see if symbol already exists
        if (self.symbol_exists(lexeme)):
            return
            
        # add to list
        self.list.append(TableEntry(lexeme, symbol_type, address))

    # returns true if symbol already exists in the table
    def symbol_exists(self, symbol):
        for entry in self.list:
            if (symbol == entry.lexeme):
                return True
        return False

    def get_address(self, lexeme):
        # check if lexeme is a number
        is_num = True
        count = 0
        for char in lexeme:
            if (char == '-' and count == 0):
                continue
            if (char not in nums_chars):
                is_num = False
                break
            count += 1
        
       # return int if true
        if (is_num):
            return int(lexeme)

        # find lexeme address in table
        for entry in self.list:
            if (entry.lexeme == lexeme):
                return entry.address
        
        raise SymbolError('symbol \'%s\' not found in table' % lexeme)

    # prints out the table
    def print_table(self):
        
        print ('[SYMBOL TABLE]')
        print ('lexeme:\t\ttype:\t\taddress:')
        for entry in self.list:
            # print lexeme
            print (' %s' % entry.lexeme, end='')
            spaces = 15 - len(entry.lexeme)
            for _ in range(spaces):
                print (' ', end='')
            
            # print type
            print (' %s' % entry.symbol_type, end='')
            spaces = 15 - len(entry.symbol_type)
            for _ in range(spaces):
                print (' ', end='')

            # print address
            print (' %s' % entry.address, end='')
            spaces = 15 - len(str(entry.address))
            for _ in range(spaces):
                print (' ', end='')
            
            print ('')
            


    

