find_parents=../../../util/find_parents

outbase=/snap8/scratch/dp004/dc-foro1/halo_comparison/L1000N1800/DMO_FIDUCIAL/Rockstar/
box_size=681

for snapshot in $(cat ../snapshot_names.txt); do

    echo "Running for snapshot ${snapshot}"
    mkdir -p "${outbase}/merger_tree/snapshot_${snapshot}"

    #TODO: Not sure if lines will be split if I use -b
    $find_parents "${outbase}/out_${snapshot}.list" $box_size | split -d -l 700000 -a 4 --additional-suffix=.list - "${outbase}/merger_tree/snapshot_${snapshot}/parents_${snapshot}."

    first_file="${outbase}/merger_tree/snapshot_${snapshot}/parents_${snapshot}.0000.list"
    temp="${outbase}/merger_tree/snapshot_${snapshot}/temp.list"
    n_files=$(ls "${outbase}/merger_tree/snapshot_${snapshot}" | wc -l)
    for ((i = 1; i < n_files; i++)); do
        chunk=$(printf '%04d' ${i})
        filename="${outbase}/merger_tree/snapshot_${snapshot}/parents_${snapshot}.${chunk}.list"
        head -n 1 $first_file | cat - $filename > $temp  && mv -f $temp $filename
    done
done


#TODO: Remove
#sed -i "1s/^/$(head -n 1 ${first_file})\n/" "${outbase}/merger_tree/snapshot_${snapshot}/parents_${snapshot}.${chunk}.out"

