---
title: Nix don't kill my vibe
tags:
  - story
  - tutorial
date: 2025-10-06
slug: 2510-nix
summary: TODO
---

> TLDR: I loved setting up `nix and co.` in my system. If you're thinking about it, I have a short summary and links for absolute beginners in the end. 

Nix has got to be one of the most "why haven't I tried this earlier" tools I've ever tried. And who knows when I would have tried it if I hadn't needed to set up a new machine. I’ve heard transferring from one mac to another should be no effort at all, and everything will be there just as you left it. To me that sounds horrifying - that system had 2 jobs’ worth of things set up and it just bothered me _so much._ Even without that, there's something about straight up copying over _every file ever_ that feels... wrong. 

I had heard of `home-manager` over the years and would remember it every time I had to hunt down and clean up different programs I would need or play around with. And _boy_ do I try a bunch of different programs. During these cleanups, I would end up removing something I actually needed and on a random day months later, end up with a quest to find a mysterious missing dependency . There were also these markdown files where I would keep notes of different things I had to do manually, that weren't configurable with `dotfiles`. I kept promising myself I would set up `home-manager`, at least when switching devices. Thankfully that happened during my vacation, so I was able to keep the promise. 

### Why it's so cool

I started early morning, all _worked up_ to tackle the steep learning curve I had been hearing about for years. I had a busy schedule for my vacation, but there were a few days with enough time to carry this thing over the finish line. Fast forward a few hours and I had not just `nix`, but `home-manager` and `nix-darwin` on top of it! Not only do I have a nice declarative list of all the brew casks/programs I need on my machine, but I can add these _lovely_ comments on top of obscure names to explain what they are for. 

And check this out - I had no idea this was possible - `nix-darwin` allows you to manage some configuration of your Mac like you would with `NixOS`. 

```nix
system.defaults.trackpad.Clicking = true;
system.defaults.finder.ShowPathbar = true;
system.defaults.NSGlobalDomain._HIHideMenuBar = false;
fonts.packages = [
	pkgs.nerd-fonts.sauce-code-pro
	# ...
]
# I LOVE having this one set up with no effort
security.pam.services.sudo_local.touchIdAuth = true;
```

Even with Apple's magic system transfer, we still have to set up work machines once in a while, and searching for these settings all over again is never fun. 

As for `home-manager`, there is no short description that does it service, there are so many programs and fields supported, it's limitless. You can move a substantial amount of `dotfiles` content to here. Just have a look

```nix
home-manager.users.ia = {
	programs = {
	  zsh = {
		enable = true;
		oh-my-zsh = {
		  # yes, this means oh-my-zsh will be installed for you
		  enable = true;
		  plugins = [ "git" "tmux" ];
		  theme = "avit";
		  # ...
		};
		shellAliases = {
			# ...
		};
	  };
	};
  };
```

### What everyone gets wrong
The only negative feeling during the whole experience was the frustration I felt for not trying this sooner. When you hear that something has a learning curve and needs upfront investment to learn, you're more likely to put it off until you have enough time to deal with it. And when something is kinda niche, you will keep choosing other things to invest your time in.

But here's the thing - I would like to argue that neither `nix`, `home-manager`, or `nix-darwin` have a steep learning curve. We shouldn't be claiming that something has a “steep learning curve” if it’s usable _and_ useful out of the box. 

Sure, once you start getting into it, there's a lot of concepts to learn, but as a beginner, you can copy-paste a few files and receive _substantial_ convenience in return. If you immediately convert your whole development environment to use `nix` right away, there will most likely be lots of uphill battles, but going that far is _completely optional_. 

In general, I don't think it's good judgment anyways to go all in with niche setups right away - gradual, on-demand shift will prevent many headaches. I still keep most my packages at user level for that reason - `nix-shell -p ` is already a _huge_ game changer and works with no effort. I can do `nix-shell -p program-name --run program-name whatever` and not worry about program-name remaining in my path forever.

I have also used 0 nix language features in my file so far, aside from the stuff that was already in the template. That is also the reason why I will not be sharing my file - the whole config probably looks like whatever a toddler's crayon drawing equivalent of a config file is. But I'm be happy to link a few resources that I used, along with a few notes on how I combined them. The few times I needed help with the syntax, I used [Lumo](lumo.proton.me), Proton's privacy respecting chatbot. 

### What I used to get started
Let's first clear up the difference between the two:

- `nix-darwin` - this is os-level configuration. It allows declarative configuration of many System Settings items and more. It can also manage `brew` packages and casks for you, as well as installation of system level packages from `nixpkgs`'s infinite repository.
- `home-manager` - for almost _anything_ you might need to configure for your user. 

You don't have to have `NixOS` or `nix-darwin` to use `home-manager`, but in my case I set up both. [This guide](https://nixcademy.com/posts/nix-on-macos/) is what I used to set up `nix-darwin`. 
- I used GUI installer for [Determinate Nix](https://docs.determinate.systems/getting-started/individuals)
- After installation, I needed to set up rosetta `softwareupdate --install-rosetta --agree-to-license`
- After that, I copied the config file and modified with my machine's name. Make sure you have `nix.enable = false;` in your `let configuration = { ... ` block.

For home manager, [this]( https://carlosvaz.com/posts/declarative-macos-management-with-nix-darwin-and-home-manager/) is a great tutorial. Along with the tutorial, here's a top level view of `flake.nix` created at the previous step, with comments for what goes where, for absolute beginners like me:

```nix
{
	description = "..."
	inputs = {
	    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
	    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	
		# add this
	    home-manager.url = "github:nix-community/home-manager/master";
	    home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};
	outputs =
	    inputs@{
	      self,
	      nix-darwin,
	      nixpkgs,
	      home-manager,
	    }:
	    let
	      configuration = {
			  # ...
			  
			  home-manager.users.<USER> {
				  # add config here
			  } 
	      }

```