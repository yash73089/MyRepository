### Receive input from the user 
x = int(input("enter the number. "))
i = 2
if x == 1:
        print (str(x) + " " "is not a prime number")
else:
        while i < x :
          if x % i == 0:
            print (str(x) + " " "is not a prime number")
            break
          i = i + 1

        else:
          print (str(x) + " " "is a prime number")
            
### Receive input from the user
##num = int(input("Enter a number: "))
##
### prime numbers are greater than 1
##if num > 1:
##   # check for factors
##   for i in range(2,num):
##       if (num % i) == 0:
##           print(num,"is not a prime number")
##           break
##   else:
##       print(num,"is a prime number")
##       
### if input number is less than
### or equal to 1, it is not prime
##else:
##   print(num,"is not a prime number")
