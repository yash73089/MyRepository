#!C:\Python27\python.exe
# -*-coding: utf-8 -*-
import math
var1 = raw_input("eneter the value?. ")

def factorial(n):

        if int(n) < 0:
               print "Factorial is only defined for positive integers."
               return -1
        elif int(n) == 0:
                return 1
        elif int(n) > 0:
              return int(n) * factorial(int(n)-1)
        else:
            print "Factorial is only defined for integers."
            return -1

result = factorial(var1)
print result

