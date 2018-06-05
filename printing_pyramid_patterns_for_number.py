##Programs for printing pyramid patterns for number in Python
##Patterns can be printed in python using simple for loops. First outer loop is
##used to handle number of rows and Inner nested loop is used to handle the
##number of columns. Manipulating the print statements,
##different number patterns, alphabet patterns or star patterns can be printed.
##where n is provided by the user.


##Simple pyramid pattern
x = int(input("enter the n-th term. "))
##def printpattern(n):
##    for i in range(0,n):
##        for j in range(0, i + 1):
##            print("*", end = "")
##        print("\r")
##printpattern(x)

##After 180 degree rotation
##def printpattern2(n):
##    k = n - 1
##    for i in range(0,n):
##        for j in range(0,k):
##            print(end=" ")
##        k = k - 1
##        for j in range(0,i+1):
##            print("*", end="")
##        print("\r")
##
##printpattern2(x)
        
##Printing equileteral Triangle
##def triangle(n):
##    
##    for i in range(1,n+1):
##        for j in range(1,(n-i)+1):
##            print(end=" ")
##            
##        for j in range(0,2*i-1):
##            print("*", end="")
##        print("\r")
##triangle(x)
##def triangle(n):
##    ##For Row Printing
##    for i in range(0,n):
##        ##For Space Printing in coloumns
##        for j in range(0,n-i-1):
##            print(end=" ")
##        ##For * and Space printing in coloumns
##        for j in range(0,i+1):
##            print("*", end=" ")
##        print("\r")
##triangle(x)
def triangle(n):
    for i in range(0,n):
        ##print(str(i+1)*(i+1) + " "*(n-i-1))  ###Printing from left side
        ##print(" "*(n-i-1)+ str(i+1)*(i+1))  ###Printing From right Side
        print(" "*(n-i-1)+ (str(i+1) + " ")*(i+1))    #####Printing from center(equileteral trianle) downward
triangle(x)










