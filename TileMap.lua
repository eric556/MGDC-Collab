Class = require "libs.middleclass.middleClass"

local TileMap = Class("TileMap")

function TileMap:initialize(filepath)
    self.Map = require filepath
    self.width = Map.width
    self.height = Map.height
    self.tileWidth = Map.tileWidth
    self.tileHeight = Map.tileHeight
    self.image = Map.tilesets.image
    self.image.width = Map.tilesets.imagewidth
    self.image.height = Map.tilesets.imageHeight
    self.image.tileCount = Map.tilesets.tilecount
    self.layers = Map.layers
    
    for x=0, self.image.width/self.tileWidth do
        for y=0, self.image.height/self.tileHeight do 
            
        end
    end
        
    for i in ipairs(self.layers) do
        if self.layers[i].properties["collision"] == true then
            self.collisionLayer = self.layers[i].data
        else
            self.layerData[#self.layerData + 1] = self.layers[i].data
        end
    end
    
    
    
end