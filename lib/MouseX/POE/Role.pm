package MouseX::POE::Role;
# ABSTRACT: Eventful roles
use MouseX::POE::Meta::Role;

use Mouse::Exporter;

my ( $import, $unimport, $init_meta ) = Mouse::Exporter->setup_import_methods(
    with_caller    => [qw(event)],
    also           => 'Mouse::Role',
    install        => [qw(import unimport)],
    role_metaroles => {
        role => ['MouseX::POE::Meta::Role'],
    },
);

sub init_meta {
    my ( $class, %args ) = @_;

    my $for = $args{for_class};
    eval qq{package $for; use POE; };

    Mouse::Role->init_meta( for_class => $for );

    goto $init_meta;
}

sub event {
    my ( $caller, $name, $method ) = @_;
    my $class = Mouse::Meta::Class->initialize($caller);
    $class->add_state_method( $name => $method );
}


1;
__END__

=head1 SYNOPSIS

    package Counter;
    use MouseX::POE::Role;

    ...

    package RealCounter;

    with qw(Counter);
  
=head1 DESCRIPTION

This is what L<MouseX::POE> is to Mouse but with L<Mouse::Role>.

=head1 KEYWORDS

=method event $name $subref

Create an event handler named $name. 

=for :list
* L<MouseX::POE|MouseX::POE>
* L<Mouse::Role> 

