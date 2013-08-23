#!/usr/bin/perl -w
use strict;

use lib './t';
use Test::More tests => 40;
use WWW::Scraper::ISBN;

###########################################################

my $DRIVER          = 'WordPower';
my $CHECK_DOMAIN    = 'www.google.com';

my %tests = (
    '1846057132' => [
        [ 'is',     'isbn',         '9781846057137' ],
        [ 'is',     'isbn10',       '1846057132'    ],
        [ 'is',     'isbn13',       '9781846057137' ],
        [ 'is',     'ean13',        '9781846057137' ],
        [ 'is',     'title',        'Ford County'   ],
        [ 'is',     'author',       'John Grisham'  ],
        [ 'is',     'publisher',    'Century'       ],
        [ 'is',     'pubdate',      '03/11/2009'    ],
        [ 'is',     'binding',      'Hardback'      ],
        [ 'is',     'pages',        '320'           ],
        [ 'is',     'width',        '159'           ],
        [ 'is',     'height',       '241'           ],
        [ 'is',     'weight',       '556'           ],
        [ 'like',   'image_link',   qr|/product_images/9781846057137.jpg| ],
        [ 'like',   'thumb_link',   qr|/product_images/9781846057137.jpg| ],
        [ 'like',   'description',  qr|John Grisham takes you into the heart of America's Deep South| ],
        [ 'like',   'book_link',    qr|http://www.word-power.co.uk/books/ford-county-I9781846057137/| ]
    ],
    '9780571239566' => [
        [ 'is',     'isbn',         '9780571239566'     ],
        [ 'is',     'isbn10',       '0571239560'        ],
        [ 'is',     'isbn13',       '9780571239566'     ],
        [ 'is',     'ean13',        '9780571239566'     ],
        [ 'is',     'title',        'Touching from a Distance'  ],
        [ 'is',     'author',       'Deborah Curtis'    ],
        [ 'is',     'publisher',    'Faber and Faber'   ],
        [ 'is',     'pubdate',      '04/10/2007'        ],
        [ 'is',     'binding',      'Paperback'         ],
        [ 'is',     'pages',        240                 ],
        [ 'is',     'width',        129                 ],
        [ 'is',     'height',       198                 ],
        [ 'is',     'weight',       200                 ],
        [ 'like',   'image_link',   qr|/product_images/9780571239566.jpg| ],
        [ 'like',   'thumb_link',   qr|/product_images/9780571239566.jpg| ],
        [ 'like',   'description',  qr|Ian Curtis left behind a legacy rich in artistic genius| ],
        [ 'like',   'book_link',    qr|http://www.word-power.co.uk/books/touching-from-a-distance-I9780571239566/| ]
    ],
    
);

my $tests = 0;
for my $isbn (keys %tests) { $tests += scalar( @{ $tests{$isbn} } ) + 2 }


###########################################################

my $scraper = WWW::Scraper::ISBN->new();
isa_ok($scraper,'WWW::Scraper::ISBN');

SKIP: {
	skip "Can't see a network connection", $tests+1   if(pingtest($CHECK_DOMAIN));

	$scraper->drivers($DRIVER);

    # this ISBN doesn't exist
	my $isbn = "1234567890";
    my $record;
    eval { $record = $scraper->search($isbn); };
    if($@) {
        like($@,qr/Invalid ISBN specified/);
    }
    elsif($record->found) {
        ok(0,'Unexpectedly found a non-existent book');
    } else {
		like($record->error,qr/Failed to find that book|website appears to be unavailable/);
    }

    for my $isbn (keys %tests) {
        $record = $scraper->search($isbn);
        my $error  = $record->error || '';

        SKIP: {
            skip "Website unavailable", scalar(@{ $tests{$isbn} }) + 2   
                if($error =~ /website appears to be unavailable/);
            skip "Book unavailable", scalar(@{ $tests{$isbn} }) + 2   
                if($error =~ /Failed to find that book/ || !$record->found);

            unless($record->found) {
                diag($record->error);
            }

            is($record->found,1);
            is($record->found_in,$DRIVER);

            my $book = $record->book;
            for my $test (@{ $tests{$isbn} }) {
                if($test->[0] eq 'ok')          { ok(       $book->{$test->[1]},             ".. '$test->[1]' found [$isbn]"); } 
                elsif($test->[0] eq 'is')       { is(       $book->{$test->[1]}, $test->[2], ".. '$test->[1]' found [$isbn]"); } 
                elsif($test->[0] eq 'isnt')     { isnt(     $book->{$test->[1]}, $test->[2], ".. '$test->[1]' found [$isbn]"); } 
                elsif($test->[0] eq 'like')     { like(     $book->{$test->[1]}, $test->[2], ".. '$test->[1]' found [$isbn]"); } 
                elsif($test->[0] eq 'unlike')   { unlike(   $book->{$test->[1]}, $test->[2], ".. '$test->[1]' found [$isbn]"); }

            }

            #use Data::Dumper;
            #diag("book=[".Dumper($book)."]");
        }
    }
}

###########################################################

# crude, but it'll hopefully do ;)
sub pingtest {
    my $domain = shift or return 0;
    my $cmd =   $^O =~ /solaris/i                           ? "ping -s $domain 56 1" :
                $^O =~ /dos|os2|mswin32|netware|cygwin/i    ? "ping -n 1 $domain "
                                                            : "ping -c 1 $domain >/dev/null 2>&1";

    eval { system($cmd) }; 
    if($@) {                # can't find ping, or wrong arguments?
        diag();
        return 1;
    }

    my $retcode = $? >> 8;  # ping returns 1 if unable to connect
    return $retcode;
}
