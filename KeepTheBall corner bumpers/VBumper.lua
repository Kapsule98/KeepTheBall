--[[ Kapil Bedekar 2018
    Author: Kapil Bedekar
    14-07-2018
]]

VBumper = Class{}

function VBumper:init(x,y)
self.x=x
self.y=y
self.width = 5
self.height = 30
end

function VBumper:Render()
love.graphics.rectangle('fill',self.x,self.y,5,30)
end