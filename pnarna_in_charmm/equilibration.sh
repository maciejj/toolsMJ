#!/bin/bash
#Equilibration protocol for PNA-RNA
#Constrains loosing
#Heating was with 50 kcal/mol. Here start with 25 kcal/mol ind NVT, then switch to NPT and do X rounds with cons lower by half.

export LC_NUMERIC="en_US.UTF-8" #formating of floating nubers. Now commas.

numRounds="7"
PDB="300.pdb"
T="300"
ConsF="25.0"
stperCF=500000 #1ns   #500=1ps
stOutput=$((stperCF / 10))
Cons1="PROA:2:11"
Cons2="N01B:13:22"
BoxX="63.3650016784668"
BoxY="64.7229995727539"
BoxZ="77.66200256347656"

basicpar="openmm,lang,langfbeta=1,dyneqfrq=0,param=36,pstream=toppar_pna_MJ_caps_MF.str,nodeoxy,terlist=PROA:ACE:CTN,langupd=0,dynoutfrq="$stOutput",echeck="$stOutput 
basicpar2="cutoff=10,cutnb=12,cuton=9"
basicpar3="dynens=NPT,dynpress=1"

PATH=$PATH:/home/users/mifeig/mmtsb/perl:/home/users/mifeig/bin
export CHARMMEXEC="/home/users/mifeig/c41b1/bin/charmm"
export LD_LIBRARY_PATH="/home/users/mifeig/c41b1/lib:/home/users/mifeig/openmm/lib:$LD_LIBRARY_PATH"
export CHARMMDATA="/home/users/mifeig/mmtsb/data/charmm"
export OPENMM_PRECISION="mixed"
export OPENMM_DEVICE="0"
export OPENMM_CUDA_COMPILER="/usr/local/cuda-7.5/bin/nvcc"
export OPENMM_PLATFORM="CUDA"

#RUN in NVT
echo "Running NVT with cons ="$ConsF
mdCHARMM.pl -par $basicpar -par $basicpar2 -par boxx=$BoxX,boxy=$BoxY,boxz=$BoxZ,dynitemp=$T,dyntemp=$T,dynsteps=$stperCF -log $ConsF.nvt.log -cons self $Cons1"_"$ConsF=$Cons2"_"$ConsF -trajout $ConsF.nvt.dcd -final $ConsF.nvt.pdb -restout $ConsF.nvt.restart $PDB

PDB=$ConsF.nvt.pdb
restartIn=$ConsF.nvt.restart

#RUN in NPT
for i in $(eval echo "{1..$numRounds}")
	do
	echo "Round "$i" of "$numRounds" NPT calculations on "$PDB" Cons set to "$ConsF
		mdCHARMM.pl -par $basicpar -par $basicpar2 -par $basicpar3 -par dynitemp=$T,dyntemp=$T,dynsteps=$stperCF -log $ConsF.log -cons self $Cons1"_"$ConsF=$Cons2"_"$ConsF -trajout $ConsF.dcd -final $ConsF.pdb -restart $restartIn -restout $ConsF.restart $PDB
		finalStr=$ConsF.pdb
		finalRest=$ConsF.restart
		restartIn=$ConsF.restart
		ConsF=$(printf "%.2f\n" $(bc <<< "scale=3;$ConsF/2"))
	done

cp $finalStr eq.pdb
cp $finalRest eq.restart
