#Simple Tool 
#Convert Framebuffer to the dividual screen just available on Blue platform
#Maker:Cui,Yingyun
#

#Celar previous grabage
rm -rf *.png

adb pull /dev/graphics/fb0 frame_buffer 
echo "-> Pull frame buffer dump Done"

split -b 3768320 frame_buffer
echo "-> Spilit Done"

convert -depth 8 -size "736x1280" rgba:xaa -channel BGR -separate -combine FB-1.png
convert -depth 8 -size "736x1280" rgba:xab -channel BGR -separate -combine FB-2.png
convert -depth 8 -size "736x1280" rgba:xac -channel BGR -separate -combine FB-3.png
echo "-> Convert Done"

#Clear
rm -rf frame_buffer
mv xaa FB-1.raw
mv xab FB-2.raw
mv xac FB-3.raw
echo "-> Clear Done"
