a = 99

if(a == 100) then
	print('a == 100')
elseif (a < 100) then
	print('a < 100')
else
	print('a > 100')
end


local Person = {}

function Person:new(name,age)
	local obj = {name = name,age = age}
	local _number = niu

	setmetatable(obj,self)
	self.__index = self

	function obj:sayHello()
	print("Hello,my Name is" .. obj.name)
	end

	function obj:getNumber()
		return _number
	end

	function obj:setNumber(number)
		_number = number
		print("New Number" .. _number)

	end

	return obj
end



local testPerson = Person:new("Eligos",20)
print("创建对象..")
testPerson:sayHello()
print("Age", testPerson.age)

testPerson:setNumber(19179325580)

print("Number: " .. testPerson:getNumber())
