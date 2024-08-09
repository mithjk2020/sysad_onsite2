#!/bin/bash

starting_time() {
    local started=$1
    docker inspect -f '{{.Created}}' $started
}

program() {
    local running=$(docker ps -q)
    
    for id in $running; do
        initial_time=$(starting_time $id)
        initial_timestamp=$(date -d "$initial_time" +%s)
        current_timestamp=$(date +%s)
        interval=$(( current_timestamp - initial_timestamp ))

        if [[ $interval -gt 120 ]]; then
            temp=False
            networks=$(docker inspect -f '{{json .NetworkSettings.Networks}}' $id | jq -r 'keys[]')

            for component in $networks; do
                network_containers=$(docker network inspect -f '{{json .Containers}}' $component | jq -r 'keys[]')

                for others in $network_containers; do
                    if [ "$id" != "$others" ]; then
                        info=$(docker inspect -f '{{.State.Status}}' $others)
                        if [[ "$info" != "running" ]]; then
                            temp=True
                            break
                        fi
                    fi
                done

                if [ "$temp" = False ]; then
                    for component in $networks; do
                        network_containers=$(docker network inspect -f '{{json .Containers}}' $component | jq -r 'keys[]')
                        for others in $network_containers; do
                            if [ "$id" != "$others" ]; then
                                docker stop $others
                                echo "$(date): Stopped container: $others" >> "/home/mithra/onsite2/details3.log"
                            fi
                        done
                    done
                fi
            done
        fi
    done
}
while true; do
 program
 sleep 60
done
