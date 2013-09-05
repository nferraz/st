st
==

simple statistics from the command line interface (CLI)

### Description

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

If you don't specify any options, you'll get this output:

    $ st numbers.txt
    count  min   max   sum   mean  sd
    10.00  1.00  10.00 55.00 5.50  3.03

And the "--summary" option will provide the five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1.00  3.50  5.50    7.50  10.00


#### How about "R", Octave and other analytical tools?

"R" and Octave are integrated suites of software for data manipulation,
calculation and graphical display.

They provide a wide variety of numerical functions (linear and
nonlinear modelling, statistical tests, time-series analysis,
classification, clustering, etc).

"st" is a simpler solution for simpler problems, focused on descriptive
statistics, handy when you need quick results without leaving the shell.


### Usage

    st <file>

    st [options] <file>

#### Options

If no options are used, "st" will print:

    n min max sum mean sd

For fine-grained control, the following options are available:

##### Output

    --N|n|count
    --max
    --mean|avg|m
    --median
    --min
    --mode
    --sd|stdev
    --sum|s
    --var|variance

    --percentile=<0..100>
    --quantile=<0..4>

    --summary   # five-number summary: min q1 median q3 max

##### Format

    --delimiter|d=<value>   # default: "\t"
    --format|fmt|f=<value>  # default: "%.2f"
    --no-header|nh
    --quiet|q               # silently skip invalid lines

##### Example

    st --no-header --delimiter='\n' --format='%d'


### Contributing

Send comments, suggestions and bug reports to:

https://github.com/nferraz/st/issues

Or fork the code on github:

https://github.com/nferraz/st
