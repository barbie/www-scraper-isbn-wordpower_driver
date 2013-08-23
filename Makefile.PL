#!/usr/bin/perl

use strict;
use warnings;
use 5.006;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Barbie <barbie@cpan.org>',
    NAME                => 'WWW::Scraper::ISBN::WordPower_Driver',
    VERSION_FROM        => 'lib/WWW/Scraper/ISBN/WordPower_Driver.pm',
    ABSTRACT            => 'Search driver for Word Power online book catalog',
    NO_META             => 1,
    PREREQ_PM           => {

        # prereqs
        'WWW::Scraper::ISBN'            => '0.25',
        'WWW::Scraper::ISBN::Driver'    => '0.18',
        'WWW::Mechanize'                => '1.60',

        # build/test prereqs
        'IO::File'                      => '0',
        'Test::More'                    => '0.70'

    }
);
