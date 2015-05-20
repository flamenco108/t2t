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
  echo "Usage: `basename $0` options -t target (-p) (-h for help) FILENAME_TO_PROCESS";
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
  echo "    This script ($0) is supposed to help in more convenient
and advanced usage of txt2tags markup conversion too in most cases 
(except of html, xhtml, txt, tex), it just shortens the command 
>> txt2tags << to >> $0 <<, whatever name you will give to this script. 
   
Usage: $0 OPTIONS FILE_TO_PROCESS
           
    -t is mandatory option and choses the txt2tags conversion target. 
    Anything except >> html, xhtml, txt, tex << will just pass it 
    to the txt2tags command. But if you chose the above targets, 
    you can also chose the option:

    -p means that you want to process the footnotes, as you used them 
    in your source file written in txt2tags markup with 
    >> ((anything as footnote )) << marks added.
           
EXAMPLES:

    $0 -t moin FILE -> will pass it to txt2tags -t moin FILE
    $0 -t html FILE -> will pass it to txt2tags -t html FILE
    $0 -t html -p FILE -> firs will find the footnotes >> (()) <<

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
if [[ ! -z $1 ]] && $flag && $tflag
then
  target=$var
  file=$1
  projdir=`basename $file .t2t`
  
  ### if you don't want to process footnotes

  if ! $foot
  then
    #clear #clear the screen to make messages visible
    echo "If you want to pass to txt2tags some other options
    (see http://txt2tags.org/manpage.html#options)
    here you can do it and press Enter (if not - then just press Enter):
    "
    read options
    echo "Sending file to txt2tags..."
    txt2tags -t $target $options $file
  fi
  
  ### if you want to process the footnotes in HTML and xhtml file

  if $foot
   then
     
     #We will do everything in separate directory
     if [[ -d $projdir ]]; then rm -rf $projdir; fi
     
     mkdir $projdir && echo "Creating the directory for the project..." 
     cp $file $projdir && echo "Copying $file to $projdir..."

     #Checking for includes inside the main file (assuming it's the called file)
     echo "BTW. Checking, if there are any included files..."
     includes=`cat $file | grep ^%\!include:`
     if [[ -z $includes ]]
     then
       echo "Didn't find any included files."
     else
       echo "Included files found:"
       echo ""
       cat $file | grep ^%\!include: | awk '{print $2}'
       echo ""
       echo "Let's copy them into the $projdir project directory..."
       echo "If they are real files of course!"
       echo ""
       for i in `cat $file | grep ^%\!include: | awk '{print $2}'`
       do 
         cp $i $projdir && echo $i " copied..."
       done
       echo "They are waiting for you in $projdir directory!"
       echo ""
       x
       echo ""
     fi
     
     cd $projdir && echo "Moving to $projdir..."
     pwd
     echo "Collecting necessary tools..."
     wget http://krzysztof.smirnow.eu/t2t/ent2t.awk && echo "Collected."
     echo "
     So, let's convert the file $1 and associates to have footnotes...
     "
     for i in `ls *.t2t`
     do
       # change dokuwiki footnote marks to eric pement's marks
       cat $i | sed 's/((/\[##\]\n\[\[\n##./g' | sed 's/))/\n\]\]\n/g' > $i-temp && cat $i-temp > $i && echo $i " prepared..." && rm $i-temp
       awk -v blank=1 -f ent2t.awk $i > $i-awktmp && cat $i-awktmp > $i && rm $i-awktmp && echo $i " converted"
     done
     echo "
     And finally: run txt2tags:
     "
     #clear #clear the screen to make messages visible
     echo "If you want to pass to txt2tags some other options
     (see http://txt2tags.org/manpage.html#options)
     here you can do it and press Enter (if not - then just press Enter):
     "
     read options
     echo "Sending file to txt2tags..."
     txt2tags -t $target $options $file
     #Cleaning up
     rm ent2t.awk
     # and...
     cd -
  fi

fi

echo "=========================================
End of script
"
