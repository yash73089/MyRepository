##A palindromic number or numeral
##palindrome is a number that remains the same when its digits are reversed.
x = int(input("enter the first number. "))
y = x
sum = 0
while y > 0:
        i = y % 10
        sum = sum * 10 + i
        y = y // 10

if x == sum:
        print (x, "is an palindrome number")
else:
        print (x, "is not palindromic number")





####Code for string palindromic 
##num = input("Enter any string: ")
##rev_num = reversed(num) 
## check if the string is equal to its reverse 
##if list(num) == list(rev_num): 
##             print("Palindrome string") 
##else: 
##             print("Not Palindrome string")
##
