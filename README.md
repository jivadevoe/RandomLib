RandomLib
=========

A collection of utility categories and classes that I use in my iOS and Mac development.

Introduction
============

This is a collection of classes and categories that I use when I do iOS & Mac development. I make no guarantees that any of it is good, or that is even functional.  I am making it available to the public partly as a public service, and partly so that I can easily reuse it and reference it for other projects that I do.

This is the first cut on this.  I have a BUNCH more I'll be adding in coming months, but this was stuff I needed to get out there now.  Feel free to check back later and see what's new!

Warning
=======

You may see that my category methods do not have prefixes. Additionally, you may see some categories that could be borderline dangerous.  You may see some less than perfect code.  It may even have bugs.  This code is not meant as an example of good coding practices.  It's just a collection of code that is tried and true, and mostly works, and which I use in my own apps.

In short... your mileage may vary.  Offer void where prohibited.  Complaints = Pull Request or GTFO.

Pull Requests
=============

Although I appreciate and welcome pull requests, I have a fairly large codebase which already uses this code successfully. Therefore, if you send me a pull request, I would appreciate it if your pull request does not include anything that might make existing code break.  Things like changing method names (to add prefixes for example) and so on, will simply not be useful to me.

Usage
=====

This code is designed to be copied and included in your application projects.  You can, for the most part, include as much or as little as you want.  Almost all the modules stand alone or have only one or two dependencies.

HTML Documentation generated from appledoc can be found in the `/Docs` directory.  Additionally, there's a gendoc.sh file which will regenerate the html docs and which will also generate an Xcode docset and install it on your machine if you wish.

BTW, if anyone knows a way to get Appledoc to generate docs that are easily browseable from github, please tell me.

LICENSE
=======

Copyright (C) 2012 by Random Ideas, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
