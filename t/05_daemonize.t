#!/usr/bin/env perl
use strict;
use Test::More;
eval "use MouseX::Daemonize";
plan skip_all => "MouseX::Daemonize not installed; skipping" if $@;

plan tests => 3;

{
    package App;
    use MouseX::POE;
    
    with qw(MouseX::Daemonize);
    
    sub START { 
        my ($self) = $_[OBJECT];
        ::pass('START');
        $self->yield('next');
    }
    
    event next => sub { ::pass('next') };
    
    sub STOP { ::pass('STOP') }
}

App->new;
POE::Kernel->run;
