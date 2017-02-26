from PIL import Image,ImageFilter
import math
def pixel2LatLon(x,y,level,orix, oriy):
    mapSize = 256*2**level
    x = float(x)/mapSize-0.5
    x+=orix
    y = 0.5-float(y)/mapSize
    y+=oriy

    lat = 90-360*math.atan(math.exp(-y*2*math.pi))/math.pi
    lon = 360 * x

    return (lat, lon)

pixel = open("pixel.txt","r")
lines = pixel.readline()
pixelsOrigins = lines.split("\n")

