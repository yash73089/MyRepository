##Programs for printing pyramid patterns for Alphabets in Python
##Patterns can be printed in python using simple for loops. First outer loop is
##used to handle number of rows and Inner nested loop is used to handle the
##number of columns. Manipulating the print statements,
##different number patterns, alphabet patterns or star patterns can be printed.
##where n is provided by the user.


##Simple pyramid pattern
x = int(input("enter the n-th term. "))
##def triangle(n):
##    for i in range(1,n):
##        for j in range(65, 65+i):
##            print(" "*(n-i-1)+ (str(j))#####Printing from center(equileteral trianle) downward
##triangle(x)

for i in range(0,x):
        for j in range(65, 65+i):
            #chars = chr(j)
            print (" "*(x-i-1) + (chr(j)+ " "))
        print("\r")
