game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:enter()
	assetFolder = 'assets/img/'
    self.mainCharacter = Character:new(assetFolder..'helmet.png',assetFolder..'rightArm.png',assetFolder..'leftArm.png',assetFolder..'sword.png',assetFolder..'shield.png',assetFolder..'legs1.png',assetFolder..'legs2.png',100,100,0,300,0.5)
	
	love.mouse.setX(love.graphics.getWidth()/2)
	love.mouse.setY(love.graphics.getHeight()/2)
	
	self.playingField = PlayField:new()
end

function game:update(dt)
	self.mainCharacter:update(dt)
	
	self.playingField:update(dt)
	
	if DEBUG then
		debugTimer = debugTimer + dt
		if debugTimer > 1 then
			--debug.debug()
			debugTimer = 0
			print('Angle: '..tostring(self.mainCharacter.angle))
		end
	end
end

function game:keypressed(key, code)
	if key == 'r' and DEBUG then
		self.playingField.tileGen:generateNewGrassTile(100,100,math.random(300,500))
	end
	
	if key == 'lshift' then
		self.mainCharacter.isSprinting = true
	end
end

function game:keyreleased(key, code)
	if key == 'lshift' then
		self.mainCharacter.isSprinting = false
	end
end

function game:mousepressed(x, y, mbutton)
	self.mainCharacter:mousepressed(x,y,mbutton)
end

function game:draw()
	-- Draw background.
	self.playingField:draw()
	
	self.mainCharacter:draw()
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
	
end