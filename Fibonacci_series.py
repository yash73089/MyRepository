##Fibonacci series program
##a series of numbers in which each number ( Fibonacci number ) is
##the sum of the two preceding numbers. The simplest is the series
##1, 1, 2, 3, 5, 8, etc.
## Program to display the Fibonacci sequence up to n-th term
##where n is provided by the user.

x = int(input("enter the n-th term. "))
### first two terms
##n1 = 0
##n2 = 1
##count = 0
##
### check if the number of terms is valid
##if x <= 0:
##        print("Please enter positive integer")
##elif x == 1:
##        print("Fibonacci sequence of.", x, ": 0")
##else:
##        print("Fibonacci sequence upto", x)
##        while count < x:
##                print(n1,end=',')
##                nth = n1 + n2
##                #Update Value
##                n1 = n2
##                n2 = nth
##                count += 1
def fib(n):
 a,b = 0,1
 for i in range(n):
  print(a,end=',')
  a,b = b,a+b
 return ''
print (fib(x))
        
 





