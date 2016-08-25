BodyPart = class('BodyPart')

function BodyPart:initialize(image,x,y,angle,scaleX,scaleY,centerX,centerY)
	
	self.img = image
	self.x = x
	self.y = y
	self.angle = angle
	self.scaleX = scaleX
	self.scaleY = scaleY
	self.centerX = centerX
	self.centerY = centerY
	
end

function BodyPart:update(dt)

	

end

function BodyPart:mousepressed(x,y,button)



end

function BodyPart:draw()

	love.graphics.draw(self.img, self.x, self.y, self.angle, self.scaleX, self.scaleY, self.centerX, self.centerY)
	
end