LIBS = \
-lOIS\
-lboost_system\
-lOgreMain\
-lOgreOverlay\
-lMyGUIEngine\
-lMyGUI.OgrePlatform

INCLUDES = \
-Iinclude\
-Isrc\
-I/usr/include/OIS\
-I/usr/local/include/OGRE\
-I/usr/local/include/OGRE/Overlay\
-I/usr/local/include/MYGUI\
-I/usr/local/source/mygui/mygui/Common


SRCDIR = src/
SRCS = src/*.cpp
CMP := clang++

OBJDIR = obj/
OBJS =\
${OBJDIR}BaseApplication.o\
${OBJDIR}TutorialApplication.o 

UBS = ub/*.cpp
CFLAGS = -Wall -std=c++11 -g

#--------------------------------------------------------------------
ogre: ${OBJS} 
	${CPL}  ${CFLAGS} -o $@ ${OBJS} ${INCLUDES} ${LIBS} 

#--------------------------------------------------------------------
#implicit obj
${OBJDIR}%.o : ${SRCDIR}%.cpp
	${CPL}  ${CFLAGS} -o $@ -c $< ${INCLUDES} ${LIBS} 
#--------------------------------------------------------------------
#build all obj
.PHONY : obj
obj : ${OBJS}
#--------------------------------------------------------------------
.PHONY : clean
clean: 
	rm -f ogre ubmygui ${OBJS}
