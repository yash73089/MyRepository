#/usr/bin/python
import datetime
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
    @classmethod
    def set_raise_amt(cls, amount):
        cls.raise_amount = amount
    @classmethod
    def from_string(cls, emp_str):
        fname, lname, pay = emp_str.split('-')
        return cls(fname, lname, pay)
    @staticmethod
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6:
            return False
        return True
        
    
##print (Employee.No_of_emps)
emp_1 = Employee('vaibhav', 'gaurihar', 60000)
emp_2 = Employee('rakesh', 'khatpal', 100000)
my_date = datetime.date(2017, 1, 31)
print (Employee.is_workday(my_date))
##emp_str_1 = 'shubham-shriwastav-40000'
##emp_str_2 = 'Eishan-Rana-30000'
##emp_str_3 = 'Faizan-fulara-35000'
####fname, lname, pay = emp_str_1.split('-')
##new_emp_1 = Employee.from_string(emp_str_2)
##print new_emp_1.fullname()
##print new_emp_1.pay
####Employee.raise_amount = 1.05
####emp_1.raise_amount = 1.06
####print (Employee.No_of_emps)
####Employee.set_raise_amt(1.05)
####emp_1.set_raise_amt(1.05)
####print (Employee.raise_amount)
####print (emp_1.raise_amount)
####print (emp_2.raise_amount)



