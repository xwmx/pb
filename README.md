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

Copy to or paste from the macOS / OS X clipboard/pasteboard. With no input,
`pb` prints the current contents of the clipboard to stdout using the `pbpaste`
command. When input is passed via stdin or an argument, `pb` acts as a
wrapper for `pbcopy`, which in the simplest case means that it replaces the
clipboard contents with the input.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew install xwmx/taps/pb
```

### npm

To install with [npm](https://www.npmjs.com/package/pb.sh):

```bash
npm install --global pb.sh
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

## Tests

To run the test suite, install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root.
