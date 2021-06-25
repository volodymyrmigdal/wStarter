RET=0; until [ ${RET} -ne 0 ]; do
    reset
    taskset 0x1 node proto/wtools/atop/starter.test/Ext.test.s r:experiment v:10
    RET=$?
    sleep 1
done