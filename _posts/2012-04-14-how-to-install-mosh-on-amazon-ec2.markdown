---
title: How to install mosh on Amazon EC2
author: Seamus
layout: post
categories: technology techresearch
---

Here's how to install [mosh](http://mosh.mit.edu/) on [Amazon EC2 instances](http://aws.amazon.com/ec2/):

<!-- more start -->

{% highlight console %}
$ sudo yum install git-core boost-devel libutempter-devel ncurses-devel zlib-devel perl-CPAN cpp make automake gcc-c++
$ sudo cpan IO::Pty
  [say yes twice]
$ curl -O "http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz"
$ tar -xzf protobuf-2.4.1.tar.gz 
$ cd protobuf-2.4.1
~/protobuf-2.4.1$ ./configure 
~/protobuf-2.4.1$ make
~/protobuf-2.4.1$ sudo make install
~/protobuf-2.4.1$ sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
~/protobuf-2.4.1$ sudo ldconfig | grep proto
  [you should see libprotobuf, etc.]
~/protobuf-2.4.1$ cd
$ git clone https://github.com/keithw/mosh
$ cd mosh
~/mosh$ ./autogen.sh 
~/mosh$ ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
~/mosh$ make
~/mosh$ sudo make install
{% endhighlight %}

Here's something that's easy to copy-paste:

    sudo yum install git-core boost-devel libutempter-devel ncurses-devel zlib-devel perl-CPAN cpp make automake gcc-c++
    sudo cpan IO::Pty
      [say yes twice]
    curl -O "http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz"
    tar -xzf protobuf-2.4.1.tar.gz 
    cd protobuf-2.4.1
    ./configure 
    make
    sudo make install
    sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
    sudo ldconfig | grep proto
      [you should see libprotobuf, etc.]
    cd
    git clone https://github.com/keithw/mosh
    cd mosh
    ./autogen.sh 
    ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
    make
    sudo make install

See the [full log here](/images/2012-04-14-how-to-install-mosh-on-amazon-ec2/my.log).

Then you need to open the EC2 port: (note UDP)

![Opening ports 60000-61000](/images/2012-04-14-how-to-install-mosh-on-amazon-ec2/open-firewall-for-mosh.png)

<!-- more end -->
