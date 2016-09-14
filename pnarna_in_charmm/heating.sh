#!/bin/bash
#Heating protocol for PNA-RNA

PDB="pnarna_min.pdb"
Tmin="30"
Tmax="300"
Tincr="10"
ConsF="50.0"
stperT=100000 #200 ps #500=1ps
stOutput=$((stperT / 10))
Cons1="PROA:2:11"
Cons2="N01B:13:22"
BoxX="63.3650016784668"
BoxY="64.7229995727539"
BoxZ="77.66200256347656"

basicpar="openmm,lang,langfbeta=1,dyneqfrq=0,param=36,pstream=toppar_pna_MJ_caps_MF.str,nodeoxy,terlist=PROA:ACE:CTN,langupd=0,dynoutfrq="$stOutput",echeck="$stOutput
basicpar2="cutoff=10,cutnb=12,cuton=9"

PATH=$PATH:/home/users/mifeig/mmtsb/perl:/home/users/mifeig/bin
export CHARMMEXEC="/home/users/mifeig/c41b1/bin/charmm"
export LD_LIBRARY_PATH="/home/users/mifeig/c41b1/lib:/home/users/mifeig/openmm/lib:$LD_LIBRARY_PATH"
export CHARMMDATA="/home/users/mifeig/mmtsb/data/charmm"
export OPENMM_PRECISION="mixed"
export OPENMM_DEVICE="0"
export OPENMM_CUDA_COMPILER="/usr/local/cuda-7.5/bin/nvcc"
export OPENMM_PLATFORM="CUDA"

Cons1=$Cons1"_"$ConsF
Cons2=$Cons2"_"$ConsF

for T in $(eval echo "{$Tmin..$Tmax..$Tincr}")
	do
		echo "Calculations on "$PDB" temperature set to "$T" K" 
		mdCHARMM.pl -par $basicpar -par $basicpar2 -par boxx=$BoxX,boxy=$BoxY,boxz=$BoxZ,dynitemp=$T,dyntemp=$T,dynsteps=$stperT -log $T.log -cons self $Cons1=$Cons2 -trajout $T.dcd -final $T.pdb $PDB 
		PDB=$T.pdb
	done

