local bump       = require 'bump'
local bump_debug = require 'bump_debug'

if love.getVersion == nil or love.getVersion() < 11 then
  local origSetColor = love.graphics.setColor
  love.graphics.setColor = function (r, g, b, a)
    return origSetColor(
      math.floor(r * 256),
      math.floor(g * 256),
      math.floor(b * 256),
      a ~= nil and math.floor(a * 256) or nil
    )
  end
end

local cols_len = 0 -- how many collisions are happening

-- World creation
local world = bump.newWorld()


-- helper function
local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,0.25)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

local function drawCircle(el, r,g,b)
  love.graphics.setColor(r,g,b,0.25)
  love.graphics.circle("fill", el.x, el.y, el.radius)
end


-- Player functions
local player     = { x =  50, y = 250, w = 22, h = 70, speed = 250}
local player_two = { x = 730, y = 250, w = 22, h = 70, speed = 250}
local ball       = { x = 400, y = 300, w = 10, h = 10, speed =   0}

local function updatePlayer(dt)
  local speed = player.speed
  local spd = player_two.speed

  -- movement
  local dx, dy = 0, 0    -- green player
  local dx1, dy1 = 0, 0  --  red  player
  if love.keyboard.isDown('down') then
    dy = speed * dt
  elseif love.keyboard.isDown('up') then
    dy = -speed * dt
  end

  
  if love.keyboard.isDown('s') then
    dy1 = spd * dt
  elseif love.keyboard.isDown('w') then
    dy1 = -spd * dt
  end
  

  if dx1 ~= 0 or dy1 ~= 0 or dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx1, player.y + dy1)
    player_two.x, player_two.y, cols, cols_len = world:move(player_two, player_two.x + dx, player_two.y + dy)
    for i=1, cols_len do
      local col = cols[i]
    end
  end
end

local function drawPlayer()
  drawBox(player, 0, 1, 0)
  drawBox(player_two, 2, 0, 0)
  drawBox(ball, 0, 5, 3)
end

-- Block functions

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 1,0,0)
  end
end


-- Main LÖVE functions

function love.load()
  world:add(player, player.x, player.y, player.w, player.h)
  world:add(player_two, player_two.x, player_two.y, player_two.w, player_two.h)
  world:add(ball, ball.x, ball.y, ball.w, ball.h)

  addBlock(0,0,800,1)
  addBlock(-10,32,10,684)
  addBlock(800,32,1,664)
  addBlock(0,600,800,1)
end

function love.update(dt)
  cols_len = 0
  updatePlayer(dt)
end

function love.draw()
  drawBlocks()
  drawPlayer()
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
end