## Reverse No
##This program reverse the number entered by the user and
##then prints the reversed number on the screen.
x = int(input("enter the first number. "))
y = x
reverse = 0
while y > 0:
        i = y % 10
        reverse = reverse * 10 + i
        y = y // 10

print("Reverse No of enter No is.", reverse)





