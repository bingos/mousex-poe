package MouseX::POE::Meta::Trait::Instance;

# ABSTRACT: A Instance Metaclass for MouseX::POE

use Mouse::Role;
use POE;

use Scalar::Util ();

sub get_session_id {
    my ( $self, $instance ) = @_;
    return $instance->{session_id};
}

sub get_slot_value {
    my ( $self, $instance, $slot_name ) = @_;
    return $instance->{heap}{$slot_name};
}

sub set_slot_value {
    my ( $self, $instance, $slot_name, $value ) = @_;
    $instance->{heap}{$slot_name} = $value;
}

sub is_slot_initialized {
    my ( $self, $instance, $slot_name, $value ) = @_;
    exists $instance->{heap}{$slot_name} ? 1 : 0;
}

sub weaken_slot_value {
    my ( $self, $instance, $slot_name ) = @_;
    Scalar::Util::weaken( $instance->{heap}{$slot_name} );
}

sub inline_slot_access {
    my ( $self, $instance, $slot_name ) = @_;
    sprintf '%s->{heap}{%s}', $instance, $slot_name;
}

no POE;
no Mouse::Role;
1;
__END__

=head1 SYNOPSIS

    Mouse::Util::MetaRole::apply_metaclass_roles(
      for_class => $for_class,
      metaclass_roles => [
        'MouseX::POE::Meta::Trait::Class'
      ],
      instance_metaclass_roles => [
        'MouseX::POE::Meta::Trait::Instance',
      ],
    );


=head1 DESCRIPTION

A metaclass for MouseX::POE. This module is only of use to developers
so there is no user documentation provided.

=head1 METHODS

=method create_instance

=method get_slot_value

=method inline_slot_access

=method is_slot_initialized

=method set_slot_value

=method weaken_slot_value

=method get_session_id
