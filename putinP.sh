#!/bin/sh

source ~/.profile
mac=`pwd | sed 's/\// /g' | awk '{print $2}'`

if (( $(echo "$# 1" | awk '{print ($1 < $2)}') ));

then
	echo "A script to insert a P pick from ak135 tables.  Labelled as T1 in sac files"
	echo "Should be operated in directory containing all events (eg within MCCC_COMPLETE)"
	echo "USEAGE:  putinP.sh <PHASE>"
	echo "EXAMPLE:  putinP.sh P"
	echo
	exit
	exit
fi
rm SUMMARY.txt

for dir in ??????????????; do
cd $dir
echo $dir

phase=` grep -i PHS *x | awk '{print $2}'| awk '{print substr($0,1,3)}' `
# taup_setsac -ph "$phase"-1 -mod ak135 -evdpkm *.?HZ

sactosac -m *.?HZ
sactosac -f *.?HZ
saclst stel gcarc baz az evdp t1 t0 evla evlo stla stlo o dist f *.?HZ > saclst.out
sactosac -m *.?HZ


awk '{print $1}' saclst.out | sed 's/\./ /g' | sed 's/\_/ /g' | awk '{print $3}' > KSTNM.OUT
awk '{print $2}' saclst.out > STEL.OUT
awk '{print $3}' saclst.out > GCARC.OUT
awk '{print $4}' saclst.out > BAZ.OUT
awk '{print $5}' saclst.out > AZ.OUT
awk '{print $6}' saclst.out > EVDP.OUT
awk '{print $7}' saclst.out > T1.OUT
awk '{print $8}' saclst.out > T0.OUT
awk '{print $9}' saclst.out > EVLA.OUT
awk '{print $10}' saclst.out > EVLO.OUT
awk '{print $11}' saclst.out > STLA.OUT
awk '{print $12}' saclst.out > STLO.OUT
awk '{print $13}' saclst.out > O.OUT
awk '{print $14}' saclst.out > DIST.OUT

rm saclst.out


paste KSTNM.OUT STEL.OUT GCARC.OUT BAZ.OUT AZ.OUT EVDP.OUT T1.OUT T0.OUT EVLA.OUT > CONCAT1.OUT
paste EVLO.OUT STLA.OUT STLO.OUT O.OUT > CONCAT2.OUT
paste CONCAT1.OUT CONCAT2.OUT > CONCAT3.OUT
#
# #Now need to do a station elevation correction before the means are computed

awk '{print $1, $2, $3, $4, $5, $6, $7-$13, $8-$13-($2/3000), $9, $10, $11, $12, $13}' CONCAT3.OUT > CONCAT.OUT

# KSTNM, STEL, GCARC, BAZ, AZ, EVDP, IASP91 TT, Pick time with elev correction, evla, evlo, stla, stlo, OMARKER.


# Next line computes the mean of the picks
awk '{print $8}' CONCAT.OUT > MEAN.OUT
mn=`gmt gmtmath  -S -T MEAN.OUT MEAN =`

#Next line computes the mean of the IASP times
awk '{print $7}' CONCAT.OUT > IASP_MEAN.OUT
mn2=`gmt gmtmath  -S -T IASP_MEAN.OUT MEAN =`

#Next line computes the mean of the delays (mean of iasp - pick)
awk '{print $8-$7}' CONCAT.OUT > MEAN3.OUT
mn3=`gmt gmtmath  -S -T MEAN3.OUT MEAN =`

echo
echo "$mn is the pick mean, $mn2 is the IASP91 mean, $mn3 is the mean relative delay"
echo

# cat SUMMARY.txt >> ../SUMMARY.txt
awk '{print directory, $1, $2, $3, $4, $5, $6, $7, $8, $8-$7, ($8-$7)-mean3, $9, $10, $11, $12, ($8-mean-$7+mean2)}' directory=$dir mean=$mn  mean2=$mn2 mean3=$mn3 CONCAT.OUT >> ../SUMMARY.txt
\rm *.OUT
cd ..
done

# directoryname, KSTNM, STEL, GCARC, BAZ, AZ, EVDP, AK135 TT, Pick time with elev correction, delay time, relative delay time, evla, evlo, stla, stlo, relative delay time.
