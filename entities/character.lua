Character = class('Character')

local function _updateCharacterMovement(self,dt)

	angledVelocity = self.speed / math.sqrt(2)
	if love.keyboard.isDown('left','a') and not love.keyboard.isDown('right','d') then
		if love.keyboard.isDown('up','w') and not love.keyboard.isDown('down','s') then
			-- Going left and up.
			self.x = self.x - angledVelocity*dt
			self.y = self.y - angledVelocity*dt
		elseif love.keyboard.isDown('down','s') and not love.keyboard.isDown('up','w') then
			-- Going left and down.
			self.x = self.x - angledVelocity*dt
			self.y = self.y + angledVelocity*dt
		else
			-- Going left.
			self.x = self.x - self.speed*dt
		end
	elseif love.keyboard.isDown('right','d') and not love.keyboard.isDown('left','a') then
		if love.keyboard.isDown('up','w') and not love.keyboard.isDown('down','s') then
			-- Going right and up.
			self.x = self.x + angledVelocity*dt
			self.y = self.y - angledVelocity*dt
		elseif love.keyboard.isDown('down','s') and not love.keyboard.isDown('up','w') then
			-- Going right and down.
			self.x = self.x +	angledVelocity*dt
			self.y = self.y + angledVelocity*dt
		else
			-- Going right.
			self.x = self.x + self.speed*dt
		end
	else
		if love.keyboard.isDown('up','w') and not love.keyboard.isDown('down','s') then
			-- Going up.
			self.y = self.y - self.speed*dt
		elseif love.keyboard.isDown('down','s') and not love.keyboard.isDown('up','w') then
			-- Going down.
			self.y = self.y + self.speed*dt
		end
	end
	if self.x < 0 then self.x = love.graphics.getWidth() end
	if self.x > love.graphics.getWidth() then self.x = 0 end
	if self.y < 0 then self.y = love.graphics.getHeight() end
	if self.y > love.graphics.getHeight() then self.y = 0 end

end

local function _updateCharacterAngle(self)

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	self.angle = math.atan((mouseY - self.y)/(mouseX - self.x))
	if mouseX < self.x then
		self.angle = self.angle + math.pi
	end

end

function Character:initialize(imgHead,imgRArm,imgLArm,imgWeapon,imgOffhand, x, y, angle, speed, sizeRatio)
	self.bodyParts = {}
	Head = BodyPart:new(love.graphics.newImage(imgHead),75,75,0,1,1,75,75)
	RArm = BodyPart:new(love.graphics.newImage(imgRArm),75,75,0,1,1,75,75)
	LArm = BodyPart:new(love.graphics.newImage(imgLArm),75,75,0,1,1,75,75)
	Weapon = BodyPart:new(love.graphics.newImage(imgWeapon),75,75,0,1,1,75,75)
	Offhand = BodyPart:new(love.graphics.newImage(imgOffhand),75,75,0,1,1,75,75)
	table.insert(self.bodyParts,Weapon)
	table.insert(self.bodyParts,Offhand)
	table.insert(self.bodyParts,RArm)
	table.insert(self.bodyParts,LArm)
	table.insert(self.bodyParts,Head)
	
	self.x = x or love.graphics.getWidth()/2
	self.y = y or love.graphics.getHeight()/2
	self.angle = angle or 0
	self.speed = speed or 400
	self.size = sizeRatio or 1
	
	print('DrawComponents is '..tostring(#self.bodyParts)..' items large.')
	
	self.inAttackAnimation = false
	self.attackAnimation = {}
	
	self.canvas = love.graphics.newCanvas(150, 150)
end

function Character:update(dt)
	-- Handle moving the circle around.
	_updateCharacterMovement(self,dt)
	
	-- Update angle.
	_updateCharacterAngle(self)
	
end

function Character:mousepressed(x,y,button)



end

function Character:draw()
	
	self.canvas:renderTo(function()
	
		for i,bodyPart in ipairs(self.bodyParts) do
			bodyPart:draw()
		end
	
		-- love.graphics.draw(self.imgWeapon.img,self.imgWeapon.x,self.imgWeapon.y,self.imgWeapon.angle,self.imgWeapon.scaleX,self.imgWeapon.scaleY,self.imgWeapon.centerX,self.imgWeapon.scaleY)
		-- love.graphics.draw(self.imgOffhand.img,75,75,0,1,1,75,75)
		-- love.graphics.draw(self.imgRArm.img,75,75,0,1,1,75,75)
		-- love.graphics.draw(self.imgLArm.img,75,75,0,1,1,75,75)
		-- love.graphics.draw(self.imgHead.img,75,75,0,1,1,75,75)
	end)
	
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas, self.x, self.y, self.angle + math.pi/2, self.size, self.size,self.canvas:getWidth()/2,self.canvas:getHeight()/2)
	
end
