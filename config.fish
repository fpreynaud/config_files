if status is-interactive
    # Commands to run in interactive sessions can go here
	alias v=vim
	bind \ek 'cd ..; fish_prompt; commandline -f repaint'
	bind \eh 'prevd; fish_prompt; commandline -f repaint'
	bind \em 'nextd; fish_prompt; commandline -f repaint'
	bind \ct 'fg'
end
