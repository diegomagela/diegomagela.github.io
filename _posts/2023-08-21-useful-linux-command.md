---
layout: post
title: Useful linux command-line programs
description: 
summary: 
comments: true
tags: [bash, linux]
categories: writing
toc: true
last-update: 2023-08-21
---

I am a huge fan and enthusiastic of Linux. This is not exclusively due to the fact that it is free, ''[free speech, not free beer](https://www.gnu.org/philosophy/open-source-misses-the-point.html)''. Its strong terminal-based commands appear to be a great opportunity to perform repetitive tasks very easily with little knowledge of [bash](https://www.gnu.org/software/bash/). As I am into academia, I will show useful command-line programs to facilitate academic-related tasks. Nonetheless, all code shown here can be easily used and/or adapted for other tasks. 

A frequent task is to convert a set of images from one file extension to another. A very powerful program to perform this is [`ImageMagick`](https://imagemagick.org/). As stated on its website, "ImageMagick® is a free, open-source software suite, used for editing and manipulating digital images. It can be used to create, edit, compose, or convert bitmap images, and supports a wide range of file formats, including JPEG, PNG, GIF, TIFF, and PDF."

For those running a Debian-based distribution (another reason I love Linux)

```bash
sudo apt install imagemagick
```

is all that is needed to install [`ImageMagick`](https://imagemagick.org/) (and most other programs). The program [`convert`](https://imagemagick.org/script/convert.php) is a member of [`ImageMagick`](https://imagemagick.org/) suite and, it is the program used to convert images from one file extension to another. Let us consider a folder containing `.png` images.

```
├── 1.png
├── 2.png
├── 3.png
├── 4.png
└── 5.png
```

To convert all of them to `.jpg` at once, for instance, simply open a terminal, navigate to the folder containing the images, and enter the following command:

```bash
ls -1 *.png | parallel convert '{}' '{.}.jpg'
```

The code above firstly lists all filenames, with one filename per line, having the `.png` extension. Them the result is ''piped'' to `parallel` using `|` operator, that runs `convert` in parallel to convert all files to `.jpg`. [`parallel`](https://www.gnu.org/software/parallel/) will be explained in a future opportunity. In the current folder, you will see both `.png` and `.jpg` images. If you want to remove all `.png` file, simply run

```bash
rm *.png 
```

Certainly, the same procedure can be done for other file formats. To obtain a complete list of supported file formats, run:

```bash
convert identify -list format 
```

In addition to simple image conversion, `convert` offers other options for editing, such as 3-D effects and color changes. Consulting the manual is always a worthwhile action. You can quickly access it by running `man`. For instance,

```bash
man convert
```

In summary, to convert a set of files from one file format to another and remove the files of the original format, use the following command:

```bash
ls -1 *.png | parallel convert '{}' '{.}.jpg' && rm *.png
```

In this context, the `&&` command function as `and`, meaning that it runs the first command **and** them the second one.




