---
title: How to install mosh on Amazon EC2
author: Seamus
layout: post
categories: technology techresearch
---

Here's how to install [mosh](http://mosh.mit.edu/) on [Amazon EC2 instances](http://aws.amazon.com/ec2/):

<!-- more start -->

{% highlight console %}
ec2-user@ip-X-X-X-X: $ sudo yum install git-core boost-devel libutempter-devel ncurses-devel zlib-devel perl-CPAN cpp make automake gcc-c++
ec2-user@ip-X-X-X-X: $ sudo cpan IO::Pty
  [say yes twice]
ec2-user@ip-X-X-X-X: $ curl -O "http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz"
ec2-user@ip-X-X-X-X: $ tar -xzf protobuf-2.4.1.tar.gz 
ec2-user@ip-X-X-X-X: $ cd protobuf-2.4.1
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ ./configure 
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ make
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ sudo make install
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ sudo ldconfig | grep proto
  [you should see libprotobuf, etc.]
ec2-user@ip-X-X-X-X: ~/protobuf-2.4.1$ cd
ec2-user@ip-X-X-X-X: $ git clone git clone https://github.com/keithw/mosh
ec2-user@ip-X-X-X-X: $ cd mosh
ec2-user@ip-X-X-X-X: ~/mosh$ ./autogen.sh 
ec2-user@ip-X-X-X-X: ~/mosh$ ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ec2-user@ip-X-X-X-X: ~/mosh$ make
ec2-user@ip-X-X-X-X: ~/mosh$ sudo make install
{% endhighlight %}

See the [full log here](/images/2012-04-14-how-to-install-mosh-on-amazon-ec2/my.log).

Then you need to open the EC2 port: (note UDP)

![Opening ports 60000-61000](/images/2012-04-14-how-to-install-mosh-on-amazon-ec2/open-firewall-for-mosh.png)

<!-- more end -->
