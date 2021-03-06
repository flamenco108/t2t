# Filename: endnote.awk
#   Author: Eric Pement - pemente [=at=] northpark.edu
#  Version: 1.3
#     Date: Copyleft 2002 by Eric Pement. Revised 2005-06-18.
#  Purpose: To convert in-text notes and references to endnotes
# Requires: GNU awk; blank lines between paragraphs of input file
#
#    Usage: awk [-options] -f endnote.awk source.txt >target.txt
#  Options:   -v start=7   # begin numbering with note #7
#             -v blank=0   # do not delete blank lines after note blocks
#
#   Output: Plain ASCII text.
# See also: ENDNOTE.TXT, which further explains usage and application.
#           http://www.pement.org/awk/endnote_v13.txt
#
#    To do: check for mismatched "[[" and "]]" braces.
#
#  Credits: The idea for this endnote system was borrowed from "wsNOTE"
#           by Eric Meyer, a 1988 MS-DOS utility for managing footnotes
#           in WordStar files. His program offered many extra features.


BEGIN {
  if ( start != start + 0 ) {
    print "\aError!\nVariable ``start'' was set as ``" start "''. It",
    "must be a numeric value!"
    exit
  }
  a=b= (start == "" ? 0 : start - 1) # Initialize some variables
  str = ""
}

/^\[\[ *$/,/^]] *$/ {       # If between [[ and ]] markers ..

  if ( /^\[\[ *$/ ) next    # .. skip the [[ marker
  if ( /^\.\./ ) next       # .. skip comment lines, ^..
  if ( /^\?\?/ ) next       # .. skip comment lines, ^??

  if (blank && /^]] *$/) {  # .. Old default: On ']]', just kill
    next                    #      the current line.
  } else if (/^]] *$/) {    # .. New default: On ']]', delete this
    getline                 #      line and the next one, too.
    next                    
  }
                            # .. increment a or '##.' in note block % krzysio
  #if (!sub(/\#\#\./, ++a "."))
  if (!sub(/\#\#\./, "===== "++a ". =====["a"endnote]\n"))
    --a;
  str = str $0 "\n\n"        # .. store line in the 'str' accumulator
  next                     # .. get next input line (works like ELSE)
}

{                          # If not between the [[ and ]] markers ..
  while(sub(/\[##]/, "^^[" ++b " #"b"endnote]^^")) ;  # .. increment each "##" for 'b' % krzysio
  --b;                     # adjust for ++b when RE did not match
  print;                    # .. and print that line.
  #print "\n"
}

END {                      # Error checking.
  if (start != start+0)
    exit                   # Prevent ENDNOTES from printing on err
  if ( a != b ) {          # Do nums match? "\a\a" beeps the console
    bdy = (start ? b - start : b )
    nts = (start ? a - start : a )
    print "\a\a" >> "/dev/stderr"
    print "\n\n\n================\n    WARNING!\n================";
    print "Body text numbers and Endnote numbers don't match!";
    print "You have", bdy, "notes in the Body text and", nts, "notes";
    print "in the Endnote section.";
    print "The Endnote section will not be printed.\n\n";
  } else {
    print "\n\n----------------------\n\n= PRZYPISY: =\n'''\n<div class=\"footnote\">\n'''\n" str "'''\n</div>\n'''\n%% end of file %%"
  }
}
#---end of script---

