[![Build Status](https://travis-ci.org/skaji/App-ExecAt.svg?branch=master)](https://travis-ci.org/skaji/App-ExecAt)

# NAME

App::ExecAt - execute command at certain time

# SYNOPSIS

    # exec command at the the next 00 second
    > exec-at minute /path/to/your/commad arg1 arg2

    # exec your command at nearly 5 minutes later (second will be normalized to 00)
    > exec-at '5 minutes later' /path/to/your/command arg1 arg2

    # exec your command at 2016-12-30 23:59:59
    > exec-at '2016-12-30 23:59:59' /path/to/your/command arg1 arg2

# DESCRIPTION

App::ExecAt executes your command at certain time.

# AUTHOR

Shoichi Kaji &lt;skaji@cpan.org>

# COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji &lt;skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
