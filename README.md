# Dotfiles

### Fonts used in my system:
* Font Awesome 5.x
* Jetbrains Mono
* Fira Code
* Overpass


### Packages needed for this config:

* Polybar
* Stow
* Sxhkd
* Dunst
* Bspwm
* And some other ones i actually don't remember

---

## How to install?

To install my dotfiles, everything you need to is:

1. Clone this repository in your home folder
2. Execute the command ```stow */``` (this will link the folders inside to ~/ inside their respective directories. Ex: the files inside the home folder will be linked to /home/filename)

Note: all the files inside the git repo root directory will be ignored.
Example: .gitignore will be ignored, but if it's inside a folder, like this: 'folder/.gitignore' it won't be ignored.

For more info about the stow command, go to: 
[Stow](https://linux.die.net/man/8/stow)


---
## Problems:

###  Deleting the .local folder from this repo and having a shell that interacts with git will make the git command extremely slow.

## How to fix:

Executing this git command will fix the issue:
<br>
```
git ls-files --deleted -z | git update-index --assume-unchanged -z --stdin
```
## What will that command do?

The command mentioned before will simply assume that all the files deleted will are unchanged, thus solving the lag problem.
