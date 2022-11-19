#!/bin/bash
source ~/.profile

FILE="rlog.txt"

echo "===== Restart Nodes on $(date) =====" >> $FILE
bash ./exorde1.sh << EOF &>> $FILE
3
2
EOF
echo -e "\n" >> $FILE

