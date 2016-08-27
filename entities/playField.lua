PlayField = class('PlayField')

local function _scrollScreen(self,dt)

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	
	if mouseX < self.screenScrollLeftLoc then
		self.screenX = self.screenX - dt * self.screenScrollSpeed * (self.screenScrollLeftLoc - mouseX) / self.screenScrollLeftLoc
	elseif mouseX > self.screenScrollRightLoc then
		self.screenX = self.screenX + dt * self.screenScrollSpeed * (mouseX - self.screenScrollRightLoc) / (self.viewWidth - self.screenScrollRightLoc)
	end
	
	if mouseY < self.screenScrollUpLoc then
		self.screenY = self.screenY - dt * self.screenScrollSpeed * (self.screenScrollUpLoc - mouseY) / self.screenScrollUpLoc
	elseif mouseY > self.screenScrollDownLoc then
		self.screenY = self.screenY + dt * self.screenScrollSpeed * (mouseY - self.screenScrollDownLoc) / (self.viewHeight - self.screenScrollDownLoc)
	end

	if self.screenX < 0 then
		self.screenX = 0
	elseif self.screenX > self.width - self.viewWidth then
		self.screenX = self.width - self.viewWidth 
	end
	if self.screenY < 0 then
		self.screenY = 0
	elseif self.screenY > self.height - self.viewHeight then
		self.screenY = self.height - self.viewHeight
	end
	
end

function PlayField:initialize(width, height, viewWidth, viewHeight, anchorX, anchorY)

	print('width = '..tostring(width))
	print('height = '..tostring(height))
	print('vWidth = '..tostring(viewWidth))
	print('vHeight = '..tostring(viewHeight))

	self.width = width or 4000
	self.height = height or 4000
	self.viewWidth = viewWidth or love.graphics.getWidth()
	self.viewHeight = viewHeight or love.graphics.getHeight()
	self.anchorX = anchorX or 0
	self.anchorY = anchorY or 0
	self.canvas = love.graphics.newCanvas(self.viewWidth,self.viewHeight)
	
	self.screenX = 0
	self.screenY = 0
	
	self.screenScrollSpeed = 800
	self.screenScrollLeftLoc = self.viewWidth*0.2
	self.screenScrollRightLoc = self.viewWidth*0.8
	self.screenScrollUpLoc = self.viewHeight*0.2
	self.screenScrollDownLoc = self.viewHeight*0.8
	
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
			print('Screen center at: ('..tostring(self.screenX + self.viewWidth/2)..','..tostring(self.screenY + self.viewHeight/2)..')')
			self.debugTimer = 0
		end
	end

end

function PlayField:draw()

	self.canvas:renderTo(function()
		tileSizeX = self.tileGen.grassTile:getWidth()
		tileSizeY = self.tileGen.grassTile:getHeight()
		
		xFirstTile = -(self.screenX % tileSizeX)
		yFirstTile = -(self.screenY % tileSizeY)
		xLastTile = xFirstTile + self.viewWidth
		yLastTile = yFirstTile + self.viewHeight
		
		if self.viewWidth > self.width then
			xFirstTile = (self.viewWidth - self.width)/2
			xLastTile = xFirstTile + self.width - tileSizeX
		end
		if self.viewHeight > self.height then
			yFirstTile = (self.viewHeight - self.height)/2
			yLastTile = yFirstTile + self.height - tileSizeY
		end
		
		for x = xFirstTile, xLastTile+tileSizeX, tileSizeX do
			for y = yFirstTile, yLastTile+tileSizeY, tileSizeY do
				love.graphics.draw(self.tileGen.grassTile,x,y)
			end
		end
		
		game.mainCharacter:draw()
	end)
	
	love.graphics.draw(self.canvas, self.anchorX, self.anchorY)
	
	if DEBUG then
		love.graphics.print('Corner: ('..tostring(self.screenX)..','..tostring(self.screenY)..')',0,0)
		love.graphics.print('Mouse:  ('..tostring(love.mouse.getX()+self.screenX)..','..tostring(love.mouse.getY()+self.screenY)..')',0,30)
		love.graphics.print('Player: ('..tostring(game.mainCharacter.x)..','..tostring(game.mainCharacter.y)..')',0,60)
	end
end

function PlayField:centerAt(centerX, centerY)

	screenWidth = self.viewWidth
	screenHeight = self.viewHeight

	self.screenX = centerX - screenWidth/2
	self.screenY = centerY - screenHeight/2
	
	if self.screenX < 0 then
		self.screenX = 0
	elseif self.screenX > self.width - self.viewWidth then
		self.screenX = self.width - self.viewWidth
	end
	if self.screenY < 0 then
		self.screenY = 0
	elseif self.screenY > self.height - self.viewHeight then
		self.screenY = self.height - self.viewHeight
	end
end

function PlayField:onScreenPixel(x,y)

	return x > self.screenX and x < self.screenX + self.viewWidth and y > self.screenY and y < self.screenY + self.viewHeight

end

function PlayField:onScreenArea(x,y,width,height)

	return x+width > self.screenX and x < self.screenX + self.viewWidth and y+height > self.screenY and y < self.screenY + self.viewHeight

end