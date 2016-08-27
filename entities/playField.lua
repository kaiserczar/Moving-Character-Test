PlayField = class('PlayField')

local function _scrollScreen(self,dt)

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	
	if mouseX < self.screenScrollLeftLoc then
		self.screenX = self.screenX - dt * self.screenScrollSpeed * (self.screenScrollLeftLoc - mouseX) / self.screenScrollLeftLoc
	elseif mouseX > self.screenScrollRightLoc then
		self.screenX = self.screenX + dt * self.screenScrollSpeed * (mouseX - self.screenScrollRightLoc) / (love.graphics.getWidth() - self.screenScrollRightLoc)
	end
	
	if mouseY < self.screenScrollUpLoc then
		self.screenY = self.screenY - dt * self.screenScrollSpeed * (self.screenScrollUpLoc - mouseY) / self.screenScrollUpLoc
	elseif mouseY > self.screenScrollDownLoc then
		self.screenY = self.screenY + dt * self.screenScrollSpeed * (mouseY - self.screenScrollDownLoc) / (love.graphics.getHeight() - self.screenScrollDownLoc)
	end

	if self.screenX < 0 then
		self.screenX = 0
	elseif self.screenX > self.width - love.graphics.getWidth() then
		self.screenX = self.width - love.graphics.getWidth()
	end
	if self.screenY < 0 then
		self.screenY = 0
	elseif self.screenY > self.height - love.graphics.getHeight() then
		self.screenY = self.height - love.graphics.getHeight()
	end
	
end

function PlayField:initialize(width, height)

	self.width = width or 4000
	self.height = height or 4000

	self.screenX = 0
	self.screenY = 0
	
	self.screenScrollSpeed = 800
	self.screenScrollLeftLoc = love.graphics.getWidth()*0.2
	self.screenScrollRightLoc = love.graphics.getWidth()*0.8
	self.screenScrollUpLoc = love.graphics.getHeight()*0.2
	self.screenScrollDownLoc = love.graphics.getHeight()*0.8
	
	self.tileGen = TileGenerator:new()
	self.tileGen:generateNewGrassTile(100,100,math.random(300,500))
	
	if DEBUG then self.debugTimer = 0 end
	
end

function PlayField:update(dt)

	_scrollScreen(self,dt)
	
	if love.keyboard.isDown('space') then
		self:centerAt(game.mainCharacter.x+game.mainCharacter.width/2, game.mainCharacter.y+game.mainCharacter.height/2)
	end
	
	if DEBUG then
		self.debugTimer = self.debugTimer + dt
		if self.debugTimer > 1 then
			print('Screen zero at: ('..tostring(self.screenX)..','..tostring(self.screenY)..')')
			print('Screen center at: ('..tostring(self.screenX + love.graphics.getWidth()/2)..','..tostring(self.screenY + love.graphics.getHeight()/2)..')')
			self.debugTimer = 0
		end
	end

end

function PlayField:draw()

	tileSizeX = self.tileGen.grassTile:getWidth()
	tileSizeY = self.tileGen.grassTile:getHeight()
	
	xFirstTile = -(self.screenX % tileSizeX)
	yFirstTile = -(self.screenY % tileSizeY)
	xLastTile = xFirstTile + love.graphics.getWidth()
	yLastTile = yFirstTile + love.graphics.getHeight()
	
	if love.graphics.getWidth() > self.width then
		xFirstTile = (love.graphics.getWidth() - self.width)/2
		xLastTile = xFirstTile + self.width - tileSizeX
	end
	if love.graphics.getHeight() > self.height then
		yFirstTile = (love.graphics.getHeight() - self.height)/2
		yLastTile = yFirstTile + self.height - tileSizeY
	end
	
	for x = xFirstTile, xLastTile+tileSizeX, tileSizeX do
		for y = yFirstTile, yLastTile+tileSizeY, tileSizeY do
			love.graphics.draw(self.tileGen.grassTile,x,y)
		end
	end
	
	if DEBUG then
		love.graphics.print('Corner: ('..tostring(self.screenX)..','..tostring(self.screenY)..')',0,0)
		love.graphics.print('Mouse:  ('..tostring(love.mouse.getX()+self.screenX)..','..tostring(love.mouse.getY()+self.screenY)..')',0,30)
	end
end

function PlayField:centerAt(centerX, centerY)

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	self.screenX = centerX - screenWidth/2
	self.screenY = centerY - screenHeight/2
	
	if self.screenX < 0 then
		self.screenX = 0
	elseif self.screenX > self.width - love.graphics.getWidth() then
		self.screenX = self.width - love.graphics.getWidth()
	end
	if self.screenY < 0 then
		self.screenY = 0
	elseif self.screenY > self.height - love.graphics.getHeight() then
		self.screenY = self.height - love.graphics.getHeight()
	end
end

function PlayField:onScreenPixel(x,y)

	return x > self.screenX and x < self.screenX + love.graphics.getWidth() and y > self.screenY and y < self.screenY + love.graphics.getHeight()

end

function PlayField:onScreenArea(x,y,width,height)

	return x+width > self.screenX and x < self.screenX + love.graphics.getWidth() and y+height > self.screenY and y < self.screenY + love.graphics.getHeight()

end