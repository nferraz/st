st
==

descriptive statistics from the command line

Rationale
---------

Given a sample file:

    $ cat numbers.txt
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

How do you calculate the sum of these numbers from the command line?

### The traditional way

Here are some suggestions from the internet:

    awk '{s+=$1} END {print s}' numbers.txt

    perl -lne '$x += $_; END { print $x; }' < numbers.txt

    sum=0; while read num ; do sum=$(($sum + $num)); done < numbers.txt ; echo $sum

You can try any of the above or:

### Using st

    $ st --sum numbers.txt
    55

Ok, that was easy.

How about mean and standard deviation?

    $ st --mean --sd numbers.txt
    mean  sd
    5.50  3.03

Or perhaps you want a five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1.00  3.50  5.50    7.50  10.00

Finally, if you don't specify any command line options, you'll get:

    $ st numbers.txt
    count  min   max   sum   mean  sd
    10.00  1.00  10.00 55.00 5.50  3.03

