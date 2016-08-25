Character = class('Character')

function Character:initialize(imagePath, x, y, angle, speed)
	self.img = love.graphics.newImage(imagePath)
	self.x = x or love.graphics.getWidth()/2
	self.y = y or love.graphics.getHeight()/2
	self.angle = angle or 0
	self.speed = speed or 400
	
end

function Character:update(dt)
	-- Handle moving the circle around.
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
	
	-- Update angle.
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	self.angle = math.atan((mouseY - self.y)/(mouseX - self.x))
	if mouseX < self.x then
		self.angle = self.angle + math.pi
	end
end

function Character:draw()
	
	love.graphics.draw(self.img,self.x,self.y,self.angle + math.pi/2,1,1,self.img:getWidth()/2,self.img:getHeight()/2)
	
end