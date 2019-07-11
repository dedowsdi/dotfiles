#common util, fonctuion only, all functions in this fill should not be called with sudo(sodo can not inherite function)

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

    #--------------------------------------------------------------------------------quoting
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
