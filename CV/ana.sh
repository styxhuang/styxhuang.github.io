echo e "1\n" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup convert-tpr -s npt-cg-2.tpr -o process.tpr -n index.ndx
echo e "1\n" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup trjconv -s process.tpr -f npt-cg-2.xtc -o process.xtc -n index.ndx

echo -e "1\n1" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup sasa -s process.tpr -f process.xtc -n index.ndx -o area_1_1.xvg
echo -e "14\n14" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup sasa -s process.tpr -f process.xtc -n index.ndx -o area_14_14.xvg
echo -e "15\n15" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup sasa -s process.tpr -f process.xtc -n index.ndx -o area_15_15.xvg

echo -e "1\n1" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup rdf -s process.tpr -f process.xtc -n index.ndx -cut 0.5 -rmax 2 -b 5000 -o rdf_1_1.xvg
echo -e "14\n14" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup rdf -s process.tpr -f process.xtc -n index.ndx -cut 0.5 -rmax 2 -b 5000 -o rdf_14_14.xvg
echo -e "15\n15" | singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd ../../GROMACS_2022.1.sif gmx -quiet -nobackup rdf -s process.tpr -f process.xtc -n index.ndx -cut 0.5 -rmax 2 -b 5000 -o rdf_15_15.xvg
