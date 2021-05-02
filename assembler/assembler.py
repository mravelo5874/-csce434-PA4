#!/usr/bin/env python3
# coding=utf-8
import SymbolTable

# --------------------------------
#   Marco Ravelo
#   CSCE 434 - Compiler Design
#   Assignment #2 - 2/10/2021 
#   file: Assembler.py
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
valid_chars = '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.:-'

# --------------------------------
#   NUMERIC OPCODES
# --------------------------------

opcodes = {
    'HALT':    0,
    'PUSH':    1,
    'RVALUE':  2,
    'LVALUE':  3,
    'POP':     4,
    'STO':     5,
    'COPY':    6,
    'ADD':     7,
    'SUB':     8,
    'MPY':     9,
    'DIV':     10,
    'MOD':     11,
    'NEG':     12,
    'NOT':     13,
    'OR':      14,
    'AND':     15,
    'EQ':      16,
    'NE':      17,
    'GT':      18,
    'GE':      19,
    'LT':      20,
    'LE':      21,
    'LABEL':   22,
    'GOTO':    23,
    'GOFALSE': 24,
    'GOTRUE':  25,
    'PRINT':   26,
    'READ':    27,
    'GOSUB':   28,
    'RET':     29
}

# instructions that precede int symbols
pre_int = {
    'PUSH',
    'RVALUE',
    'LVALUE'
}

# instructions that precede code symbols
pre_code = {
    'LABEL',
    'GOTO',
    'GOFALSE',
    'GOTRUE',
    'GOSUB'
}

# --------------------------------
#   ASSEMBLER ERROR
# --------------------------------

class AssemberError(Exception):
    def __init__(self, pos, line, pss, err, msg):
        self.pos = pos
        self.line = line
        self.err = err
        self.msg = msg
        self.pss = pss

    def __str__(self):
        return 'AssemberError[%s]: %s at line: %i pos: %i pass: %i' % (self.err, self.msg, self.line, self.pos, self.pss)

# --------------------------------
#   ASSEMBLER
# --------------------------------

class MyAssember:
    # --------------------------------
    #   INITIALIZER
    # --------------------------------

    def __init__(self, opts=[]):
        self.print = False
        
        for opt in opts:
            # options for assembler
            if (opt == '-print'):
                self.print = True

    def start(self, lines):
        self.lines = lines
        # combine all text into a single string
        self.text = ''
        for element in lines:
            self.text += element
        self.pos = 0
        self.line = 1
        self.pss = 1
        self.location_counter = 0
        self.length = len(self.text)
        self.prev_word = ''
        self.table = SymbolTable.SymbolTable()
        self.code_pos = 0
        self.code_line = 0

        try:
            return self.main_loop()
        except AssemberError as AError:
            print (AError)
        except SymbolTable.SymbolError as SError:
            print (SError, end='')
            print (' at line: %i pos: %i pass: %i' % (self.line, self.pos, self.pss))

    # --------------------------------
    #   MAIN LOOP
    # --------------------------------

    def main_loop(self):
        self.print_msg('[starting main loop]')
        first_word = self.get_next_word()
        self.print_msg('word found: %s' % first_word)

        # check to see if word is 'Section'
        if (first_word == 'Section'):
            section_type = self.get_next_word()
            self.print_msg('word found: %s' % section_type)

            # data section
            if (section_type == '.data'):
                word = ''
                while (self.pos <= self.length):
                    # get next word in text
                    word = self.get_next_word()
                    self.print_msg('word found: %s' % word)

                    # break from loop if word is 'Section'
                    if (word == 'Section'):
                        break

                    # remove ':' from end of word
                    word = word.replace(':', '')

                    # add to symbol table if valid
                    if (word not in opcodes and not self.is_num(word)):
                        next_word = self.get_next_word()
                        self.print_msg('word found: %s' % next_word)
                        if (next_word == 'word'):
                            self.table.add_symbol(word, 'INT', self.location_counter)
                            self.location_counter += 1
                        else:
                            raise AssemberError(self.pos, self.line, self.pss, 'SYMBOL TYPE', 'could not determine type of \'%s: %s' % (word, next_word))
                    else:
                        AssemberError(self.pos, self.line, self.pss, 'INVALID SYMBOL', 'invalid symbol \'%s\'' % word)
                
                word1 = self.get_next_word()
                if (word1 == '.code'):
                    self.code_pass_one()
                else:
                    raise AssemberError(self.pos, self.length, self.pss, 'INVALID SECTION', 'invalid section \'%s\'' % word1)

            # code section 1st pass
            elif (section_type == '.code'):
                self.code_pass_one()
            else:
                raise AssemberError(self.pos, self.length, self.pss, 'INVALID SECTION', 'invalid section \'%s\'' % section_type)

            # print symbol table
            if (self.print):
                self.table.print_table()

            # code section 2nd pass
            self.pos = self.code_pos
            self.line = self.code_line
            self.pss = 2
            code_list = []
            word = ''
            next_word = ''

            count = 0

            while (self.pos <= self.length and word != 'HALT'):
                # get next word in text
                word = self.get_next_word()
                self.print_msg('word found: %s' % word)

                # get second word if needed
                if (word in pre_int or word in pre_code):
                    next_word = self.get_next_word()
                    self.print_msg('word found: %s' % next_word)
                    comp_line = '\'' + word + ' ' + next_word + '\''
                else:
                    comp_line = '\'' + word + '\''
                
                # translate to machine code
                code = self.translate(word, next_word)
                code_list.append(self.bitstring_to_bytes(code))
                # print('%i %s : %s' % (count, code, comp_line))
                next_word = ''
                count += 1

            print('[translation complete]')
            return code_list

        else:
            raise AssemberError(self.pos, self.length, self.pss, 'NO SECTION', 'no section found')

    def code_pass_one(self):
        word = ''
        self.code_pos = self.pos
        self.code_line = self.line

        while (self.pos <= self.length and word != 'HALT'):
            # get next word in text
            word = self.get_next_word()
            self.print_msg('word found: %s' % word)

            if (word not in opcodes and not self.is_num(word)):
                symbol_type = self.symbol_type(word)
                # if symbol is INT, check to see if it exists in the symbol table
                if (symbol_type == 'INT'):
                    if (not self.table.symbol_exists(word)):
                        raise AssemberError(self.pos, self.line, self.pss, 'UNDEFINED SYMBOL', 'found symbol \'%s\' not present in symbol table' % word)
                elif (symbol_type == 'CODE'):
                    self.table.add_symbol(word, symbol_type, self.location_counter)
                    self.location_counter += 1

            self.prev_word = word

    # --------------------------------
    #   TRANSLATOR METHODS
    # --------------------------------

    def translate(self, opcode, operand=''):

        # bits 32-21 are zeros
        part1 = '0000'

        # bits 20-16 are op code
        part2 = self.opcode_bits(opcode)

        # bits 15-0 are operand (or zeros)
        if (operand != ''):
            part3 = self.operand_bits(operand)
        else:
            part3 = format(0, '016b')
        
        res = part1 + '' + part2  + '' + part3

        return res

    def opcode_bits(self, opcode):
        #print ('opcode: ', opcode)
        num = opcodes.get(opcode)
        #print ('num: ', num)
        bits = format(num, '05b')
        return bits


    def operand_bits(self, operand):
        #print ('operand: ', operand)
        num = self.table.get_address(operand)
        #print ('num: ', num)
        # deal with negative numbers
        bits = bin(num & (2**16-1))
        bits = bits[2:]
        bits = bits.zfill(16)
        #print ('bits: ', bits)
        return bits

    # --------------------------------
    #   HELPER METHODS
    # --------------------------------

    # skips over whitespace
    def ignore_whitespace(self):
        # skip any whitespace chars
        while (self.pos < self.length and self.text[self.pos] in whitespace):
            # increment line number when encountering a \n char
            if (self.text[self.pos] == '\n'):
                self.line += 1
            self.pos += 1
        return

    # gets the next word separated by whitespace
    def get_next_word(self):
        self.ignore_whitespace()

        # create word until whitespace detected or EOF
        temp_pos = self.pos
        while (temp_pos < self.length and self.text[temp_pos] not in whitespace):
            temp_pos += 1
        
        word_found = self.text[self.pos:temp_pos]

        # determine if word is vaild
        for char in word_found:
            if (char not in valid_chars):
                raise AssemberError(self.pos, self.line, self.pss, 'INVALID WORD', 'invalid char found \'%s\'' % char)

        self.pos = temp_pos
        return word_found

    # return true if word is a number, else false
    def is_num(self, word):
        count = 0
        for char in word:
            if (char == '-' and count == 0):
                continue
            elif (char not in nums_chars):
                return False
            count += 1
        return True

    # prints msg with position and line number
    def print_msg(self, msg):
        if (not self.print):
            return
        print ('line: %i pos: %i -> %s' % (self.line, self.pos, msg))

    # determine symbol type
    def symbol_type(self, symbol):
        if (self.prev_word in pre_int):
            return 'INT'
        elif (self.prev_word in pre_code):
            return 'CODE'
        else:
            raise AssemberError(self.pos, self.line, self.pss, 'INVALID SYMBOL', 'could not determine symbol type of \'%s\'' % symbol)
    
    # convert bit string to bytes
    def bitstring_to_bytes(self, str):
        return int(str, 2).to_bytes((len(str) + 7) // 8, byteorder='big')