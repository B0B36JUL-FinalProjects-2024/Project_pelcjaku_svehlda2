#!/bin/bash

MODEL_DIR="models"

if [ ! -d $MODEL_DIR ]; then
  mkdir $MODEL_DIR
fi

cd $MODEL_DIR

LINKS=(
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/Ebp3rHGoSsxHj7UkXR4R-_MBisgE8sjRUXPKzSNfxN3D4g?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/EUKklCk3YMpOhnuX_leUbH8Bgg-fSOVYsMyWlkIXPVkl8g?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/EUP4ukA6eihNp65gKVNURkQBPpZMOa_-gTcxoyjNFZ31rg?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/Ed_p5LmJa2tCiz_7X4vqIvkBVf_e6eHh2zTnHWy_H_RkBQ?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/EdzBux_JqhtKnAcYHcfE5XABPsclqU5ox03MpqCiNJmtDA?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/Ee8tkbHzzOFMklmvoj_SrqgBB8q4GIcQC1mQZsoqq7GXrQ?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/ETl5Zn8mXeBFomxbIiIZ9WABfTJ7Fu0gttWad47UI8dbWw?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/EQ4jnhCylGlGiAHt6D22qMQBwTxOETm_muqOJLDAP7dMMw?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/ESY2PZceIT5EqN6CyrApcGMBnF7vF-iDqrVckbi9BmfbUg?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/EWZSimf67gBLjjOfhSvq6g0B6KmxKR4Bts2APIFOgt7X0g?download=1
https://campuscvut-my.sharepoint.com/:u:/g/personal/pelcjaku_cvut_cz/Ec0PE9Pnn1VDgkyXovBSbq4BhlaYM_LxcVMvCYd3u-Qjww?download=1
)

for i in {0..10}
do
	wget --content-disposition ${LINKS[$i]}
done