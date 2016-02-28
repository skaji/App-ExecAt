requires 'perl', '5.008005';
requires 'HTTP::Date';
requires 'Time::Piece';

on test => sub {
    requires 'Test::More', '0.98';
};
