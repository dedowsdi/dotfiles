#common util, fonctuion only, all functions in this fill should not be called with sudo(sodo can not inherite function)

__TEST=false

appInstall()
{
    #install app if it's not nod found
    if [ $# -lt 1 ] ; then
        echo wrong arg numbers, it should be appInstall appName
        exit 1
    fi
    appName=$1
    dse=`dpkg -l $appName | tail -1 | cut -d ' ' -f 1`
    if  [[ $dse == ii ]] ; then
        echo $appName already installed
    else
        echo installing $appName
        apt -y install $appName
    fi
}

#get index of string 
strIndex() 
{
    x="${1%%$2*}"
    [[ $x = $1 ]] && echo -1 || echo ${#x}
}

#test, set__TEST to true to begin test

if ${__TEST} ; then

    __TEST_INDENT="    "

    #--------------------------------------------------------------------------------quoting
    echo test startsWithUpperCase

    echo test finished

fi
