#!/usr/bin/perl -w

################################################################################
## @file threadstat.pl
## @brief Parse an LXT trace file in text format and give time info
##        related to a given thread.
##
## @author Adrien Charruel
## @date 20/07/2010
##
## @par Revision
## $Id$
##
## @par Company
## (c) Parrot S.A. @n
## 174, quai de Jemmapes @n
## 75010 Paris @n
## France @n
## Website: http://www.parrot.biz @n
################################################################################

package threadstat;

use strict;
use warnings;
use Getopt::Long;

my($filein,
   $line,
   $pid,
   $curtime,
   $time_try_wakeup,
   $time_sched,
   $time_sched_end,
   $time,
   $parse_beg_time,
   $parse_end_time,
   $store_time_boundaries,
   $time_irq,
   $time_irq_rm,
   $nested,
   $wait_count,
   $total_time_try_wakeup,
   $avg_waiting_time,
   $pouet,
   $cpu_load);

$curtime = 0;
$time_try_wakeup = 0;
$time_sched = 0;
$time_sched_end = 0;
$time = 0;
$store_time_boundaries = 0;
$time_irq_rm = 0;
$nested = 0;
$wait_count = 0;
$total_time_try_wakeup = 0;

options();

open (FD, "$filein") or die "can't open file";

foreach (<FD>)
{
    $line = $_;
    chomp;
    next unless $_;

    # Enter loop
    if (index($line, "Trace set contains") != -1)
    {
        next;
    }

    # Exit loop condition
    if (index($line, "End trace set") != -1)
    {
        last;
    }

    # Grab current time
    ($curtime) = ($line =~ m/.*?: ([\d\.]*)/);

    # Update begin parsing time if not set by user
    if ($store_time_boundaries == 1 && $parse_beg_time == 0)
    {
        $parse_beg_time = $curtime;
    }

    # Update end parsing time if not set by user
    if ($store_time_boundaries == 1)
    {
        $parse_end_time = $curtime;
    }

    # Check time boundaries
    if ($curtime > $parse_end_time ||
        $curtime < $parse_beg_time)
    {
        next;
    }

    # Shed try wakeup
    if (index($line, "pid = $pid")              != -1 &&
        index($line, "kernel.sched_try_wakeup") != -1)
    {
        # Store time
        $time_try_wakeup = $curtime;
        $wait_count++;
    }

    # Sched begin
    if (index($line, "next_pid = $pid")       != -1 &&
        index($line, "kernel.sched_schedule") != -1)
    {
        # Store time
        $time_sched = $curtime;

        if ($time_try_wakeup != 0)
        {
            $total_time_try_wakeup += $curtime - $time_try_wakeup;
        }
    }

    # Sched end
    if (index($line, "prev_pid = $pid")       != -1 &&
        index($line, "kernel.sched_schedule") != -1)
    {
        # Error check
        if ($time_sched == 0)
        {
            next;
        }

        # Store time
        $time_sched_end = $curtime;

        $pouet = $time_sched_end - $time_sched;

        # Update values
        $time = $time + $time_sched_end - $time_sched;

        # Reset temp var
        $time_try_wakeup = 0;
        $time_sched = 0;
        $time_sched_end = 0;
    }

    # Remove IRQ time
    if (index($line, "kernel.irq_entry") != -1 &&
        $time_sched != 0)
    {
        if ($nested == 0)
        {
            $time_irq = $curtime;
        }
        $nested++;
    }

    if (index($line, "kernel.irq_exit") != -1 &&
        $nested > 0)
    {
        $nested--;
    }

    # IRQ exit point
    if (index($line, "kernel.irq_exit") != -1 &&
        $time_sched != 0 &&
        $nested == 0)
    {
        # Store time
        $time_irq_rm += $curtime - $time_irq;
    }
}

# Print results
print("Time spend in IRQ during thread $pid: $time_irq_rm s\n");

$time = $time - $time_irq_rm;
$cpu_load = 100 * $time / ($parse_end_time - $parse_beg_time);
$avg_waiting_time = $total_time_try_wakeup / $wait_count;

print("\n");
print("Trace begins at time $parse_beg_time s.\n");
print("Trace ends at time $parse_end_time s.\n");
print("Time spent in thread $pid = $time s.\n");
print("Thread $pid average waiting time: $avg_waiting_time s. ($wait_count times)\n");
print("CPU load = $cpu_load %\n");
print("\n");

# Options parsing subfunction
sub options
{
    my($help);

    GetOptions('b|begin-time=i' => \$parse_beg_time,
               'e|end_time=i'   => \$parse_end_time,
               't|pid=i'        => \$pid,
               'h|help'         => \$help);

    if ($help)
    {
        print_usage();
        exit;
    }

    $filein = $ARGV[0];

    if ($parse_beg_time && $parse_end_time)
    {
        print("Parsing \"$filein\" from $parse_beg_time s. to $parse_end_time s.\n");
        print("Stats for thread $pid\n");
    }
    else
    {
        $parse_beg_time = 0;
        $parse_end_time = 0;
        $store_time_boundaries = 1;

        print("Parsing \"$filein\"\n");
        print("Stats for thread $pid\n");
    }
}

# Usage subfunction
sub print_usage
{
    print "$0 <trace.txt> -t <pid> [-b <begin_time> -e end_time]\n\n";
    print "Parse an LXT trace file in text format and give time info
           related to a given IRQ.";
    print "trace.txt
           Trace file generated by LTT\n\n";
    print "-t or --pid thread id
           Mandatory: identifier of the thread you want to check\n\n";
    print "-b or --begin-time begin_time
           Optional: time when the parsing of the trace begins\n\n";
    print "-e or --end-time begin_time
           Optional: time when the parsing of the trace ends\n\n";
    print "-h or --help
           This help...\n\n";
}

