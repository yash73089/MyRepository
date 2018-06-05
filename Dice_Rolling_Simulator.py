# Import random module for this program
import random

# from random import randint
#
# '''
#  this project involves writing a program that simulates rolling dice. When the program runs,
#   it will randomly choose a number between 1 and 6. (Or whatever other integer you prefer the number of sides on the die is up to you.)
#    The program will print what that number is. It should then ask you if you’d like to roll again.
# '''
#Create A function for roll dice
def roll_dice():
    result=random.randint(1,6)
    return result
#Calling the Function
output=roll_dice()
print("Your Number is",output)
#Logic to Ask the question to roll the dice again
while True:
 ask = input("Do you want to roll the dice again?. Y/N \n ")
 if ask == "Y":
    print("Your Number is",roll_dice())
    continue
 else:
    print("Thank You")
    break
