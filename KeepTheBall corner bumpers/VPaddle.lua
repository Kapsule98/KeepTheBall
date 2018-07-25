--[[ Kapil Bedekar 2018
    Author: Kapil Bedekar
    14-07-2018
]]

VPaddle = Class{}


function VPaddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function VPaddle:update(dt)

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)

    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end



function VPaddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end