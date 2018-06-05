
##A leap year is exactly divisible by 4 except for century years
##(years ending with 00). The century year is a leap year only if it
##is perfectly divisible by 400.
### Receive input from the user 
year = int(input("enter the year. "))
if year % 4 == 0:
        if year % 100 ==0:
                if year % 400 == 0:
                        print (year, "is leap year")

                else:
                        print (year, "is not leap year")
        else:
                print (year, "is leap year")

else:
                print (year, "is not leap year")                
##import calendar
##print (calendar.isleap(year))
