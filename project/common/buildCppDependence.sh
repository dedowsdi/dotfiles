#!/bin/bash

#------------------------------------------------------------------------------
#this block is project specific

#ogrehome=/usr/local/source/ogre/ogre2.1
#myguihome=/usr/local/source/mygui/mygui_ogre2.1

##lib address, symbolic link name ...
#libs=(\
	#${ogrehome}/OgreMain Ogremain\
	#${ogrehome}/Components/Hlms Hlms\
	#${ogrehome}/Plugins/ParticleFX ParticleFX\
	#${myguihome}/MyGUIEngine MyGUI\
	#)

##special local includes need to be added to .ycm_extra_conf
#localIncludes=(\
     #test/include\
	#ogre/include\
	#ogre/test/include\
	#ogre/demo/mygui/include\
#)

#------------------------------------------------------------------------------
#utils
getFileLineNumber()
{
	#get linenumber in a file by regex
	if [ $# -lt 2 ] ; then
		return 1
	fi
	nl -ba $1  | grep -P $2 | awk '{print $1}'
}
#------------------------------------------------------------------------------
#real work flow starts here

if [[ ! -d "thirdlib" ]]; then
	#build thirdlib if it doesn't exists
	echo create thirdlib dir ; mkdir thirdlib
fi
cd thirdlib && rm -rf *

reInteger='^[0-9]+$'
ycmFilePath="../.ycm_extra_conf.py" 
#clearn .ycm_extra_conf
incBeg=`getFileLineNumber $ycmFilePath "'/usr/local/include',\s*$"`
if ! [[ $incBeg =~ $reInteger ]]; then
	echo unknow state, incBeg is $incBeg; exit 1
fi
incBeg=$((incBeg+1))
incEnd=`getFileLineNumber $ycmFilePath "^\s*\d*\s*]\s*$"`
if ! [[ $incEnd =~ $reInteger ]]; then
	echo unknow state, incEnd is $incEnd; exit 1
fi
incEnd=$((incEnd-1))
if [[ incEnd -ge incBeg ]]; then
	#clean original includes
	echo clean .ycm_extra_conf.py from $incBeg to $incEnd
	sed -i "${incBeg},${incEnd}d" $ycmFilePath
fi

if [[ -v libs ]]; then
	for (( i = 0; i < ${#libs[*]}; i++ )); do
		if [[ 0 -eq $((i%2)) ]]; then
			#build symbolic link in thirdlib
			lib=${libs[i]}
			linkname=${libs[$[i+1]]}
			echo add lib "$lib", link as "thirdlib/$linkname", include at ycm
			#update include in .ycm_extra+conf
			ln -s $lib $linkname
			sed -i "${incBeg}i '-isystem',\n'thirdlib/$linkname',"  $ycmFilePath
		fi	
		index=$[index+1]
	done
fi

if [[ -v localIncludes ]]; then
	for (( i = 0; i < ${#localIncludes[*]}; i++ )); do
		#add local includes in ycm
		include=${localIncludes[i]}
		echo include $include at ycm
		#update include in .ycm_extra+conf
		sed -i "${incBeg}i '-isystem',\n'$include',"  $ycmFilePath
	done
fi

#build ctags for third lib
buildctags . 
exit $?
