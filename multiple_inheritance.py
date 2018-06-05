class company:
    def __init__(self, cmp_name, cmp_location):
        self.Company_Name = cmp_name
        self.Company_location = cmp_location


class Employee:
    def __init__(self, emp_name, emp_id):
        self.Employee_Name = emp_name
        self.Employee_id = emp_id


class developer(Employee, company):
    def __init__(self, cmp_name, cmp_location, emp_name, emp_id, prog_lang):
        Employee().__init__(self, emp_name, emp_id)
        company().__init__(self, cmp_name, cmp_location)
        self.prog_lang = prog_lang


dev1 = developer('phonix', 'UK', 'ram', 'p101', 'php')
print(dev1.Employee_Name)
