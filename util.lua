local util = {}

util.drawFilledRectangle = function(left,top,width,height, r,g,b)
    love.graphics.setColor(r,g,b,100)
    love.graphics.rectangle('fill', left,top,width,height)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle('line', left,top,width,height)
end

util.HSL = function (h, s, l)
    if s == 0 then return l,l,l end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end
    return math.ceil((r+m)*256),math.ceil((g+m)*256),math.ceil((b+m)*256)
end

return util