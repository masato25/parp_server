ps auxww|grep mix |grep parp|awk -F' ' '{system("kill -9 " $2)}'
