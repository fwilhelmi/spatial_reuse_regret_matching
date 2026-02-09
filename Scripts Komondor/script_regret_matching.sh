#!/bin/bash

# define execution parameters
SIM_TIME=100
SEED=1

# Define your subfolders here
SUBFOLDERS=("d_3.0" "d_4.0" "d_5.0" "d_6.0" "d_7.0" "d_8.0" "d_9.0" "d_10.0")

# Compile KOMONDOR
cd ..
cd main
make
echo 'EXECUTING KOMONDOR SIMULATIONS WITH FULL CONFIGURATION... '

# Stay inside the "main" directory for execution
# We will reference inputs and outputs using relative paths (../input/...)

# Clean old outputs (Be careful, this clears the whole folder)
rm ../output/* 2>/dev/null

##### PART 1: RANDOM SCENARIOS - STATIC
echo ""
echo "++++++++++++++++++++++++++++++++++++++"
echo "   PART 1: TWO-BSS SCENARIO (STATIC)  "
echo "++++++++++++++++++++++++++++++++++++++"

for folder in "${SUBFOLDERS[@]}"
do
    echo "--------------------------------------"
    echo " PROCESSING SUBFOLDER: $folder"
    echo "--------------------------------------"
    
    # Path to current input folder
    CURRENT_INPUT_PATH="../input/input_regret_matching/input_random_2_bss_d3-5/$folder"
    
    # Get list of files in that folder
    # We use ls with the path, then strip the path to just get filenames
    mapfile -t array_nodes < <(ls "$CURRENT_INPUT_PATH")
    
    # Get number of files
    num_files=${#array_nodes[@]}
    
    echo "DETECTED ${num_files} INPUT FILES IN $folder"

    # Iterate through files
    for (( i=0; i<num_files; i++ ))
    do 
        echo "- EXECUTING ${array_nodes[i]} ($i/$((num_files-1)))"
        
        # DEFINITION OF OUTPUTS:
        # We append the folder name ($folder) to the output text and the CSV 
        # so d3.0 does not overwrite d4.0
        
        ./komondor_main \
            "$CURRENT_INPUT_PATH/${array_nodes[i]}" \
            "../output/script_output_2_bss_static_${folder}.txt" \
            "sim_${folder}_${i}.csv" \
            0 1 1 $SIM_TIME $SEED >> ../output/logs_console_static.txt
    done
done


##### PART 2: RANDOM SCENARIOS - E-GREEDY
echo ""
echo "++++++++++++++++++++++++++++++++++++++"
echo "   PART 2: TWO-BSS SCENARIO (E-GREEDY)"
echo "++++++++++++++++++++++++++++++++++++++"

for folder in "${SUBFOLDERS[@]}"
do
    echo "--------------------------------------"
    echo " PROCESSING SUBFOLDER: $folder"
    echo "--------------------------------------"
    
    CURRENT_INPUT_PATH="../input/input_regret_matching/input_random_2_bss_d3-5/$folder"
    mapfile -t array_nodes < <(ls "$CURRENT_INPUT_PATH")
    num_files=${#array_nodes[@]}
    
    for (( i=0; i<num_files; i++ ))
    do 
        echo "- EXECUTING ${array_nodes[i]} ($i/$((num_files-1)))"
        
        ./komondor_main \
            "$CURRENT_INPUT_PATH/${array_nodes[i]}" \
            "../input/input_regret_matching/agents_egreedy2.csv" \
            "../output/script_output_2_bss_egreedy_${folder}.txt" \
            "sim_${folder}_${i}.csv" \
            0 0 1 1 1 $SIM_TIME $SEED >> ../output/logs_console_egreedy.txt
    done
done


##### PART 3: RANDOM SCENARIOS - REGRET-MATCHING
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "   PART 3: TWO-BSS SCENARIO (REGRET-MATCHING)"
echo "+++++++++++++++++++++++++++++++++++++++++++++"

for folder in "${SUBFOLDERS[@]}"
do
    echo "--------------------------------------"
    echo " PROCESSING SUBFOLDER: $folder"
    echo "--------------------------------------"
    
    CURRENT_INPUT_PATH="../input/input_regret_matching/input_random_2_bss_d3-5/$folder"
    mapfile -t array_nodes < <(ls "$CURRENT_INPUT_PATH")
    num_files=${#array_nodes[@]}
    
    for (( i=0; i<num_files; i++ ))
    do 
        echo "- EXECUTING ${array_nodes[i]} ($i/$((num_files-1)))"
        
        ./komondor_main \
            "$CURRENT_INPUT_PATH/${array_nodes[i]}" \
            "../input/input_regret_matching/agents_regretmatching2.csv" \
            "../output/script_output_2_bss_regretmatching_${folder}.txt" \
            "sim_${folder}_${i}.csv" \
            0 0 1 1 1 $SIM_TIME $SEED >> ../output/logs_console_regretmatching.txt
    done
done