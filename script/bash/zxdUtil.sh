#common util, fonctuion only

__TEST=false

startsWithUpperCase()
{
    #check if word starts with upper letter
    #clone reposity if it doesn't exists
    if [ $# -lt 1 ] ; then
        echo "wrong arg number, excepted format is startsWithUpperCase word"
        exit 1	
    fi
    word=$1
    if [[ ${word} =~ ^[A-Z].* ]]; then
        return 0
    fi

    return 1
}

repoClone()
{
    #clone reposity if it doesn't exists
    if [ $# -lt 3 ] ; then
        echo "wrong arg number, excepted format is repoClone vsc remote local"
        exit 1
    fi

    vcs=$1
    remote=$2
    local=$3

    if [[ $vcs != git && $vcs != hg ]]; then
        echo vcs must be git or hg, found "${vcs}"
        exit 0
    fi

    if [[ -d $local ]]; then
        echo $local already exists
        return 0
    fi

    mkdir -p $local
    $vcs clone $remote $local
    return $?
}

buildSymbolicLink()
{
    #build symbolic if it doesn't exits
    if [ $# -lt 2 ] ; then
        echo "wrong arg number, excepted format is buildSymbolicLink file link"
        exit 1
    fi

    fileName=$1
    linkName=$2

    if [[ -h $linkName && `readlink $linkName` == $fileName ]]; then
        #do nothing if it already exists
        echo symbolic link ${linkName}'->'${fileName} exists
        return 0
    fi

    echo build symbolic link : ${linkName}'->'${fileName}
    ln -s $fileName $linkName
    return $?
}

getFileLineNumber()
{
    #get linenumber in a file by regex, exit 1 if not found
    if [ $# -lt 2 ] ; then
        echo wrong arg numbers, it should be getFileLineNumber pattern file
        exit 1
    fi
    pattern=$1
    file=$2

    number=`grep -n $pattern $file | cut -d : -f 1`
    reInteger='^[0-9]+$'
    if [[ $number =~ $reInteger ]]; then
        echo $number
    else
        echo can not found $pattern in $file
        exit 1
    fi
}

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

    #--------------------------------------------------------------------------------
    echo test startsWithUpperCase

    startsWithUpperCase abc
    if [[ $? -eq 0 ]]; then
        echo "$__TEST_INDENT" error, abc does not starts with upper case
    fi
    startsWithUpperCase 123
    if [[ $? -eq 0 ]]; then
        echo "$__TEST_INDENT" error, 123 does not starts with upper case
    fi
    startsWithUpperCase Abc
    if  [[ $? -eq 0 ]]; then
        echo "$__TEST_INDENT" error, Abc starts with upper case
    fi

    echo test finished

fi
