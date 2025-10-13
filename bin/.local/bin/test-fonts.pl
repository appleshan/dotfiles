#test-fonts.pl
# @See https://github.com/polybar/polybar/wiki/Fonts

# Note: maybe you need to install "Font::FreeType" module for the Script to work:
# $ perl -MCPAN -e 'install Font::FreeType'

# Usage: perl test-fonts.pl "😀"

use strict;
use warnings;
use Font::FreeType;
my ($char) = @ARGV;
foreach my $font_def (`fc-list`) {
    my ($file, $name) = split(/: /, $font_def);
    my $face = Font::FreeType->new->face($file);
    my $glyph = $face->glyph_from_char($char);
    if ($glyph) {
        print $font_def;
    }
}
