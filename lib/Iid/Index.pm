use v5.18;
package Iid::Index {
    use Mo qw'default';
    has 'name';
    has 'directory';
    has kv => ( default => sub { {} } );
    sub add {
        my ($self, $id, $terms) = @_;
        for my $term (@$terms) {
            my $t = $self->kv->{terms}{$term} //= {tf=>0,docs=>[]};
            my $n = @{$t->{docs}};
            my $i = 0;
            while ( $i < $n && $t->{docs}[$i] lt $id ) { $i++ };
            unless (defined($t->{docs}[$i]) && $t->{docs}[$i] eq $id) {
                $t->{tf}++;
                @{$t->{docs}}[ $i .. $n ] = ($id, @{$t->{docs}}[ $i .. $n-1 ]);
            }
        }
        return 1;
    }
};
1;
