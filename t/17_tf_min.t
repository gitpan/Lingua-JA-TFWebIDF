use strict;
use warnings;
use utf8;
use Lingua::JA::TFWebIDF;
use Test::More;

binmode Test::More->builder->$_ => ':utf8'
    for qw/output failure_output todo_output/;


my $tfidf = Lingua::JA::TFWebIDF->new(
    appid             => 'test',
    driver            => 'Storable',
    df_file           => './df/flagged_utf8.st',
    fetch_df          => 0,
    pos1_filter       => [],
    pos2_filter       => [],
    pos3_filter       => [],
    ng_word           => [],
    tf_min            => 4,
    term_length_min   => 1,
    concat_max        => 0,
);

my %tf = (
    '自然言語処理' => 9,
    '自然言語'     => 6,
    '自然言語理解' => 4,
    '処理'         => 5,
    '解析'         => 4,
    '理解'         => 7,
    '課題'         => 4,
    '意味'         => 4,
    '技術'         => 4,
    '世界'         => 3,
    '表'           => 5,
);


ok(  grep { $_ eq '技術' } fetch_term( $tfidf->tfidf(\%tf)->list(20) ) );
ok( !grep { $_ eq '世界' } fetch_term( $tfidf->tfidf(\%tf)->list(20) ) );

# xt/17_term_length_min.t
#ok( !grep { $_ eq 'XXX' } fetch_term( $tfidf->tfidf("XXX")->list(20) ) );
#ok(  grep { $_ eq 'XXX' } fetch_term( $tfidf->tfidf("XXX")->list(20) ) );

done_testing;


sub fetch_term
{
    my $results = shift;

    my @terms;

    for my $result (@{$results})
    {
        my ($word, $score) = each %{$result};

        push(@terms, $word);
    }

    return @terms;
}
