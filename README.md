st
==

descriptive statistics from the command line interface (CLI)

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

How do you calculate the sum of the numbers from the command-line?

### The traditional way

If you ask around, you'll come up with suggestions like these:

    $ awk '{s+=$1} END {print s}' numbers.txt
    55

    $ perl -lne '$x += $_; END { print $x; }' < numbers.txt
    55

    $ sum=0; while read num ; do sum=$(($sum + $num)); done < numbers.txt ; echo $sum
    55

Now imagine that you need something more complex!

### Enters st

"st" is a simple command-line tool to perform simple statistical calculations.

Let's start with "sum":

    $ st --sum numbers.txt
    55

That was easy!

How about mean and standard deviation?

    $ st --mean --sd numbers.txt
    mean  sd
    5.50  3.03

Or perhaps you want a five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1.00  3.50  5.50    7.50  10.00

Finally, if you don't specify any command line options, you'll get this useful
output:

    $ st numbers.txt
    count  min   max   sum   mean  sd
    10.00  1.00  10.00 55.00 5.50  3.03

### How about "R" and other analytical tools?

"R" is an integrated suite of software facilities for data manipulation,
calculation and graphical display.

"st" is focused exclusively on descriptive statistics, and to be used from
the traditional shell, so you can use pipes, etc.

This just the beginning! Let me know if you have any suggestions or feedback.

