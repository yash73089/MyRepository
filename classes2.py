#/usr/bin/python
class Employee:

    def __init__(self, first, last, mobileNo):
        self.fname = first
        self.lname = last
        self.Mno = mobileNo
        self.email = first + last + '@netmagic.com'
    def fullname(self):
        return self.fname+' '+self.lname
        

emp_1 = Employee('vaibhav', 'gaurihar', 8600666967)
emp_2 = Employee('rakesh', 'khatpal', 8600666967)
    

print(emp_1.email)
print(emp_2.email)
print(emp_1.fullname())
print(emp_2.fullname())


