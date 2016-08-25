game = {}

-- Game TODO:
--      * Add identity and title to conf.lua

function game:enter()
    self.mainCharacter = Character:new('assets/img/character.png')
end

function game:update(dt)
	self.mainCharacter:update(dt)
	
	if DEBUG then
		debugTimer = debugTimer + dt
		if debugTimer > 1 then
			debugTimer = 0
			print('Angle: '..tostring(self.mainCharacter.angle))
		end
	end
end

function game:keypressed(key, code)

end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
	
	self.mainCharacter:draw()
	
	love.graphics.draw(cursorImg,love.mouse.getX(),love.mouse.getY(),0,1,1,cursorImg:getWidth()/2,cursorImg:getHeight()/2)
end