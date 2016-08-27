Character = class('Character')

local function _updateCharacterMovement(self,dt)
	self.isMoving = false
	angledVelocity = self.speed / math.sqrt(2)
	straightVelocity = self.speed
	
	if self.isSprinting then
		angledVelocity = angledVelocity * self.sprintingModifier
		straightVelocity = straightVelocity * self.sprintingModifier
	end
	
	if love.keyboard.isDown('left','a') and not love.keyboard.isDown('right','d') then
		self.isMoving = true
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
			self.x = self.x - straightVelocity*dt
		end
	elseif love.keyboard.isDown('right','d') and not love.keyboard.isDown('left','a') then
		self.isMoving = true
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
			self.x = self.x + straightVelocity*dt
		end
	else
		if love.keyboard.isDown('up','w') and not love.keyboard.isDown('down','s') then
			-- Going up.
			self.isMoving = true
			self.y = self.y - straightVelocity*dt
		elseif love.keyboard.isDown('down','s') and not love.keyboard.isDown('up','w') then
			-- Going down.
			self.isMoving = true
			self.y = self.y + straightVelocity*dt
		end
	end
	if self.x < self.width/2 then self.x = self.width/2 end
	if self.x > game.playingField.width - self.width/2 then self.x = game.playingField.width - self.width/2 end
	if self.y < self.height/2 then self.y = self.height/2 end
	if self.y > game.playingField.height - self.height/2 then self.y = game.playingField.height - self.height/2 end

end

local function _updateCharacterAngle(self)

	mouseX = love.mouse.getX() + game.playingField.screenX
	mouseY = love.mouse.getY() + game.playingField.screenY
	self.angle = math.atan((mouseY - self.y)/(mouseX - self.x))
	if mouseX < self.x then
		self.angle = self.angle + math.pi
	end

end

local function _updateLegAnimation(self,dt)

	-- Start new animation.
	if self.isMoving and not self.isAnimatingLegs then
		self.isAnimatingLegs = true
		print('starting new animation')
	end
	
	if self.isAnimatingLegs then self.currentLegAnimationTime = self.currentLegAnimationTime + dt end
		
	-- Stop animating.
	if not self.isMoving and self.isAnimatingLegs then
		if self.currentLegAnimationTime > self.timePerLegAnimationFrame then
			self.isAnimatingLegs = false
			print('stopping animation here')
		end
	end
	
	-- Update animation timer.
	if self.isAnimatingLegs then
		
		if self.currentLegAnimationTime > self.timePerLegAnimationFrame then
		self.currentLegAnimationImg = self.currentLegAnimationImg + 1
		if self.currentLegAnimationImg == 9 then self.currentLegAnimationImg = 1 end
			-- if self.currentLegAnimationImg == 1 then -- Starting at both legs in
				-- self.currentLegAnimationImg = 2
				-- print('starting frame 2')
			-- elseif self.currentLegAnimationImg == 2 then -- Half legs 1
				-- self.currentLegAnimationImg = 3
				-- print('starting frame 3')
			-- elseif self.currentLegAnimationImg == 3 then -- Full legs 1
				-- self.currentLegAnimationImg = 4
				-- print('starting frame 4')
			-- elseif self.currentLegAnimationImg == 4 then -- Half legs 1
				-- self.currentLegAnimationImg = 4
				-- print('starting frame 4')
			-- elseif self.currentLegAnimationImg == 5 then -- legs 0
				-- self.currentLegAnimationImg = 4
				-- print('starting frame 4')
			-- elseif self.currentLegAnimationImg == 6 then -- half legs 2
				-- self.currentLegAnimationImg = 1
				-- print('starting frame 1')
			-- elseif self.currentLegAnimationImg == 7 then -- full legs 2
				-- self.currentLegAnimationImg = 1
				-- print('starting frame 1')
			-- elseif self.currentLegAnimationImg == 8 then -- half legs 2
				-- self.currentLegAnimationImg = 1
				-- print('starting frame 1')
			-- elseif self.currentLegAnimationImg == 9 then -- legs 0
				-- self.currentLegAnimationImg = 1
				-- print('starting frame 1')
			-- end
			self.currentLegAnimationTime = 0
		end
		
	end

end

function Character:initialize(imgHead,imgRArm,imgLArm,imgWeapon,imgOffhand,imgLegs1,imgLegs2, x, y, angle, speed, sizeRatio)
	-- Set up the always visible body parts.
	self.bodyParts = {}
	Head = BodyPart:new('head',love.graphics.newImage(imgHead),75,75,0,1,1,75,75)
	RArm = BodyPart:new('rightArm',love.graphics.newImage(imgRArm),75,75,0,1,1,75,75)
	LArm = BodyPart:new('leftArm',love.graphics.newImage(imgLArm),75,75,0,1,1,75,75)
	Weapon = BodyPart:new('mainHand',love.graphics.newImage(imgWeapon),75,75,0,1,1,75,75)
	Offhand = BodyPart:new('offhand',love.graphics.newImage(imgOffhand),75,75,0,1,1,75,75)
	table.insert(self.bodyParts,Weapon) -- This order is specific for image layering.
	table.insert(self.bodyParts,Offhand)
	table.insert(self.bodyParts,RArm)
	table.insert(self.bodyParts,LArm)
	table.insert(self.bodyParts,Head)
		
	-- Set up animations for moving.
	self.animatedLegs1 = BodyPart:new('legs1',love.graphics.newImage(imgLegs1),75,75,0,1,1,75,75)
	self.animatedLegs2 = BodyPart:new('legs2',love.graphics.newImage(imgLegs2),75,75,0,1,1,75,75)
	self.timePerLegAnimationFrame = 0.1
	self.currentLegAnimationTime = 0
	self.currentLegAnimationImg = 1
	self.isAnimatingLegs = false
	self.isMoving = false
	
	-- Set up entire character values.
	self.x = x or love.graphics.getWidth()/2
	self.y = y or love.graphics.getHeight()/2
	self.angle = angle or 0
	self.speed = speed or 400
	self.size = sizeRatio or 1
	self.width = Head.img:getWidth()*self.size
	self.height = Head.img:getHeight()*self.size
	self.isSprinting = false
	self.sprintingModifier = 1.75
	
	print('DrawComponents is '..tostring(#self.bodyParts)..' items large.')
	
	self.inAttackAnimation = false
	self.attackAnimation = {}
	
	self.canvas = love.graphics.newCanvas(self.width/self.size, self.height/self.size)
end

function Character:update(dt)
	-- Handle moving the circle around.
	_updateCharacterMovement(self,dt)
	
	-- Update leg animation.
	_updateLegAnimation(self,dt)
	
	-- Update angle.
	_updateCharacterAngle(self)
	
end

function Character:mousepressed(x,y,button)



end

function Character:draw()
	
	if game.playingField:onScreenArea(self.x-self.width/2,self.y-self.height/2,self.width,self.height) then
		self.canvas:renderTo(function()
			love.graphics.clear()
		
			-- Draw legs here so they're below everything.
			if self.isAnimatingLegs then
				if self.currentLegAnimationImg == 2 or self.currentLegAnimationImg == 4 then
					self.animatedLegs1.scaleY = 0.8
					self.animatedLegs1:draw()
				elseif self.currentLegAnimationImg == 3 then
					self.animatedLegs1.scaleY = 1
					self.animatedLegs1:draw()
				elseif self.currentLegAnimationImg == 6 or self.currentLegAnimationImg == 8 then
					self.animatedLegs2.scaleY = 0.8
					self.animatedLegs2:draw()
				elseif self.currentLegAnimationImg == 7 then
					self.animatedLegs2.scaleY = 1
					self.animatedLegs2:draw()
				end
			end
			
			-- Draw always visible body parts here.
			for i,bodyPart in ipairs(self.bodyParts) do
				bodyPart:draw()
			end
		
		end)
		
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.canvas, self.x - game.playingField.screenX, self.y - game.playingField.screenY, self.angle + math.pi/2, self.size, self.size,self.canvas:getWidth()/2,self.canvas:getHeight()/2)
	end
end
