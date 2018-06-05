# Import random module for this program
import random
'''
The program will first randomly generate a number unknown to the user.
The user needs to guess what that number is. (In other words, the user needs to be able to input information.)
If the user’s guess is wrong, the program should return some sort of indication as to how wrong (e.g. The number is too high or too low).
If the user guesses correctly, a positive indication should appear.
'''
def guess_the_number():
    result = random.randint(1, 99)
    return result
output=guess_the_number()
#print(output)
while True:
 num=int(input("Please enter to guess any two digit number that program will return. "))
 if 1 <= num < 100:
     if num == output:
         print("Great You guess correct Number")
         break
     elif num < output:
         print("Sorry You Guess Lesser Number. and the difference is " '-',output - num)
         break
     else:
         print("Sorry You Guess Larger Number. and the difference is", num - output)
         break
 else:
     print ("Please enter valid Number")
     break




