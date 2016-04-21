#used to rename sequence of files
#used as rename base suffix total startIndex offset 

if [ ! $# = 5 ] ; then
    echo "wrong arg number, excepted format is seqrename base suffix total startIndex offset"
else
    # get variables
    baseName=$1
    suffix=$2
    total=$3
    startIndex=$4
    offset=$5

    echo rename $total files with base name: $baseName,  suffix: $suffix, start at $startIndex, offset to $offset

    if [[ $offset -gt 0  ]]; then
        #from last to first for positive offset
        seqs=$(seq $((total-1)) -1 0)
    else 
        #from first to last for negative offset
        seqs=$(seq 0 $((total-1)))
    fi

    for index in $seqs; do
        src="$baseName$((startIndex+index)).$suffix"
        dest="$baseName$((startIndex+index+offset)).$suffix"
        echo "rename from $src to $dest"		
        mv $src $dest
    done

fi
