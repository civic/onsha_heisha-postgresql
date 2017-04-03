import random
import datetime

for n in range(100000):
    if n % 10000 == 0:
        if n > 0:
            print(";")
        print("INSERT INTO process_usage VALUES")
    else:
        print ",", 



    pid = random.randint(1, n % 100+1)
    usage = random.randint(0, 100)

    ts = datetime.datetime.fromtimestamp(1400000000 + n)
    

    print "({0}, {1}, '{2}')".format(pid, usage, ts)

