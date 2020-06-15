#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Data::Dumper;

our $VERSION = 0.05;
our $OVERLAP_IGNORE = .75;
our $EVAL_CUTOFF = 0.05;
our $PATTERN     = 'trypsin';

MAIN: {
    my $file = $ARGV[0] or die "usage: $0 HMMSCANOUT.domtabl\n";
    my $rh_coords = get_coords($file);
    remove_non_tryps($rh_coords);
    my $count = 0;
    my $total = 0;
    foreach my $id (keys %{$rh_coords}) {
        my @seq = ();
        foreach my $ra_dat (sort { ($b->[3] - $b->[2]) <=> ($a->[3] - $a->[2]) } @{$rh_coords->{$id}}) {
            my $code = overlap(\@seq,$ra_dat->[2],$ra_dat->[3]);
            add_bits(\@seq,$ra_dat->[2],$ra_dat->[3]);
            next if ($code == 0);
            $total++;
            my $len = $ra_dat->[1] - $ra_dat->[0];
            next unless ($len > 0);
            print_record($ra_dat->[4],$code);
        }
        print "---------------------------------------------------------\n";
    }
}

sub remove_non_tryps {
    my $rh_coords = shift;
    foreach my $id (keys %{$rh_coords}) {
        my $flag = 0;
        foreach my $ra_dat (@{$rh_coords->{$id}}) {
            $flag = 1 if ($ra_dat->[4]->[0] =~ m/$PATTERN/i);
        }
        delete $rh_coords->{$id} unless ($flag);
    }
}

sub print_record {
    my $ra_r = shift;
    my $code = shift;
    print "$ra_r->[0]\t$ra_r->[3]\t$ra_r->[12]\t$ra_r->[15]\t";
    print "$ra_r->[16]\t$ra_r->[17]\t$ra_r->[18]";
    print "\toverlap ($code)" if ($code < 1);
    print "\n";
}

# returns 0 if complete overlap or .90 overlap
# returns 1 if no overlap
# returns 2 if slight overlap (< .90);
sub overlap {
    my $ra_a = shift;
    my $c1 = shift;
    my $c2 = shift;
    my $bithits = 0;
    for my $val ($c1..$c2) {
        $bithits++ if ($ra_a->[$val - 1]);
    }
#print "\$bithits = $bithits\n";
    my $perc = $bithits / ($c2 - $c1 + 1);
    return 1 if (!$bithits);
#    return 0 if ((1 - ($bithits / ($c2 - $c1 + 1))) >= $OVERLAP_IGNORE);
    return 0 if ($perc >= $OVERLAP_IGNORE);
    return $perc;
}

sub add_bits {
    my $ra_a = shift;
    my $c1 = shift;
    my $c2 = shift;
    for my $val ($c1..$c2) {
        $ra_a->[$val - 1]++;
    }
}

sub get_coords {
    my $file = shift;
    my %coords = ();
    open(my $fh, "<", $file);
    while (my $line = <$fh>) {
        next if ($line =~ m/^\s*#/);
        my @f = split /\s+/, $line;
        next if ($f[12] > $EVAL_CUTOFF);
        my $hmm_x = $f[15];
        my $hmm_y = $f[16];
        my $que_x = $f[17];
        my $que_y = $f[18];        
        push @{$coords{$f[3]}}, [$hmm_x,$hmm_y,$que_x,$que_y,\@f];
    }
    return \%coords;
}

