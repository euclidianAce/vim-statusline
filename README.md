# Preface
 - Holy heck don't use this it's a mess.
 	- This place is not a place of honor...
	- no highly esteemed deed is commemorated here...
	- nothing valued is here.
 - Please someone who is better at programming than me patch 8.1.1372 into Neovim
This code would be much less of a mess of compatability with both Vim and Neovim
with it.

# My custom statusline
With that out of the way, it's pretty similar to lightline, just wanted to see
if I could implement it myself.

Since Neovim does things asyncronously, the mode text is randomly wrong, which
is fun. In Vim, the first window doesn't recognize being in command mode, but
when you have other windows open they do. As I said, mess.

I would say, most of this is a consequence of Vim patch 8.1.1372 not being in
Neovim, which means Neovim doesn't have the `g:statusline_winid` variable that I
was originally using.

# Usage
Make sure Vim was compiled with Lua support or use Neovim.

Clone the repo into a directory that matches either
`~/.vim/pack/*/opt/`
or `~/.vim/pack/*/start/`.
(If you cloned it into the `opt` directory put the following into your .vimrc)
`packadd! statusline`
