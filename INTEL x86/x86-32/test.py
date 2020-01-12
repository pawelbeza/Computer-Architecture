import os
import subprocess

tests = [
    ['No flag, no width, positive value %d', '3451'],
    ['No flag, no width, negative value %d', '-3451'],
    ['Space flag, no width, positive value % d', '323145'],
    ['Space flag, no width, negative value % d', '-323145'],
    ['+ flag, no width, positive value %+d', '2147483647'],
    ['+ flag, no width, negative value %+d', '-2147483647'],
    ['- flag, nonzero width, positive value %-4dend', '10'],
    ['- flag, nonzero width, negative value %-4dend', '-10'],
    ['+ flag, nonzero width, positive value %+4dend', '23'],
    ['+ flag, nonzero width, negative value %+4dend', '-23'],
    ['0 flag, nonzero width, positive value %04dend', '5'],
    ['0 flag, nonzero width, negative value %04dend', '-5'],
]

for i in range(len(tests)):
    print("Test " + str(i))
    print("%s %s"%(tests[i][0], tests[i][1]))
    args = ['./formatdec', tests[i][0], tests[i][1]]
    subprocess.call(args)
    print('\n')