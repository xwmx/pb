[![Build Status](https://travis-ci.org/xwmx/pb.svg?branch=master)](https://travis-ci.org/xwmx/pb)

```text
           __
    ____  / /_
   / __ \/ __ \
  / /_/ / /_/ /
 / .___/_.___/
/_/
```

# pb

A tiny wrapper combining `pbcopy` &amp; `pbpaste` in a single command.

Copy to or paste from the macOS / OS X clipboard / pasteboards. With no
input, `pb` prints the current contents of the clipboard to stdout using the
`pbpaste` command. When input is passed via stdin or an argument, `pb` acts as
a wrapper for `pbcopy`, which in the simplest case means that it replaces the
clipboard contents with the input. `pb` also includes a `pb --clear` flag
to easily clear the macOS clipboard.

```bash
# save the string "Example text." to the clipboard
> pb "Example text."

# print the clipboard contents
> pb
Example text.

# save the string "Example piped text." to the clipboard
> echo "Example piped text." | pb

# print the clipboard contents
> pb
Example piped text.

# clear the clipboard contents
> pb --clear
Pasteboards / Clipboard cleared.
```

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew tap xwmx/taps
brew install pb
```

### npm

To install with [npm](https://www.npmjs.com/package/pb.sh):

```bash
npm install -g pb.sh
```

### bpkg

To install with [bpkg](http://www.bpkg.io/):

```bash
bpkg install xwmx/pb
```

### Manual

To install manually, simply add the `pb` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/xwmx/pb/master/pb \
  -o ~/bin/pb && chmod +x ~/bin/pb
```

## Usage

```text
Usage:
  pb [-pboard {general | ruler | find | font}] [-Prefer {txt | rtf | ps}]
  pb <input> [-pboard {general | ruler | find | font}]
  pb --clear
  pb --version
  pb -h | --help

Options:
  --clear    Clear the contents of all pasteboards.
  -pboard    Specify the pasteboard to copy to or paste from.
             Default: general
  -Prefer    Specify what type of data to look for in the pasteboard first.
  --version  Print the current program version.
  -h --help  Show this screen.

Examples:
  pb "Example text."          Copy data specied with an argument.
  echo "Example text." | pb   Copy piped data.
  pb                          Print contents of the clipboard / pasteboard.

More information:
  Run `man pbcopy` or `man pbpaste`.
```

## Background and Terminology

macOS refers to the clipboard as the pasteboard. There are multiple
pasteboards, with "general" as the default that is used when no
pasteboard is specified. The "general" pasteboard is also used in
[Universal Clipboard](https://support.apple.com/en-us/HT209460).

Clipboard / Pasteboard Developer Documentation:
- [Pasteboard | Apple Developer Documentation Archive
  ](https://developer.apple.com/library/archive/documentation/General/Devpedia-CocoaApp-MOSX/Pasteboard.html)
- [NSPasteboard | Apple Developer Documentation
  ](https://developer.apple.com/documentation/appkit/nspasteboard#//apple_ref/doc/c_ref/NSPasteboard)
- [NSPasteboardName | Apple Developer Documentation
  ](https://developer.apple.com/documentation/appkit/nspasteboardname)

## Tests

To run the test suite, install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root.
