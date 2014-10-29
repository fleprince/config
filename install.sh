#!/bin/bash


# HOME FOLDER
for file in `ls -a files/home/`; do
    if [ "${file}" != "." -a "${file}" != ".." ]; then
        if [ -e ~/${file} ]; then
            echo "${file} already exists. Do you want it to be replaced [y/n] ?"
            read
            if [ "${REPLY}" == "y" ]; then
                rm -rf ~/${file}
                ln -s ${PWD}/files/home/${file} ~/
                echo "Link to ${file} created"
            fi
        else
            ln -s ${PWD}/files/home/${file} ~/
            echo "Link to ${file} created"
        fi
    fi
done


