st
==

simple statistics from the command line interface (CLI)

### Rationale

Imagine you have this sample file:

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

How do you calculate the sum of the numbers?

#### The traditional way

If you ask around, you'll come up with suggestions like these:

    $ awk '{s+=$1} END {print s}' numbers.txt
    55

    $ perl -lne '$x += $_; END { print $x; }' numbers.txt
    55

    $ sum=0; while read num ; do sum=$(($sum + $num)); done < numbers.txt ; echo $sum
    55

    $ paste -sd+ numbers.txt | bc
    55

Now imagine that you need to calculate the arithmetic mean, median,
or standard deviation...

#### Using st

"st" is a command-line tool to perform simple statistical calculations.

Let's start with "sum":

    $ st --sum numbers.txt
    55

That was easy!

How about mean and standard deviation?

    $ st --mean --sd numbers.txt
    mean  sd
    5.50  3.03

If you don't specify command line options, you'll get this output:

    $ st numbers.txt
    count  min   max   sum   mean  sd
    10.00  1.00  10.00 55.00 5.50  3.03

And the "--summary" option will provide with this five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1.00  3.50  5.50    7.50  10.00

#### How about "R" and other analytical tools?

"R" is an integrated suite of software facilities for data manipulation,
calculation and graphical display.

It provides a wide variety of statistical (linear and nonlinear modelling,
statistical tests, time-series analysis, classification, clustering, ...).

"st" is a simpler solution for simpler problems, focused on descriptive
statistics, handy when you need quick results without leaving the shell.

Let me know if you have any suggestions or feedback!

#### Documentation

    man st
