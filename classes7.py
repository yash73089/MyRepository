#/usr/bin/python
class Employee():
    raise_amount = 1.04
    No_of_emps = 0
    def __init__(self, first, last):
        self.first = first
        self.last = last
    @property
    def email(self):
##        return '{}{}@netmagic.com'.format(self.fname, self.lname)
          return self.first + self.last + '@netmagic.com'
    @property    
    def fullname(self):
        return self.first+' '+self.last
    @fullname.setter
    def fullname(self, name):
        first, last = name.split(' ')
        self.first = first
        self.last = last

    @fullname.deleter
    def fullname(self):
        print('Delete Name!')
        self.first = None
        self.last = None
        
emp_1 = Employee('vaibhav', 'gaurihar')
emp_1.fullname = 'Rakesh Khatpal'
print(emp_1.first)
print(emp_1.email)
print(emp_1.fullname)
del emp_1.fullname





