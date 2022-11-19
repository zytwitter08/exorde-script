#!/bin/bash
source ~/.profile

FILE="rlog.txt"

echo "===== Restart Nodes on $(date) =====" >> $FILE
bash ./exorde.sh << EOF &>> $FILE
2
2
EOF
echo -e "\n" >> $FILE

