game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:enter()
	assetFolder = 'assets/img/'
    self.mainCharacter = Character:new(assetFolder..'helmet.png',assetFolder..'rightArm.png',assetFolder..'leftArm.png',assetFolder..'sword.png',assetFolder..'shield.png',love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,350,0.5)
	
	self.tileGen = TileGenerator:new()
	self.tileGen:generateNewGrassTile(100,100,math.random(30,50))
end

function game:update(dt)
	self.mainCharacter:update(dt)
	
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
	if key == 'r' then
		self.tileGen:generateNewGrassTile(100,100,math.random(30,50))
	end
end

function game:mousepressed(x, y, mbutton)
	self.mainCharacter:mousepressed(x,y,mbutton)
end

function game:draw()
	-- Draw background.
	tileSize = self.tileGen.grassTile:getWidth()
	for x = 0,love.graphics.getWidth()-1,self.tileGen.grassTile:getWidth() do
		for y = 0, love.graphics.getHeight()-1, self.tileGen.grassTile:getHeight() do
			love.graphics.draw(self.tileGen.grassTile,x,y)
		end
	end
	
	self.mainCharacter:draw()
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
	
end