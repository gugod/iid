use v5.18;
package Iid::Index {
    use Mo qw'default';
    use File::Spec::Functions qw'catfile';
    use Sereal::Encoder;
    use Sereal::Decoder;

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

    sub _index_file {
        my $self = shift;
        return catfile($self->directory, $self->name . ".sereal");
    }

    sub load {
        my $self = shift;
        if (-f $self->_index_file) {
            local $/ = undef;
            my $sereal = Sereal::Decoder->new;
            open my $fh, "<", $self->_index_file;
            my $x = <$fh>;
            close($fh);
            $self->kv( $sereal->decode($x) );
        } else {
            $self->kv({});
        }
        return $self;
    }

    sub save {
        my $self = shift;
        my $sereal = Sereal::Encoder->new;
        open my $fh, ">", $self->_index_file;
        print $fh $sereal->encode($self->kv);
        close $fh;
        return $self;
    }
};
1;
