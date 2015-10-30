# pb
A tiny wrapper combining pbcopy &amp; pbpaste in a single command.

Copy to or paste from the OS X clipboard/pasteboard. With no input, `pb`
prints the current contents of the clipboard to stdout using the `pbpaste`
command. When input is passed via stdin or an argument, `pb` acts as a
wrapper for `pbcopy`, which in the simplest case means that it replaces the
clipboard contents with the input.
