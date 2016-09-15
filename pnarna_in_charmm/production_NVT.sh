#!/bin/bash
#Production run for PNA-RNA
#No constrains

PDB="eq.pdb"
name="pna-rna"
restartIn="eq.restart"
T="300"
stProd=50000000 #100ns   500=1ps
stOutput=50000
#BoxX="63.3650016784668"
#BoxY="64.7229995727539"
#BoxZ="77.66200256347656"

basicpar="openmm,lang,langfbeta=1,dyneqfrq=0,param=36,pstream=toppar_pna_MJ_caps_MF.str,nodeoxy,terlist=PROA:ACE:CTN,langupd=0,dynoutfrq="$stOutput 
basicpar2="cutoff=10,cutnb=12,cuton=9"
#basicpar3="dynens=NPT,dynpress=1"

PATH=$PATH:/home/users/mifeig/mmtsb/perl:/home/users/mifeig/bin
export CHARMMEXEC="/home/users/mifeig/c41b1/bin/charmm"
export LD_LIBRARY_PATH="/home/users/mifeig/c41b1/lib:/home/users/mifeig/openmm/lib:$LD_LIBRARY_PATH"
export CHARMMDATA="/home/users/mifeig/mmtsb/data/charmm"
export OPENMM_PRECISION="mixed"
export OPENMM_DEVICE="0"
export OPENMM_CUDA_COMPILER="/usr/local/cuda-7.5/bin/nvcc"
export OPENMM_PLATFORM="CUDA"


#RUN in NPT		
echo "Production starts"
mdCHARMM.pl -par $basicpar -par $basicpar2 -par dynitemp=$T,dyntemp=$T,dynsteps=$stProd -log $name.prod.log -trajout $name.prod.dcd -final $name.final.pdb -restart $restartIn -restout $name.prod.restart $PDB

