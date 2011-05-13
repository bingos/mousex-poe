package MouseX::POE::Role;
# ABSTRACT: Eventful roles
use MouseX::POE::Meta::Role;

use Mouse::Exporter;
use Mouse::Util::MetaRole;
use Mouse::Role;

Mouse::Exporter->setup_import_methods(
    as_is           => [qw(event)],
    also            => 'Mouse::Role',
);

sub init_meta {
    my ( $class, %args ) = @_;

    my $for = $args{for_class};
    eval qq{package $for; use POE; };

    my $meta = Mouse->init_meta( %args );

    Mouse::Util::MetaRole::apply_metaroles(
      for     => $args{for_class},
      role_metaroles => {
        role => ['MouseX::POE::Meta::Role','MouseX::POE::Meta::Trait'],
      },
    );

    Mouse::Util::MetaRole::apply_base_class_roles(
      for_class => $args{for_class},
      roles => ['MouseX::POE::Meta::Trait::Object','MouseX::POE::Meta::Trait','MouseX::POE::Meta::Trait::Class'],
    );

    return $meta;
}

sub event {
    my $class = Mouse::Meta::Class->initialize( scalar caller );
    $class->add_state_method( @_ );
}

1;
__END__

=begin Pod::Coverage

  init_meta

=end Pod::Coverage

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

