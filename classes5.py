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
        
class Developer(Employee):
    raise_amount = 1.10
    def __init__(self, first, last, salery, prog_lang):
##     super().__init__(self, first, last, salery)
     Employee.__init__(self, first, last, salery)
     self.prog_lang = prog_lang

class Manager(Employee):
    def __init__(self, first, last, salery, employees=None):
##     super().__init__(self, first, last, salery)
     Employee.__init__(self, first, last, salery)
     if employees is None:
         self.employees = []
     else:
         self.employees = employees
    def add_emp(self, emp):
        if emp not in self.employees:
            self.employees.append(emp)
    def remove_emp(self, emp):
        if emp in self.employees:
            self.employees.remove(emp)
    def print_emps(self):
        for emp in self.employees:
            print('-->', emp.fullname())
         
    

dev_1 = Developer('vaibhav', 'gaurihar', 60000, 'Python')
dev_2 = Developer('rakesh', 'khatpal', 100000, 'PHP')

mgr_1 = Manager('Navdeep', 'Singh', 120000, [dev_1])
##print(isinstance(mgr_1, Manager))
##print(issubclass(Manager, Developer))
##print(mgr_1.email)
##mgr_1.add_emp(dev_2)
##mgr_1.remove_emp(dev_1)
##mgr_1.print_emps()

##print (help(Developer))
##print(dev_2.email)
##print(dev_1.prog_lang)
##print(dev_2.pay)
##dev_2.apply_raise()
##print(dev_2.pay)



