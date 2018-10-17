#!/bin/sh

source ~/.bash_profile
export mac=`pwd | sed 's/\// /g' | awk '{print $2}'`
export HOME_DIR="/Users/"$mac"/MIT_TOMO/TOMO_P/"


# Things to change go here!
#USA
export lon_min="-130"
export lon_max="-50"
export lat_min="20"
export lat_max="60"


gmt set FONT 					= Helvetica
gmt set FONT_TITLE				= 12p
gmt set FONT_LABEL				= 10p
gmt set FONT_ANNOT_PRIMARY		= 12p
gmt set FONT_ANNOT_SECONDARY	= 12p
gmt set PS_MEDIA 				= 650x450
gmt set PS_PAGE_ORIENTATION 	= PORTRAIT
gmt set PS_LINE_CAP 			= round
gmt set FORMAT_DATE_IN 			= yyyymmdd


DEMDIR="/Users/"$mac"/lib/"
#Input for geological boundaries and kimberlite pipes

# WHITMEYER and KARLSTROM (2007) provinces

W_K_2500_p="$DEMDIR/LINES_POLY/2500-535Ma_p.txt"
W_K_2500_l="$DEMDIR/LINES_POLY/2500-535Ma_l.txt"
W_K_1960_p="$DEMDIR/LINES_POLY/1960-535Ma_p.txt"
W_K_1960_l="$DEMDIR/LINES_POLY/1960-535Ma_l.txt"
W_K_1920_p="$DEMDIR/LINES_POLY/1920-535Ma_p.txt"
W_K_1920_l="$DEMDIR/LINES_POLY/1920-535Ma_l.txt"
W_K_1860_p="$DEMDIR/LINES_POLY/1860-535Ma_p.txt"
W_K_1860_l="$DEMDIR/LINES_POLY/1860-535Ma_l.txt"
W_K_1840_p="$DEMDIR/LINES_POLY/1840-535Ma_p.txt"
W_K_1840_l="$DEMDIR/LINES_POLY/1840-535Ma_l.txt"
W_K_1820_p="$DEMDIR/LINES_POLY/1820-535Ma_p.txt"
W_K_1820_l="$DEMDIR/LINES_POLY/1820-535Ma_l.txt"
W_K_1800_p="$DEMDIR/LINES_POLY/1800-535Ma_p.txt"
W_K_1800_l="$DEMDIR/LINES_POLY/1800-535Ma_l.txt"
W_K_1760_p="$DEMDIR/LINES_POLY/1760-535Ma_p.txt"
W_K_1760_l="$DEMDIR/LINES_POLY/1760-535Ma_l.txt"
W_K_1690_p="$DEMDIR/LINES_POLY/1690-535Ma_p.txt"
W_K_1690_l="$DEMDIR/LINES_POLY/1690-535Ma_l.txt"
W_K_1550_p="$DEMDIR/LINES_POLY/1550-535Ma_p.txt"
W_K_1550_l="$DEMDIR/LINES_POLY/1550-535Ma_l.txt"
W_K_1480_p="$DEMDIR/LINES_POLY/1480-535Ma_p.txt"
W_K_1300_p="$DEMDIR/LINES_POLY/1300-535Ma_p.txt"
W_K_1300_in="$DEMDIR/LINES_POLY/1300-535Ma_inliers.txt"
W_K_1300_l="$DEMDIR/LINES_POLY/1300-535Ma_l.txt"
W_K_1250_p="$DEMDIR/LINES_POLY/1250-535Ma_p.txt"
W_K_1200_p="$DEMDIR/LINES_POLY/1200-535Ma_p.txt"
W_K_1200_l="$DEMDIR/LINES_POLY/1200-535Ma_l.txt"
W_K_780_l="$DEMDIR/LINES_POLY/780-535Ma_l.txt"
W_K_620_l="$DEMDIR/LINES_POLY/620-535Ma_l.txt"
W_K_550_p="$DEMDIR/LINES_POLY/550-535Ma_p.txt"
W_K_550_l="$DEMDIR/LINES_POLY/550-535Ma_l.txt"





lat0=`echo "$lat_min + (($lat_max - $lat_min)/2)" | bc`
lon0=`echo "$lon_min + (($lon_max - $lon_min)/2)" | bc`
lat1=`echo "$lat0 - 5" | bc`
lat2=`echo "$lat0 + 5" | bc`
scale="18c"
# scale="12c"

lon_min_w=`echo "$lon_min - 2" | bc`
lon_max_w=`echo "$lon_max + 2" | bc`
lat_min_w=`echo "$lat_min - 2" | bc`
lat_max_w=`echo "$lat_max + 2" | bc`

RANGE="-R$lon_min/$lon_max/$lat_min/$lat_max"
RANGE_WIDE="-R$lon_min_w/$lon_max_w/$lat_min_w/$lat_max_w"
# PROJ="-JM$scale"
PROJ="-JL$lon0/$lat0/$lat1/$lat2/$scale"
BGN="$RANGE $PROJ -K"
MID="$RANGE $PROJ -O -K"
END="$RANGE $PROJ -O"

psfile="USA_sed_thick.ps"
pdffile="USA_sed_thick.pdf"


gmt psbasemap $BGN -Bpxa10f5 -Bpya10f5 -BWSne -P > $psfile # +t"WHITMEYER + KARLSTROM (2007)"


CPT_1=temp.cpt
# gmt xyz2grd $RANGE_WIDE -I1/1/1 ./SEDIMENT/sedmap.gmt -Gsedmap.grd

gmt triangulate sedmap.gmt $RANGE_WIDE -I0.1 -Gsedmap.grd > sedmap.ijk
gmt makecpt -Ccool -Qo -I -T0.001/100/1 > $CPT_1
# gmt grdclip sedmap.grd -Gsedmap_clip.grd -Sa0.1/1 -Sb0.1/NaN -V
# gmt grdimage sedmap_clip.grd $MID -C$CPT_1 >> $psfile
gmt grdimage sedmap.grd $MID -C$CPT_1 >> $psfile


# CPT_PAL="-Cno_green -I" # "-Cseis -Z" # "-Crainbow -Z -I" #  "-Cpolar -Z -I" #
# gmt grd2cpt sedmap.grd -T= $CPT_PAL $RANGE > $CPT_1


# WHITMEYER and KARLSTROM (2007)

gmt psxy $W_K_2500_l $MID -W1,black >> $psfile
gmt psxy $W_K_1960_l $MID -W1,black >> $psfile
gmt psxy $W_K_1920_l $MID -W1,black >> $psfile
gmt psxy $W_K_1840_l $MID -W1,black >> $psfile
gmt psxy $W_K_1820_l $MID -W1,black >> $psfile
gmt psxy $W_K_1800_l $MID -W1,black >> $psfile
gmt psxy $W_K_1760_l $MID -W1,black >> $psfile # Faults and outlines for Yavapai etc.
gmt psxy $W_K_1690_l $MID -W1,black >> $psfile
gmt psxy $W_K_1550_l $MID -W1,black >> $psfile
gmt psxy $W_K_1300_l $MID -W3,blue >> $psfile

# gmt psxy $W_K_1200_p $MID -W1,black >> $psfile # MCR
gmt psxy $W_K_780_l $MID -W1,red >> $psfile
gmt psxy $W_K_620_l $MID -W3,red >> $psfile
gmt psxy $W_K_550_l $MID -W3,red >> $psfile


# gmt surface hawaii_5x5.xyg -R198/208/18/25 -I5m -Ghawaii_grd.nc -T0.25 -C0.1 -Vl
gmt pscoast $MID -A10000 -Dl -W1 -N1 -Swhite >> $psfile

# Labels: x, y[, font, angle, justify], text

echo -90 52 Helvetica 0 LB SUP > text
echo -75.5 43 Helvetica 50 LB GRN >> text
echo -83 32 Helvetica 45 LB APP >> text
echo -97 36 Helvetica 40 LB MAZ >> text
echo -90 35 Helvetica 45 LB GR >> text
echo -105 37 Helvetica 35 LB YAV >> text
echo -105.3 49 Helvetica 0 LB THO >> text
# echo -103.5 52 Helvetica 55 LB Sask >> text
echo -94 32 Helvetica 0 LB OUA >> text
echo -109 44 Helvetica 0 LB WYO. >> text
# echo -91 45 Helvetica 0 LB Pen. >> text
echo -125 27 Helvetica 0 LB Pacific Ocean >> text
echo -70 30 Helvetica 0 LB Atlantic Ocean >> text

gmt pstext text $MID -F+f10,black+f+a+j -TO -Gwhite >> $psfile

gmt psscale $END -C$CPT_1 -Q -D3.5i/5i/8c/0.55ch -Ba0.01f0.01+l"Sediment thickness (km)" >> $psfile


ps2pdf $psfile $pdffile
open $pdffile

rm gmt* temp.cpt text
rm $psfile
