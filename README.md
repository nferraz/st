st
==

statistics from the command line interface (CLI)

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

"st" is a command-line tool to calculate simple statistics from a
file or standard input.

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

You can modify the output format with "--no-header", "--transverse-output"
and "format":

    $ st --no-header --transverse-output --format='%5.1f'
    10.0
     1.0
    10.0
    55.0
     5.5
     3.0

And the "--summary" option will provide the five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1.00  3.50  5.50    7.50  10.00


#### How does it compare with R, Octave and other analytical tools?

"R" and Octave are integrated suites for data manipulation, calculation
and graphical display.

They provide high-level interpreted languages, capabilities for the
numerical solution of linear and nonlinear problems, and for
performing other numerical experiments, including statistical tests,
classification, clustering, etc.

"st" is a simpler solution for simpler problems, focused on descriptive
statistics, handy when you need quick results without leaving the shell.


### Usage

    st <file>

    st [options] <file>

#### Options

##### Functions

    --N|n|count
    --max
    --mean|avg|m
    --median
    --min
    --mode
    --sd|stdev
    --sem|sterr
    --sum|s
    --var|variance

    --percentile=<0..100>
    --quartile=<1..3>

    --summary   # five-number summary: min q1 median q3 max
    --complete  # complete results

If no functions are selected, "st" will print:

    n min max sum mean sd

##### Formatting

    --delimiter|d=<value>   # default: "\t"
    --format|fmt|f=<value>  # default: "%.2f"

    --no-header|nh          # don't display header
    --transverse-output     # output in multiple lines

##### Error handling

By default, "st" skips invalid input with a warning.

You can change this behavior with the following options:

    --strict   # interrupt process
    --quiet|q  # skip with no warning

### Contributing

Send comments, suggestions and bug reports to:

https://github.com/nferraz/st/issues

Or fork the code on github:

https://github.com/nferraz/st
