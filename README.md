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

"st" is a command-line tool to calculate simple statistics from a
file or standard input.

Let's start with "sum":

    $ st --sum numbers.txt
    55

That was easy!

How about mean and standard deviation?

    $ st --mean --stddev numbers.txt
    mean  stddev
    5.5   3.02765

If you don't specify any options, you'll get this output:

    $ st numbers.txt
    N     min   max   sum   mean  stddev
    10    1     10    55    5.5   3.02765

You can switch rows and columns using the "--transpose-output" option:

    $ st --transpose-output numbers.txt
    N       10
    min     1
    max     10
    sum     55
    mean    5.5
    stddev  3.02765

The "--summary" option will provide the five-number summary:

    $ st --summary numbers.txt
    min   q1    median  q3    max
    1     3.5   5.5     7.5   10

And "--complete" will print a complete description:

    $ st --complete numbers.txt
    N   min   q1    median  q3    max   sum   mean  stddev  stderr
    10  1     3.5   5.5     7.5   10    55    5.5   3.02765 0.957427

#### How does it compare with R, Octave and other analytical tools?

"R" and Octave are integrated suites for data manipulation, calculation
and graphical display.

They provide high-level interpreted languages, capabilities for the
numerical solution of linear and nonlinear problems, and for
performing other numerical experiments, including statistical tests,
classification, clustering, etc.

"st" is a simpler solution for simpler problems, focused on descriptive
statistics for small datasets, handy when you need quick results
without leaving the shell.


### Usage

    st [options] [file]

#### Options

##### Functions

    --N|n|count
    --mean|avg|m
    --stddev|sd
    --stderr|sem|se
    --sum|s
    --var|variance

    --min
    --q1
    --median
    --q3
    --max

If no functions are selected, "st" will print the default output:

    N     min  max  sum  mean  stddev

You can also use the following predefined sets of functions:

    --summary   # five-number summary (min q1 median q3 max)
    --complete  # everything

##### Formatting

    --format|fmt|f=<value>  # default: "%g"
    --delimiter|d=<value>   # default: "\t"

    --no-header|nh          # don't display header
    --transpose-output|to   # switch rows and columns

Examples of valid formats ("--format" option):

        %d    signed integer, in decimal
        %e    floating-point number, in scientific notation
        %f    floating-point number, in fixed decimal notation
        %g    floating-point number, in %e or %f notation

##### Input validation

By default, "st" skips invalid input with a warning.

You can change this behavior with the following options:

    --strict   # throws an error, interrupting process
    --quiet|q  # no warning

### Author

Nelson Ferraz <<nferraz@gmail.com>>

### Contribute

Send comments, suggestions and bug reports to:

https://github.com/nferraz/st/issues

Or fork the code on github:

https://github.com/nferraz/st
