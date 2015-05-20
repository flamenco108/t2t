# t2t

Lack of footnotes processing in txt2tags is the pain in the ass.

So I decided to do something with it. As I'm not a programmer, it's perhaps clumsy, but it works and perhpas some people would find it useful.

It's a bash script. If I learn to code in python, I will try to rewrite it, but it will not happen soon.

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
