package App::ExecAt;
use strict;
use warnings;
require Getopt::Long;
use Pod::Usage ();
use Time::Piece ();
use HTTP::Date ();

our $VERSION = '0.01';

sub parse_options {
    my ($self, @argv) = @_;
    my $parser = Getopt::Long::Parser->new(config => ["no_ignore_case", "no_auto_abbrev"]);
    $parser->getoptionsfromarray(
        \@argv,
        "h|help" => sub { Pod::Usage::pod2usage(0) },
        "v|version" => sub { printf "%s %s\n", ref $self, $self->VERSION; exit },
        "q|quiet" => \$self->{quiet},
    ) or exit 1;

    my ($at, @command) = @argv;
    die "Missing 'AT' argument, try `exec-at --help`\n" unless $at;
    die "Missing 'COMMANDS' argument, try `exec-at --help`\n" unless @command;
    $self->{at} = $self->_parse_at($at);
    @command;
}

sub _parse_at {
    my ($self, $at) = @_;
    if ($at =~ /(\d+)?\s*(minute|hour|day)s?/i) {
        my $now = Time::Piece->new + 1;
        my $later = $1 || 1;
        my $unit  = lc $2;
        if ($unit eq "minute") {
            my $normalize = $now - $now->second;
            return $normalize + $later * 60;
        } elsif ($unit eq "hour") {
            my $normalize = $now - $now->second - $now->minute * 60;
            return $normalize + $later * 60*60;
        } elsif ($unit eq "day") {
            my $normalize = $now - $now->second - $now->minute * 60 - $now->hour * 24*60;
            return $normalize + $later * 24*60*60;
        }
    } elsif (my $epoch = HTTP::Date::str2time($at)) {
        return Time::Piece->new($epoch);
    } else {
        die "Unrecognized 'at': $at\n";
    }
}

sub run {
    my $self = bless {}, shift;
    my @argv = $self->parse_options(@_);
    my $at = $self->{at};
    warn sprintf "-> Will execute command at %s\n", $at->strftime("%F %T") unless $self->{quiet};
    while (1) {
        my $now = Time::Piece->new;
        if ($now == $at) {
            exec @argv;
            exit 255;
        } elsif ($now < $at) {
            sleep 1;
        } else {
            die sprintf "Too old 'at': %s\n", $at->strftime("%F %T");
        }
    }
}

no warnings;
__PACKAGE__;
__END__

=encoding utf-8

=head1 NAME

App::ExecAt - execute command at certain time

=head1 SYNOPSIS

  # exec command at the next 00 second
  > exec-at minute /path/to/your/commad arg1 arg2

  # exec your command at nearly 5 minutes later (second will be normalized to 00)
  > exec-at '5 minutes later' /path/to/your/command arg1 arg2

  # exec your command at 2016-12-30 23:59:59
  > exec-at '2016-12-30 23:59:59' /path/to/your/command arg1 arg2

=head1 DESCRIPTION

App::ExecAt executes your command at certain time.

=head1 AUTHOR

Shoichi Kaji <skaji@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
