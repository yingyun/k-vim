#Sync OpenGrok project
#2013-5-31 Initial Version
#Cui, Yingyun


echo "Kernel3.4->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/M65-kernel-3.4/trunk
svn update
echo "Mesa demo->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/mesa_demos_git
git pull
echo "Mesa drm->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/mesa_drm_git
git pull
echo "Mesa->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/mesa_git
git pull
echo "Mesa GLUT->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/mesa_glut_git
git pull
echo "cocos2d-X->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/cocos2d-x_git
git pull
echo "FlyMe 3->"
#OpenGrok has problem while indexing svn log in Flyme3 code
cd /home/yingyun/code/SourceRefer/GfxAndEngine/
mv FlyMe3 ../JellyBean-4.2.1/trunk
cd /home/yingyun/code/SourceRefer/JellyBean-4.2.1/trunk
svn update
cd /home/yingyun/code/SourceRefer/GfxAndEngine/
mv ../JellyBean-4.2.1/trunk FlyMe3


echo "Updatint OpenGrok->"
cd /home/yingyun/code/SourceRefer/GfxAndEngine/
/home/yingyun/code/othrProjectSourceCode/opengrok-0.11.1/bin/OpenGrok index ./
