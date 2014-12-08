use v5.18;
package Iid::Index {
    use Mo qw'default';
    use File::Spec::Functions qw'catfile';
    use Sereal::Encoder;
    use Sereal::Decoder;

    has 'name';
    has 'directory';
    has kv => ( default => sub { {} } );

    sub _insert {
        my ($arr, $v) = @_;
        if (@$arr == 0) {
            push(@$arr, $v);
            return 1;
        }
        my ($min, $max) = (0, $#$arr+1);
        my $i = int(($max+$min)/2);
        my $step = $i;
        while ($min+1 < $max) {
            if ($v eq $arr->[$i]) {
                return;
            } elsif ($v lt $arr->[$i]) {
                $max = $i;
            } else {
                $min = $i;
            }
            $i = int(($max+$min)/2);
        }
        @{$arr}[$min..$#$arr+1] = (@{$arr}[$min .. $i], $v, @{$arr}[$i+1..$#$arr]);
        return 1;
    }

    sub add {
        my ($self, $id, $terms) = @_;
        for my $term (@$terms) {
            my $t = $self->kv->{terms}{$term} //= {df=>0,tf=>0,docs=>[]};
            $t->{tf}++;
            $t->{df}++ if _insert($t->{docs}, $id);
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
