use v5.18;
package Iid::PlackApp {
    use Mo qw'default';
    has 'directory';
    has 'index_pool' => (default => sub{{}});

    use JSON ();

    use constant CONTENT_TYPE_JSON => "application/json";

    sub handle_GET  {
        my ($self, $env) = @_;
        return [200,[],[]];
    }

    sub handle_PUT {
        my ($self, $env) = @_;
        return [200,[],[]];
    }

    sub handle_POST {
        my ($self, $env) = @_;

        my (undef, $index_name) = split("/", $env->{PATH_INFO});
        my $input = $env->{'psgi.input'};
        my $body = "";
        my $num_read = 0;
        my $offset = 0;
        while (my $num_read = $input->read($body, 10240, $offset)) {
            $offset += $num_read;
        }
        my $doc = JSON::decode_json($body);

        my $index = $self->index_pool->{$index_name} ||= Iid::Index->new( name => $index_name, directory => $self->directory )->load;
        if ($doc->{action} eq "index") {
            for my $doc (@{$doc->{documents}}) {
                next unless $doc->{id} && $doc->{tokens} && !ref($doc->{id}) && ref($doc->{tokens}) eq 'ARRAY';
                $index->add( $doc->{id}, $doc->{tokens} );
            }            
        } elsif ($doc->{action} eq "load") {
            $index->load;
        } elsif ($doc->{action} eq "save") {
            $index->save;
        }

        return [200,['Content-Type' => CONTENT_TYPE_JSON],['{"ok":true}']];
    }

    sub plackapperize {
        my ($self) = @_;
        return sub {
            my ($env) = @_;
            my $handle_method = "handle_" . $env->{REQUEST_METHOD};
            return ['405', [], ["I cannot handle this."]] unless $self->can($handle_method);
            return $self->$handle_method($env);
        }
    }
};
1;
