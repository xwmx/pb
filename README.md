```text
           __
    ____  / /_
   / __ \/ __ \
  / /_/ / /_/ /
 / .___/_.___/
/_/
```

# pb

A tiny wrapper combining pbcopy &amp; pbpaste in a single command.

Copy to or paste from the OS X clipboard/pasteboard. With no input, `pb`
prints the current contents of the clipboard to stdout using the `pbpaste`
command. When input is passed via stdin or an argument, `pb` acts as a
wrapper for `pbcopy`, which in the simplest case means that it replaces the
clipboard contents with the input.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew install alphabetum/taps/pb
```

### bpkg

To install with [bpkg](http://www.bpkg.io/):

```bash
bpkg install alphabetum/pb
```

### Manual

To install manually, simply add the `pb` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/alphabetum/pb/master/pb \
  -o ~/bin/pb && chmod +x ~/bin/pb
```

## Usage

```text
Usage:
  pb [-pboard {general | ruler | find | font}] [-Prefer {txt | rtf | ps}]
  pb <input> [-pboard {general | ruler | find | font}]
  pb -h | --help

Options:
  -pboard    Specify the pasteboard to copy to or paste from.
             Default: general
  -Prefer    Specify what type of data to look for in the pasteboard first.
  -h --help  Show this screen.
```
