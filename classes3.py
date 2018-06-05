#/usr/bin/python
class Employee:
    raise_amount = 1.04
    No_of_emps = 0
    def __init__(self, first, last, salery):
        self.fname = first
        self.lname = last
        self.pay = salery
        self.email = first + last + '@netmagic.com'
        Employee.No_of_emps += 1
    def fullname(self):
        return self.fname+' '+self.lname
    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)
print (Employee.No_of_emps)
emp_1 = Employee('vaibhav', 'gaurihar', 60000)
emp_2 = Employee('rakesh', 'khatpal', 100000)
Employee.raise_amount = 1.05
emp_1.raise_amount = 1.06
print (Employee.No_of_emps)
print (Employee.raise_amount)
print (emp_1.raise_amount)
print (emp_2.raise_amount)



