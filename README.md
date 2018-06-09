# delimctr / delimchk

delimctr
--------

Bash script to check and count mismatching delimiters `(),[],{}` in a `.tex` file.

To download `delimctr.sh`, open a terminal and type:

`wget https://raw.githubusercontent.com/tmelorc/delimctr/master/delimctr.sh`

Then, assign execute permission to it with `chmod +x delimctr.sh`.

Usage: `./delimctr [OPTIONS] [FILE]` where `[FILE]` is any `.tex` file (in fact, plain text file) and `[OPTIONS]` can be:

  - `-i` to ignore commented lines (beginning with `%`)
  
  - `-c` to disable colour

To run `delimctr.sh` from any path, move the script to `bin` folder with

`sudo mv delimctr.sh /usr/local/bin`

and restart the terminal. After, simply use as `delimctr [OPTIONS] [FILE]`.

delimchk
--------

Python script to check mismatching delimiters `(),[],{}` in a `.tex` file. It differs from `delimctr` in the capability to show the non matching delimiters.

(...in progress)
