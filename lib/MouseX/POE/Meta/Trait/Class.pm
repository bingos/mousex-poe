package MouseX::POE::Meta::Trait::Class;
# ABSTRACT: No achmed inside
use Mouse::Role;

with qw(MouseX::POE::Meta::Trait);

# TODO: subclass events to be a hashref that maps the event to the method
# so we can support on_ events

around default_events => sub {
    my ( $next, $self ) = @_;
    my $events = $next->($self);
    push @$events, grep { s/^on_(\w+)/$1/; } $self->get_method_list;
    return $events;
};

=for comment

around add_role => sub {
    my ( $next, $self, $role ) = @_;
    $next->( $self, $role );

    if (   $role->meta->can('does_role')
        && $role->meta->does_role("MouseX::POE::Meta::Trait") ) {
        $self->add_event( $role->get_events );
    }
};

=cut

around get_state_method_name => sub {
    my ( $next, $self, $name ) = @_;
    return 'on_' . $name if $self->has_method( 'on_' . $name );
    return $next->( $self, $name );
};

sub get_all_events {
    my ($self) = @_;
    my $wanted_role = 'MouseX::POE::Meta::Trait';

    # This horrible grep can be removed once Mouse gets more metacircular.
    # Currently Mouse::Meta::Class->meta isn't a MMC. It should be, and it
    # should also be a Mouse::Object so does works on it.
    my %events
        = map {
        my $m = $_;
        map { $_ => $m->get_state_method_name($_) } $m->get_events
        }
        grep {
        $_->meta->can('does_role') && $_->meta->does_role($wanted_role)
        }
        map { $_->meta } $self->linearized_isa;
    return %events;
}

no Mouse::Role;
1;
__END__

=head1 METHODS

=method get_all_events

=head1 DEPENDENCIES

Mouse::Role

=cut
