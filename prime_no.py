x = int(input("Please enter a no. "))
i = 2
if x == 1:
    print(x, "is not prime no.")
else:
 while i < x:
    if x % i == 0:
        print(x, "is not a prime no")
        break
    i = i + 1
 else:
     print(x,"is a prime no")