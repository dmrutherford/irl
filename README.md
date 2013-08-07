irl :: interwebs reading list
=============================

*tpo-a001-1.0.0*

A simple script for managing a reading-list of URLs in Dropbox.


***


I always find myself with far too many browser tabs open, and my various desktops covered with links I never get around to following. `irl` is an attempt to deal with that problem.

It's just a `bash` script cobbling together a bunch of mostly standard programs, so it should work anywhere *nix-y. I've tested on Linux and OS X, but not on Cygwin.


Using irl
---------

There's nothing much to it:

    irl -i               initialise irl
        -l               show current reading list (default)
        -o [item no.]    open specified item in browser
        -a [url]         add an item to the reading list
        -r [item no.]    remove specified item from the reading list
        -y               show the archive
        -v [item no.]    open the specified archived item
        -p               purge archive
        -h               show available commands

By default, `irl` initialises itself in a subfolder of Dropbox named `.irl`. If you don't use Dropbox, or you just don't want `irl` to save your links there, then you can simply change the relevant path in the script. The variables are right at the top.

If you want to use `irl` to manage lists of stuff other than URLs, go hog wild.

`irl` will maintain a handy archive of every link you've ever entered into it. It would have been really simple to make it simultaneously add links to the main list and the archive, but I decided to go the more finicky route of adding links to the archive only when they are removed from the main list. You can view the archive with `-y`, open links from the archive with `-v`, and purge the archive with `-p`. By purge I literally mean purge: it will wipe it out, irrevocably, and leave you with a blank slate. If you want more fine-grained control, then tough cheddar. Although since everything is just stored in plain text files, you can just edit it with `nano` or whatever anyway. So yeah.


Gotchas
-------

1.  **Check your Dropbox path**

    IIRC, Dropbox normally creates its folder under the `Documents` folder. Since most of the things I keep in Dropbox are not 'documents', and I like to keep my paths as short as is sensibly possible, I keep my Dropbox folder immediately under my home folder.

    If you use the default Dropbox location, you'll need to tweak the appropriate path. Again, it's right at the top of the script.

2.  **Automatic copying may not work**

    If you don't pass any arguments to `irl` with the command `-a`, it will attempt to add whatever is on your clipboard. On OS X, this uses `pbpaste`, and definitely works. On Linux, it will try either `xclip` or `xsel`. I haven't actually tested with either, so who knows if that works.

    Additionally, I haven't checked what happens if the contents of the clipboard are not a chunck of text. Sue me.


Wishlist
--------

At some point I will get around to allowing multiple links to be added simultaneously using `irl -a`. Probably quite soon, as this is an obvious feature that I should have included from the start.

I am vaguely considering implementing some sort of regex to check that what you're entering does actually resemble a URL. There are two things holding me back:

1.  Regex. Ugh.
2.  If you want to use `irl` to manage lists of things other than URLs, it would be a little frustrating if it refused to manage anything other than URLs.

If I ever do implement this -- and I almost certainly won't -- it will probably only be applied to clipboard contents when running `irl -a` without any arguments. Even then it could get annoying, so we'll see...

At the moment, `irl` uses `getopts` to parse commands. It took me a surprisingly long time to notice that this is *not* the same as using `getopt`. I'd prefer to use `getopt`, since it's a little more versatile, but I have never got it to play nice on OS X. Since I need `irl` to support both Linux and OS X, `getopts` it is.


Copyright & Contact
-------------------

Consider `irl` public domain. It's not exactly sophisticated, so there's not much to patent anyway. Although these days that hardly seems to be a stumbling block.

Comments and constructive criticisms to [david@dmrutherford.com](mailto:david@dmrutherford.com), or [hit me up on Twitter](https://twitter.com/DMRutherford).
