#!/bin/bash

clear

#echo "Liczba argumentów: "&#
#echo ""

# -t flags
tflag=false
flag=false
# -p flag
foot=false
# -h flag
yelp=false

if ( ! getopts "pt:h" opt); then
  echo ""
  echo "Usage: `basename $0` options -t target (-p) (-h for help) FILENAME_TO_PROCESS";
  echo ""
  exit $E_OPTERROR;
fi

while getopts ":pt:h" opt; do
     case $opt in
         p) 
           #echo "-p means, that you want to process footnotes."
           foot=true
           echo "Prepare to process the footnotes..."
           ;;
         t) var=$OPTARG
           flag=true
           tflag=true
           echo "-t triggered, option $var!"
           #echo "-t chooses the target of txt2tags"
           ;;
         h) 
           #echo "This is the help area!"
           flag=true
           tflag=false
           yelp=true
           ;;
         \?)
           echo "Unknown option: -$OPTARG" >&2
           exit 1
           ;;
         :)
           echo "Missing option argument for -$OPTARG" >&2
           exit 1
           ;;
         *)
           echo "Unimplemented option: -$OPTARG" >&2
           exit 1
           ;;
     esac
done

#shifting files $@ to process
shift $(($OPTIND -1))


#if $@ and it's not help call
if [[ -z $1 ]] && [[ -z $yelp ]]
then
  echo "You must chose the file to process!" >&2
fi

#if $1 is chosen
if [[ ! -z $1 ]]
then
  echo "File $1 chosen. GOOD, let's work."
fi

### HELP ###
#if $1 is not chosen, but help is called - show help
if [[ ! -z $yelp ]] && [[ -z $1 ]]
then
  echo "=============================================================================
  "
  echo "   HELP: 
This script ($0) is supposed to help in more convenient
and advanced usage of txt2tags markup conversion too in most cases 
(except of html, xhtml, txt, tex), it just shortens the command 
>> txt2tags << to >> $0 <<, whatever name you will give to this script.

In several cases, especially when there is a wish to process footnotes, 
this script uses pandoc to generate the final document. Look below.

This script will also add, when it's needed, the css stylesheet
with styles adequate to Polish typography rules, so if you don't like it,
you should change it.
   
Basic usage: $0 OPTIONS FILE_TO_PROCESS
           
    -t is mandatory option and choses the txt2tags conversion target. 
    Any format from txt2tags inventory except: 
    >> html, xhtml, txt, tex, epub << 
    will just pass it to the txt2tags command. 
    But if you chose the above targets, you can also chose the option:

    -p means that you want to process the footnotes, as you used them 
    in your source file written in txt2tags markup with double brackets,
    such as >> ((anything as footnote)) << marks added.
           
EXAMPLES:

    $0 -t moin FILE -> will pass it to txt2tags -t moin FILE
    $0 -t html FILE -> will pass it to txt2tags -t html FILE
    $0 -t html -p FILE -> first will find the footnotes >> (()) <<
    $0 -t epub -p FILE -> first will find the footnotes >> (()) <<
    $0 -t epub FILE -> it will converted to mardown and then converted
    by pandoc to epub

       "
  echo "=============================================================================
           
       "
  echo "This was the help option."
fi


if ! $flag && ! $tflag
then
  #show message and exit with error
  echo "Option -t must be triggered, and target must be chosen!" >&2
  exit 1
fi

########################################################
##########              WORK              ##############
########################################################
# if the file and the target are chosen
if [[ ! -z $1 ]] && $flag && $tflag ; then
  TARGET=$var && echo "target= "$TARGET
  ARG=$1
  NAZWA=`basename "${ARG}"` && echo "nazwa= "$NAZWA
  SCIEZKA=${ARG%/*}
  if [ $SCIEZKA == $NAZWA ]; then 
    SCIEZKA="./";
  fi;
  echo "sciezka= "$SCIEZKA
  DOM=`pwd` && echo "dom= "$DOM
  NAME=`echo "$NAZWA" | cut -d'.' -f1` && echo "name= "$NAME
  EXTENSION=`echo "$NAZWA" | cut -d'.' -f2` && echo "extension= " $EXTENSION
  PROJDIR=$NAME && echo "projdir= "$PROJDIR
  
  cd $SCIEZKA && echo "Change directory to $SCIEZKA" && pwd
  
  ### if you don't want to process footnotes
  echo "foot= "$foot

  if [[ "$foot" = false ]]; then
    #clear #clear the screen to make messages visible
    echo "No footnotes declared, let's convert only via txt2tags!
    "    
    case $TARGET in
      epub|odt|docx|rst) echo "$TARGET chosen, although there are no footnotes, sending to pandoc."
        $foot=true
        ;;
      txt|text) echo "$TARGET chosen, sending to txt2tags.
        Keep in mind, that if you want Restructured Text,
        you should chose the >> rst << target."
        echo ""
        echo "If you want to pass to txt2tags some other options
        (see http://txt2tags.org/manpage.html#options)
        here you can do it and press Enter (if not - then just press Enter):
        "
        read options
        echo "Sending file to txt2tags..."
        txt2tags -t txt $options $NAZWA
        ;;
      htm|html)  echo "$TARGET chosen, sending to txt2tags.
        "
        echo "If you want to pass to txt2tags some other options
        (see http://txt2tags.org/manpage.html#options)
        here you can do it and press Enter (if not - then just press Enter):
        "
        read options
        echo "Sending file to txt2tags..."
        txt2tags -t html $options $NAZWA
        ;;
        xhtm|xht|xhtml) echo "$TARGET chosen, sending to txt2tags.
        "
        echo "If you want to pass to txt2tags some other options
        (see http://txt2tags.org/manpage.html#options)
        here you can do it and press Enter (if not - then just press Enter):
        "
        read options
        echo "Sending file to txt2tags..."
        txt2tags -t xhtml $options $NAZWA
        ;;


      *) echo "$TARGET chosen, no footnotes, sending to txt2tags."
        echo ""
        echo "If you want to pass to txt2tags some other options
        (see http://txt2tags.org/manpage.html#options)
        here you can do it and press Enter (if not - then just press Enter):
        "
        read options
        echo "Sending file to txt2tags..."
        txt2tags -t $TARGET $options $NAZWA
        ;;
    esac
  fi
  
  ### if you want to process the footnotes in HTML and xhtml file

  if [[ "$foot" = true ]]
   then
     
     #We will do everything in separate directory
     if [[ -d $PROJDIR ]]; then rm -rf $PROJDIR; fi
     
     mkdir $PROJDIR && echo "Creating the directory for the project..." 
     cp $NAZWA $PROJDIR && echo "Copying $file to $PROJDIR..."

     #Checking for includes inside the main file (assuming it's the called file)
     echo "BTW. Checking, if there are any included files..."
     includes=`cat $NAZWA | grep ^%\!include:`
     if [[ -z $includes ]]
     then
       echo "Didn't find any included files."
     else
       echo "Included files found:"
       echo ""
       cat $NAZWA | grep ^%\!include: | awk '{print $2}'
       echo ""
       echo "Let's copy them into the $PROJDIR project directory..."
       echo "If they are real files of course!"
       echo ""
       for i in `cat $NAZWA | grep ^%\!include: | awk '{print $2}'`
       do 
         cp $i $PROJDIR && echo $i " copied..."
       done
       echo "They are waiting for you in $PROJDIR directory!"
       echo ""
       
       echo ""
     fi
     
     cd $PROJDIR && echo "Moving to $PROJDIR..."
     pwd
     
     #echo "
     #So, let's convert the file $1 and associates to have footnotes...
     #"
     #for i in `ls *.t2t`
     #do
     #  # change dokuwiki footnote marks to eric pement's marks
     #  cat $i | sed 's/((/\[##\]\n\[\[\n##./g' | sed 's/))/\n\]\]\n/g' > $i-temp && cat $i-temp > $i && echo $i " prepared..." && rm $i-temp
     #  awk -v blank=1 -f ent2t.awk $i > $i-awktmp && cat $i-awktmp > $i && rm $i-awktmp && echo $i " converted"
     #done
     
     #clear #clear the screen to make messages visible
     echo "If you want to pass to txt2tags some other options
     (see http://txt2tags.org/manpage.html#options)
     here you can do it and press Enter (if not - then just press Enter):
     "
     read options
     echo "Sending $NAZWA to txt2tags..."

     #txt2tags -t md $options $file
     MD=$NAME".md";TEMD=$NAME".temp"
     txt2tags -t md $options $NAZWA && echo "Convert $NAZWA Txt2tags file to $MD Markdown file"
     echo "----------"
     cat $MD | sed '1s/^\(.*\)$/%\1/' | sed '2s/^\(.*\)$/%\1/' | sed '3s/^\(.*\)/%\1/' > $TEMD && echo "Correcting author and title in $MD" && mv $TEMD $MD
     #cat $MD | sed '1s/^\(.*\)$/%\1/' > $MD  && echo "Correcting title in $MD"
     wc -l $MD
     echo "";echo "---";echo ""
     head -3 $MD


     echo "------------"
     echo "Attention! Here we will do conversion by pandoc!
     First the file $NAZWA will be converted to Markdown,
     and then to $TARGET target format.
     If you want to pass to pandoc some other options
     (see http://pandoc.org/demo/example9/pandocs-markdown.html)
     here you can do it and press Enter (if not - then just press Enter):
     "
     read options
     echo "Sending $NAZWA to pandoc..."

### Conversion though PANDOC ###

     case $TARGET in
       htm|html|ht) TARGET=html
         pandoc -f markdown+inline_notes+pandoc_title_block $options -t $TARGET $MD -o $NAME".$TARGET" && echo "Done"
         STAND=$NAME"_standalone" && mkdir $STAND && cd $STAND
         wget http://krzysztof.smirnow.eu/t2t/style-include.css
         pandoc -s -S --toc -H style-include.css -f markdown+inline_notes+pandoc_title_block $options -t $TARGET ../$MD -o $NAME".$TARGET" && echo "Standal->->->done" && cd ..
     echo ""
         ;;

       xht|xhtml|xhtm) TARGET=xhtml
         pandoc -f markdown+inline_notes+pandoc_title_block $options -t $TARGET $MD -o $NAME".$TARGET" && echo "Done"
         STAND=$NAME"_standalone" && mkdir $STAND && cd $STAND
         wget http://krzysztof.smirnow.eu/t2t/style-include.css
         pandoc -s -S --toc -H style-include.css -f markdown+inline_notes+pandoc_title_block $options -t $TARGET ../$MD -o $NAME".$TARGET" && echo "Standal->->->done" && cd ..
     echo ""
         ;;

       epub) echo "Doing EPUB..."
         STAND=$NAME"_standalone" && mkdir $STAND && cd $STAND
         wget http://krzysztof.smirnow.eu/t2t/style.css
         cp style.css epub.css
         pandoc -s -S --toc --data-dir=./ -f markdown+inline_notes+pandoc_title_block $options -t $TARGET ../$MD -o $NAME".$TARGET" && echo "Standal->->->done" && cd ..
         ;;
       *) echo "Doing $TARGET..."
         STAND=$NAME"_standalone" && mkdir $STAND && cd $STAND
         wget http://krzysztof.smirnow.eu/t2t/style-include.css
         pandoc -s -S --toc -H style-include.css -f markdown+inline_notes+pandoc_title_block $options -t $TARGET ../$MD -o $NAME".$TARGET" && echo "Standal->->->done" && cd ..

     esac



     #txt2tags -t $TARGET $options $file
     #Cleaning up
     #rm ent2t.awk
     # and...

     cd $DOM
  fi

fi

echo "=========================================
End of script
"
