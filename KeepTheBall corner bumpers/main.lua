--[[ Kapil Bedekar 2018
	Author: Kapil Bedekar
	14-07-2018
]]


push = require 'push'
Class = require 'class'
require 'HPaddle'
require 'VPaddle'
require 'Ball'
require 'VBumper'
require 'HBumper'
--[[real resolution]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[virtual resolution]]
VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 300


PADDLE_SPEED = 200

function love.load()
 
    love.graphics.setDefaultFilter('nearest', 'nearest')

    
    love.window.setTitle('Keep the ball')

  
    math.randomseed(os.time())

 	--[[fonts initialise]]
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

 	--[[sound table]]
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['HBD_Background'] = love.audio.newSource('sounds/Happy_Birthday.mp3','static'),
        ['Blue'] = love.audio.newSource('sounds/Blue.mp3','static')
    }
    --[[sounds['Blue']:setLooping(true)
    sounds['Blue']:play()]]

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    --[[left paddle]]
    player1 = VPaddle(10, 30, 5, 30)
    --[[right paddle]]
    player2 = VPaddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 30)
    --[[top paddle]]
    player3 = HPaddle(VIRTUAL_WIDTH/2-10,10,30,5)
    --[[bottom paddle]]
    player4 = HPaddle(VIRTUAL_WIDTH/2+10,VIRTUAL_HEIGHT-10,30,5)
    --[[ball]]
  	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  	--[[HBumpers]]
  	HB1 = HBumper(VIRTUAL_WIDTH-30,0)
  	HB2 = HBumper(0,0)
  	HB3 = HBumper(0,VIRTUAL_HEIGHT-5)
  	HB4 = HBumper(VIRTUAL_WIDTH-30,VIRTUAL_HEIGHT-5)
  	--[[VBumpers]]
  	VB1 = VBumper(VIRTUAL_WIDTH-5,0)
  	VB2 = VBumper(0,0)
  	VB3 = VBumper(0,VIRTUAL_HEIGHT-30)
  	VB4 = VBumper(VIRTUAL_WIDTH-5,VIRTUAL_HEIGHT-30)

	Score =0
    Life =3
    servingPlayer = 1
    winningPlayer = 0
	gameState = 'start'
end



function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    if gameState == 'serve' then
     
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
            Score = Score +1
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
			
			if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
            Score = Score+1
        end
        if ball:collides(player3) then
        	ball.dy = -ball.dy*1.03
        	ball.y = player3.y+5
           
            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10, 150)
            end


            sounds['paddle_hit']:play()
            Score = Score +1
        end

        if ball:collides(player4) then
        	ball.dy = -ball.dy*1.03
        	ball.y = player4.y-4
           
            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10, 150)
            end


            sounds['paddle_hit']:play()
            Score = Score +1
        end        
      
        --[[ collision code for bumpers ]]
       
        if ball:collides(HB1) then
        	ball.dy = -ball.dy
        	ball.y = HB1.y+5
        	sounds['wall_hit']:play()
        end

        if ball:collides(HB2) then
			ball.dy = -ball.dy
        	ball.y = HB2.y+5
        	sounds['wall_hit']:play()
        end

        if ball:collides(HB3) then
        	ball.dy = -ball.dy
        	ball.y = HB3.y-4
        	sounds['wall_hit']:play()
        end

        if ball:collides(HB4) then
        	ball.dy = -ball.dy*1.03
        	ball.y = HB4.y-4
        	sounds['wall_hit']:play()
        end

        if ball:collides(VB1) then
        	 ball.dx = -ball.dx 
            ball.x = VB1.x - 4
            sounds['wall_hit']:play()
        end

        if ball:collides(VB4) then
        	 ball.dx = -ball.dx 
            ball.x = VB4.x - 4
            sounds['wall_hit']:play()
        end

        if ball:collides(VB2) then
        	 ball.dx = -ball.dx
            ball.x = VB2.x + 5
            sounds['wall_hit']:play()
        end

        if ball:collides(VB3) then
        	 ball.dx = -ball.dx
            ball.x = VB3.x + 5
            sounds['wall_hit']:play()
        end


        if ball.y < 0 then
            servingPlayer = 1
         	Life = Life-1
            sounds['score']:play()


            if Life==0 then
                
                gameState = 'done'
            else
                gameState = 'serve'
           
                ball:reset()
            end
        end

        if ball.y>VIRTUAL_HEIGHT then
            servingPlayer = 2
            Life = Life-1
            sounds['score']:play()

            if Life==0 then
            
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end

        end


        if ball.x < 0 then
            servingPlayer = 1
         	Life = Life-1
            sounds['score']:play()


            if Life==0 then
                
                gameState = 'done'
            else
                gameState = 'serve'
           
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            Life = Life-1
            sounds['score']:play()

            if Life==0 then
            
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    --
    --[[left paddle movement]]
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --[[top paddle movement]]
    if love.keyboard.isDown('a') then
        player3.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('d') then
        player3.dx = PADDLE_SPEED
    else
        player3.dx = 0
    end

    --[[right paddle movement]]
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    --[[bottom paddle movement]]
    if love.keyboard.isDown('left') then
        player4.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        player4.dx = PADDLE_SPEED
    else
        player4.dx = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
    player3:update(dt)
    player4:update(dt)
end

--[[esc-quit  enter-start]]
function love.keypressed(key)
    if key == 'escape' then
    
        love.event.quit()

   elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'

            	

        elseif gameState == 'done' then
         
            gameState = 'serve'
            Life =3;
            ball:reset()
            Score=0
            
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end


function love.draw()
   
    push:start()

    

    if gameState == 'start' then
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Keep the ball', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to start', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
     
        love.graphics.setFont(smallFont)
        
        love.graphics.printf('Press Enter to serve', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
  
    elseif gameState == 'done' then
    
        love.graphics.setFont(largeFont)
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')
    end

 
    displayScore()
    --[[corner bumpers]]
    RenderCornerBumpers()
    
    player1:render()
    player2:render()
    player3:render()
    player4:render()
    ball:render()

  
    displayFPS()

   
    push:finish()
end


function displayScore()
   
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(Score), VIRTUAL_WIDTH / 2 ,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Life),50,VIRTUAL_WIDTH-50)
    
end


function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end

function RenderCornerBumpers()
	HB1:Render()
	HB2:Render()
	HB3:Render()
	HB4:Render()
	VB1:Render()
	VB2:Render()
	VB3:Render()
	VB4:Render()	

end
