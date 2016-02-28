requires 'perl', '5.008005';
requires 'HTTP::Date';
requires 'Time::Piece';
requires 'Getopt::Long', '2.36';

on test => sub {
    requires 'Test::More', '0.98';
};
