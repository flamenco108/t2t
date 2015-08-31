# t2t

## Description

Lack of footnotes processing in txt2tags is the pain in the ass.

So I decided to do something with it. As I'm not a programmer, it's perhaps clumsy, but it works and perhpas some people would find it useful.

It's a bash script. If I learn to code in python, I will try to rewrite it, but it will not happen soon.

### It's for html & xhtml

The main purpose of this script is to create footnotes (or rather, endnotes, as they appear at the end of the file) for html and xhtml target formats. For LaTeX target there is separate %!postproc rule in my config file. Secondary purpose is to shorten the unconvinient command `txt2tags` just to `t2t`, although it can be done by `alias` command in shell. But alias will not attach the fully prepared config file and css-style. Well, txt2tags can do it by itself, but not it's not so funny to use built-in options of the program doesn't it?

So, in next generations of the script I'm going to add my config file and css to be automagically, optionally attached to the document.


## Requirements

* txt2tags (of course)
* awk

## Usage

`./t2t.sh -t target (-p) FILE`


-t is mandatory option and choses the txt2tags conversion target. Anything except **html, xhtml, txt, tex** will just pass it
to the txt2tags command. But if you chose the above targets, you can also chose the option:

-p means that you want to process the footnotes, as you used them in your source file written in txt2tags markup with **((anything as footnote ))** marks added.

### EXAMPLES:

* `./t2t.sh -t moin FILE` -> will pass it to `txt2tags -t moin FILE`
* `./t2t.sh -t html FILE` -> will pass it to `txt2tags -t html FILE`
* `./t2t.sh -t html -p FILE` -> first will find the footnotes **(())** and then change them into proper notation for awk script, and then will pass it to `txt2tags -t html FILE`
* `./t2t.sh -t epub -p FILE -> first will find the footnotes >> (()) <<`
* `./t2t.sh -t epub FILE -> it will converted to mardown and then converted`


