import pathlib
import math
from PIL import Image
import xml.etree.ElementTree as ET

# run 'python -m pip install Pillow' to install PIL
# usage: python textureDownsize.py 'downsizing factor/divisor' 'path to xml file' 'path to image file'
# Note that both the width and height are downsized (downsize = 2 returns an image 1/4 of the original size)

downsizestr = input('Downsizing Factor: ')
pnginput = input('Path to PNG: ')
xmlinput = input('Path to XML: ')

downsize = int(downsizestr)
png = 'C:\Users\MarPol\Desktop\FridayNightModdin\Funkin-android-master-ver6\dools' + pnginput
xml = 'C:\Users\MarPol\Desktop\FridayNightModdin\Funkin-android-master-ver6\dools' + xmlinput

if (downsize % 2 != 0 or downsize == 0):
    raise ValueError("Downsizing factor should be a multiple of 2 for Integer Scaling.")

xmlPath = pathlib.Path() / xml
imgPath = pathlib.Path() / png
tree = ET.parse(xmlPath)
root = tree.getroot()

newImage = Image.open(imgPath)
width, height = newImage.size

# resample=0 for nearest neighbour, 1 for lanczos, 2 bilinear, 3 cubic, 4 box, 5 hamming
# default uses bilinear cause anything more for sprites is wasted space
newImage = newImage.resize((int(width/downsize), int(height/downsize)), resample=2)
newImage.save(imgPath)

def scale(value):
    return str(math.floor(int(value)/downsize))

for subtext in root.findall('SubTexture'):
    subtext.set('x', scale(subtext.get('x')))
    subtext.set('y', scale(subtext.get('y')))
    subtext.set('width', scale(subtext.get('width')))
    subtext.set('height', scale(subtext.get('height')))

    if (subtext.get('frameWidth') is not None):
        subtext.set('frameWidth', scale(subtext.get('frameWidth')))

    if (subtext.get('frameHeight') is not None):
        subtext.set('frameHeight', scale(subtext.get('frameHeight')))

tree.write(xmlPath, encoding='utf-8', xml_declaration=True) 

print('DONE!')
