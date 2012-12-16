#!/bin/bash

# Usage: ./pdf126.sh file.pdf NO_PAGES [NO_SLIDES_LAST_PAGE]

dens=300
filename=$(basename "$1")
filename="${filename%.*}"

for i in $(seq 1 $2)
do
    page=${filename}_${i}

    pdfseparate -f $i -l $i $1 ${page}.pdf

    convert -density $dens ${page}.pdf ${page}.png
    rm ${page}.pdf

    convert ${page}.png -gravity South -chop 0x100 ${page}.png

    convert -crop 2x3@ +repage ${page}.png ${page}%d.png
    rm ${page}.png

    if [ -n "$3" ] && [ "$i" -eq "$2" ]
    then
        jend=$(($3-1))
    else
        jend=5
    fi

    for j in $(seq 0 $jend)
    do
        convert ${page}${j}.png -fuzz 2% -trim +repage ${page}${j}.png
        mogrify -format pdf -- ${page}${j}.png
    done

    for j in $(seq 0 5)
    do
        rm ${page}${j}.png
    done

    if [ "$jend" -eq "0" ]
    then
        cp ${page}$jend.pdf ${page}.pdf
    else
        pdfunite ${page}*.pdf ${page}.pdf
    fi

    for j in $(seq 0 $jend)
    do
        rm ${page}${j}.pdf
    done
done
