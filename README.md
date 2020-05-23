# eventR

## Overview: 
This script takes in any number of file names as arguments and takes in the date/time at the head of each line as a separate event. It performs basic plotting and analysis on these data points, after which it presents the results in an aesthetically pleasing format.<br><br>
<img src="https://i.imgur.com/80YVGbD.png"
     alt="Density Graph Overall"
     width="200" 
     height="200"/> <img src="https://i.imgur.com/BVDaD07.png"
     alt="Density Graph by Input"
     width="200" 
     height="200"/> <img src="https://i.imgur.com/fvPECAM.png"
     alt="Jitter Plot"
     width="200" 
     height="200"/><br>
### Features
 - Overall event-time density over all input files given
 - Event-time density with respect to the input file the data is from
 - Events grouped by the file they're from

## Getting Started ##
### Prerequisites

R (3.6)
```
blas (openblas-lapack-git, openblas-git, blas-tmg, flexiblas, blas-git, openblas-lapack-static, atlas-lapack, openblas-lapack, openblas-cblas-git, openblas)
bzip2 (bzip2-git, bzip2-rustify-git, bzip2-with-lbzip2-symlinks)
desktop-file-utils (desktop-file-utils-git)
gcc-libs (gcc-libs-multilib-x32, fastgcc, gcc-libs-git, gcc-libs-multilib-git)
lapack (openblas-lapack-git, lapack-tmg, flexiblas, lapack-git, openblas-lapack-static, atlas-lapack, openblas-lapack)
libjpeg (libjpeg-droppatch, mozjpeg-git, mozjpeg, libjpeg-turbo)
libpng (libpng-git)
libtiff (libtiff-git)
libxmu
libxt
ncurses (ncurses-git, ncurses-nohex)
pango (pango-ubuntu, pango-git)
pcre (pcre-svn)
perl (perl-git)
readline (readline-athame-git)
unzip (unzip-natspec, unzip-iconv)
xz (xz-git, xz-static-git)
zip (zip-natspec)
zlib (zlib-static, zlib-git, zlib-asm, zlib-ng-git)
gcc-fortran (gcc-fortran-multilib-x32, gcc-fortran-git, gcc-fortran-multilib-git) (make)
tk (tk85) (make)
```

Libraries
```
ggplot2
dplyr
stringr
```
#### Input File Format
The standard format of `date()` output is what's expected at front, and anything else can come afterwards as long as it remains on an unbroken line.
```
DOW MONTH DOM HH:MM:SS TZ YR ...
```
An example line would look like `Sat May 23 05:19:39 UTC 2020 ...`

## Usage
Basic calling of the script with file names as arguments suffices in most cases.
`Rscript event.R inputFile1 inputFile2 inputFile3 ...`