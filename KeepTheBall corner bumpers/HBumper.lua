--[[ Kapil Bedekar 2018
    Author: Kapil Bedekar
    14-07-2018
]]

HBumper = Class{}

function HBumper:init(x,y)
self.x=x
self.y=y
self.width = 30
self.height = 5
end

function HBumper:Render()
love.graphics.rectangle('fill',self.x,self.y,30,5)
end