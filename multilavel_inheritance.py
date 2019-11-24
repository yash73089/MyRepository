class company:
    def __init__(self,name,location,type):
        self.Company_Name = name
        self.Company_Location = location
        self.Company_type = type
class Employee(company):
    def __init__(self, name, location, type,emp_name,emp_id):
        super().__init__(name,location,type)
        self.Employee_Name = emp_name
        self.Employee_id = emp_id
class developer(Employee):
    def __init__(self, name, location, type, emp_name, emp_id,prog_lang):
        super().__init__(name, location, type,emp_name,emp_id)
        self.prog_lang = prog_lang
dev1 = developer('phonix', 'delhi', 'IT', 'ram', 'p101', 'php')
emp1 = Employee('yahoo', 'pune', 'IT', 'rama', 'p103')
cmp1 = company('google', 'US', 'IT')

def main():
    print(isinstance(emp1, company))
    print(isinstance(emp1, developer))
    print(isinstance(dev1, company))
    print(isinstance(dev1, Employee))
    print(isinstance(dev1, developer))
    print(issubclass(developer, company))
    print(issubclass(developer, Employee))
    print(issubclass(Employee, company))
    print(issubclass(Employee, developer))
    print(dev1.Company_Name, dev1.Employee_Name,dev1.prog_lang)
    print(emp1.Company_Name, emp1.Employee_id)
    print(cmp1.Company_type, cmp1.Company_Location)

if __name__ == "__main__":
    main()


