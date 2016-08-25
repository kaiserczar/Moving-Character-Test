TileGenerator = class('TileGenerator')

local function _copyImageDataToImageData(copyFrom, copyTo, x, y)
	
	for curX = 0,copyFrom:getWidth()-1 do
		for curY = 0,copyFrom:getHeight()-1 do
			r, g, b, a = copyFrom:getPixel(curX,curY)
			if x+curX >= 0 and x+curX < copyTo:getWidth() then
				if y+curY >=0 and y+curY < copyTo:getHeight() then
					--if not a==0 then
						copyTo:setPixel(x+curX, y+curY, r, g, b, a)
					--end
				end
			end
		end
	end
	
end

function TileGenerator:initialize()
	self.tileBaseSize = 32
	
	self.grassBladeImgData = love.graphics.newImage('assets/img/grassBlade.png'):getData()
	
	self:generateNewGrassTile()
end

function TileGenerator:update(dt)

end

function TileGenerator:mousepressed(x,y,button)

end

function TileGenerator:draw()
	
end

function TileGenerator:generateNewGrassTile(width, height, numBlades--[[, colorBase]])
	width = width or self.tileBaseSize
	height = height or self.tileBaseSize
	numBlades = numBlades or math.random(3,10)
	colorBase = colorBase or {r=85,g=137,b=33}--{r=102,g=165,b=39}
	
	tileImgData = love.image.newImageData(width,height)
	
	-- Create the base color.
	for y = 0,height-1 do -- Images still start at 0, although arrays start at 1.
		for x = 0,width-1 do
			tileImgData:setPixel(x, y, colorBase.r, colorBase.g, colorBase.b, 255)
			--if DEBUG and (y==0 or y==height-1 or x==0 or x==width-1) then tileImgData:setPixel(x, y, 255, colorBase.g, colorBase.b, 255) end
		end
	end
	
	-- Generate grass blades.
	bladeWidth = self.grassBladeImgData:getWidth()
	bladeHeight = self.grassBladeImgData:getHeight()
	for i = 1,numBlades do
		x = math.random(0,width-1)
		y = math.random(0,height-1)
		
		--_copyImageDataToImageData(self.grassBladeImgData, tileImgData, x, y)
		tileImgData:paste(self.grassBladeImgData,x,y,0,0,self.grassBladeImgData:getWidth(),self.grassBladeImgData:getHeight())
		
		if x > width - bladeWidth then -- Must also draw on other side to tile correctly.
			if y > height - bladeHeight then
				tileImgData:paste(self.grassBladeImgData,x-width,y-height,0,0,self.grassBladeImgData:getWidth(),self.grassBladeImgData:getHeight())
			else
				tileImgData:paste(self.grassBladeImgData,x-width,y,0,0,self.grassBladeImgData:getWidth(),self.grassBladeImgData:getHeight())
			end
		else
			if y > height - bladeHeight then
				tileImgData:paste(self.grassBladeImgData,x,y-height,0,0,self.grassBladeImgData:getWidth(),self.grassBladeImgData:getHeight())
			end
		end
		
	end
	
	self.grassTile = love.graphics.newImage(tileImgData)
end

