nginx-toolbox
=============

Collection of bash scripts for an nginx server running on Ubuntu 10.4 (Lucid)


Install
-------

If you haven't already, you must install nginx on your server via `apt-get`:

`apt-get install nginx`

Then, clone this repo to your server:

`git clone git@github.com:a1phanumeric/nginx-toolbox.git`

`cd` into the directory `nginx-toolbox` and ensure that all `.sh` scripts have execute privilages.


Usage
-----

There are only a couple of scripts at the moment (more to come). These are as follows:

### nginx_addsite

This creates a new site, using the `virtual_host.template` as the default configuration for the site (explained below). To use, simply run the following:

`sudo ./nginx_addsite.sh <domain name>`

where `<domain name>` is the domain name of the new site. You can use `http://www.` as a prefix, but this will be stripped and will waste precious time by typing the full URL, so just `domain.com` will do.

### nginx_delsite

This will remove a site (don't worry, it will confirm with you first!). Usage is as follows:

`sudo ./nginx_delsite.sh <domain name>`

Again, as above, the domain name should just be `domain.com`, the other junk should be stripped.


Templates
---------

There are two template files that you can change if you wish to have your sites set up differently. I highly encourage checking and editing these files to meet your needs before creating new sites.

### virtual_host.template

This is the "virtual host" configuration (if you like) for the site. Please refer to the [nginx configration options](http://wiki.nginx.org/Configuration) for more info. There are certain keywords (in FULL CAPS) that you can use to your advantage as variables, when using this template.

### index.html.template

This is just the initial file that will be placed in the web root for the new site.


Further Configuration
---------------------

If you wish, you can alter the configuration paths at the top of the `.sh` files to meet your needs. These are for things such as the paths to the nginx `sites-available` and `sites-enabled` as well as the web root.


Acknowledgements
----------------
Credit to [http://www.sebdangerfield.me.uk/](http://www.sebdangerfield.me.uk/) for the inspiration for these files.


License
-------

Copyright (C) 2013 edrackham.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
