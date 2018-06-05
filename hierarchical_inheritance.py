class vehicles:
    def __init__(self,color,engine,transmission,model):
        self.color = color
        self.engine = engine
        self.transmission = transmission
        self.model = model
class car(vehicles):
    def __init__(self,color,engine,transmission,model,no_of_car):
        super().__init__(color,engine,transmission,model)
        self.type_of_car = no_of_car
class bus(vehicles):
    def __init__(self, color, engine, transmission, model,size_of_bus):
        super().__init__(color, engine, transmission, model)
        self.bus_size = size_of_bus
class truck(vehicles):
    def __init__(self, color, engine, transmission, model, no_of_tyres):
        super().__init__(color, engine, transmission, model)
        self.no_of_tyres = no_of_tyres
a = car('red', '1300CC', 'electric', 'New', '10' )
b = bus('yellow', '13000CC', 'automobile', 'smart', 'big')
c = truck('green', '15000CC', 'automobile', 'smarty', '14')
print(a.engine)
print(a.type_of_car)
print(b.engine)
print("Size of bus is ",b.bus_size)
print(c.transmission)
print(c.no_of_tyres)