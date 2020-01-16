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
    ['+0 flag, nonzero width, positive value %+06d', '25'],
    ['+0 flag, nonzero width, negative value %+06d', '-25'],
    ['space,0 flag, nonzero width, positive value % 06d', '25'],
    ['space,0 flag, nonzero width, negative value % 06d', '-25'],
    ['Width shorter than number of digits, no flag, positive value %2d', '532131'],
    ['Width shorter than number of digits, no flag, negative value %2d', '-532131'],
    ['Width shorter than number of digits, + flag, positive value %+4d', '100000'],
    ['Width shorter than number of digits, + flag, negative value %+4d', '-100000'],
    ['Width shorter than number of digits, - flag, positive value %-3dend', '100000'],
    ['Width shorter than number of digits, - flag, negative value %-3dend', '-100000'],
    ['Width shorter than number of digits, space flag, positive value % 1d', '12345'],
    ['Width shorter than number of digits, space flag, negative value % 1d', '-12345'],
    ['Width shorter than number of digits, space flag, positive value %+01d', '1560133635'],
    ['Width shorter than number of digits, space flag, negative value %+01d', '-1560133635'],
    ['Width shorter than number of digits, space flag, positive value % 01d', '123'],
    ['Width shorter than number of digits, space flag, negative value % 01d', '-123']
]

for i in range(len(tests)):
    print("Test " + str(i))
    print("%s %s"%(tests[i][0], tests[i][1]))
    args = ['./formatdec', tests[i][0], tests[i][1]]
    subprocess.call(args)
    print('\n')