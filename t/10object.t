#!/usr/bin/perl -w
use strict;

use lib './t';
use Test::More tests => 59;
use WWW::Scraper::ISBN;

###########################################################

my $CHECK_DOMAIN = 'www.google.com';

my $scraper = WWW::Scraper::ISBN->new();
isa_ok($scraper,'WWW::Scraper::ISBN');

SKIP: {
	skip "Can't see a network connection", 58   if(pingtest($CHECK_DOMAIN));

	$scraper->drivers("WordPower");

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
		like($record->error,qr/Failed to find that book on WordPower website|website appears to be unavailable/);
    }

	$isbn = "1846057132";
	$record = $scraper->search($isbn);
    my $error  = $record->error || '';

    SKIP: {
        skip "Website unavailable", 19   if($error =~ /website appears to be unavailable/);

        unless($record->found) {
            diag("ERROR: [$isbn] ".$record->error);
        }
        
        {
            is($record->found,1);
            is($record->found_in,'WordPower');

            my $book = $record->book;
            is($book->{'isbn'},         '9781846057137'         ,'.. isbn found');
            is($book->{'isbn10'},       '1846057132'            ,'.. isbn10 found');
            is($book->{'isbn13'},       '9781846057137'         ,'.. isbn13 found');
            is($book->{'ean13'},        '9781846057137'         ,'.. ean13 found');
            is($book->{'title'},        'Ford County'           ,'.. title found');
            is($book->{'author'},       'John Grisham'          ,'.. author found');
            like($book->{'book_link'},  qr|http://www.word-power.co.uk/books/ford-county-I9781846057137/|);
            is($book->{'image_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9781846057137.jpg');
            is($book->{'thumb_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9781846057137.jpg');
            like($book->{'description'},qr|John Grisham takes you into the heart of America's Deep South|);
            is($book->{'publisher'},    'Century'               ,'.. publisher found');
            is($book->{'pubdate'},      '03/11/2009'            ,'.. pubdate found');
            is($book->{'binding'},      'Hardback'              ,'.. binding found');
            is($book->{'pages'},        '320'                   ,'.. pages found');
            is($book->{'width'},        '159'                   ,'.. width found');
            is($book->{'height'},       '241'                   ,'.. height found');
            is($book->{'weight'},       '556'                   ,'.. weight found');
        }
    }

	$isbn   = "9780007203055";
	$record = $scraper->search($isbn);
    $error  = $record->error || '';

    SKIP: {
        skip "Website unavailable", 19   if($error =~ /website appears to be unavailable/);

        unless($record->found) {
            diag("ERROR: [$isbn] ".$record->error);
        }
        
        {
            is($record->found,1);
            is($record->found_in,'WordPower');

            my $book = $record->book;
            is($book->{'isbn'},         '9780007203055'         ,'.. isbn found');
            is($book->{'isbn10'},       '7203055'               ,'.. isbn10 found');
            is($book->{'isbn13'},       '9780007203055'         ,'.. isbn13 found');
            is($book->{'ean13'},        '9780007203055'         ,'.. ean13 found');
            like($book->{'author'},     qr/Simon Ball/          ,'.. author found');
            like($book->{'title'},      qr|The Bitter Sea|      ,'.. title found');
            like($book->{'book_link'},  qr|http://www.word-power.co.uk/books/the-bitter-sea-I9780007203055/|);
            is($book->{'image_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9780007203055.jpg');
            is($book->{'thumb_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9780007203055.jpg');
            like($book->{'description'},qr|A gripping history of the Mediterranean campaigns|);
            is($book->{'publisher'},    'HarperPress'           ,'.. publisher found');
            is($book->{'pubdate'},      '01/04/2010'            ,'.. pubdate found');
            is($book->{'binding'},      'Paperback'             ,'.. binding found');
            is($book->{'pages'},        416                     ,'.. pages found');
            is($book->{'width'},        130                     ,'.. width found');
            is($book->{'height'},       197                     ,'.. height found');
            is($book->{'weight'},       312                     ,'.. weight found');

            #use Data::Dumper;
            #diag("book=[".Dumper($book)."]");
        }
    }
    
    $isbn   = "9780571239566";
	$record = $scraper->search($isbn);
    $error  = $record->error || '';

    SKIP: {
        skip "Website unavailable", 19   if($error =~ /website appears to be unavailable/);

        unless($record->found) {
            diag("ERROR: [$isbn] ".$record->error);
        }
        
        {
            is($record->found,1);
            is($record->found_in,'WordPower');

            my $book = $record->book;
            is($book->{'isbn'},         '9780571239566'         ,'.. isbn found');
            is($book->{'isbn10'},       '571239560'             ,'.. isbn10 found');
            is($book->{'isbn13'},       '9780571239566'         ,'.. isbn13 found');
            is($book->{'ean13'},        '9780571239566'         ,'.. ean13 found');
            is($book->{'author'},       q|Deborah Curtis|       ,'.. author found');
            is($book->{'title'},        q|Touching from a Distance| ,'.. title found');
            like($book->{'book_link'},  qr|http://www.word-power.co.uk/books/touching-from-a-distance-I9780571239566/|);
            is($book->{'image_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9780571239566.jpg');
            is($book->{'thumb_link'},   'http://server40136.uk2net.com/~wpower/images/product_images/9780571239566.jpg');
            like($book->{'description'},qr|Ian Curtis left behind a legacy rich in artistic genius|);
            is($book->{'publisher'},    'Faber and Faber'       ,'.. publisher found');
            is($book->{'pubdate'},      '04/10/2007'            ,'.. pubdate found');
            is($book->{'binding'},      'Paperback'             ,'.. binding found');
            is($book->{'pages'},        240                     ,'.. pages found');
            is($book->{'width'},        129                     ,'.. width found');
            is($book->{'height'},       198                     ,'.. height found');
            is($book->{'weight'},       200                     ,'.. weight found');

            #use Data::Dumper;
            #diag("book=[".Dumper($book)."]");
        }
    }
}

###########################################################

# crude, but it'll hopefully do ;)
sub pingtest {
    my $domain = shift or return 0;
    system("ping -q -c 1 $domain >/dev/null 2>&1");
    my $retcode = $? >> 8;
    # ping returns 1 if unable to connect
    return $retcode;
}
