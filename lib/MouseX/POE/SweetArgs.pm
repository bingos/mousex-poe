package MouseX::POE::SweetArgs;
# ABSTRACT: sugar around MouseX::POE event arguments

use Mouse ();
use MouseX::POE;
use Mouse::Exporter;


Mouse::Exporter->setup_import_methods(
    also        => 'MouseX::POE',
);

sub init_meta {
    my ($class, %args) = @_;
    MouseX::POE->init_meta(%args);

    Mouse::Util::MetaRole::apply_metaroles(
        for             => $args{for_class},
        class_metaroles => {
            class => ['MouseX::POE::Meta::Trait::SweetArgs'],
        },
    );
}


1;
__END__

=head1 SYNOPSIS

  package Thing;
  use MouseX::POE::SweetArgs;

  # declare events like usual
  event on_success => sub {
    # unpack args like a Perl sub, not a POE event
    my ($self, $foo, $bar) = @_;
    ...
    POE::Kernel->yield('foo');
    ...
  };

=head1 DESCRIPTION

Normally, when using MouseX::POE, subs declared as events need to use POE
macros for unpacking C<@_>, e.g.:

  my ($self, $foo, $bar) = @_[OBJECT, ARG0..$#_];

Using MouseX::POE::SweetArgs as a metaclass lets you avoid this, and just use
C<@_> as normal:

  my ($self, $foo, $bar) = @_;

Since the POE kernel is a singleton, you can access it using class methods, as
shown in the synopsis.

In all other respects, this behaves exactly like MouseX::POE

=for :list
* L<MouseX::POE|MouseX::POE>
