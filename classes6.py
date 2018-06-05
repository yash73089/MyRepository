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
    def __repr__(self):
        return "Employee('{}', '{}', {})".format(self.fname, self.lname, self.pay)
    def __str__(self):
        return '{} - {}'.format(self.fullname(), self.email)
    def __add__(self, other):
        return self.pay + other.pay
    def __len__(self):
        return len(self.fullname())

    
emp_1 = Employee('vaibhav', 'gaurihar', 60000)
emp_2 = Employee('rakesh', 'khatpal', 100000)
print(len(emp_1))
##print(emp_1 + emp_2)
##print (emp_1)
##print(emp_1.__repr__())
##print(emp_1.__str__())
##print(1 + 2)
##print('a' + 'b')





