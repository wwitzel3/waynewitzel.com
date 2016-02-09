---
categories: ["juju", "lxd"]
date: "2015-11-05T18:30:00-05:00"
tags: ["lxd", "juju"]
title: "Juju and Remote LXD Host"
---

The team I am a part of at Canonical has been working on implementing a Juju
provider for LXD. One of the goals of this provider is to improve the Juju experience
when working and developing locally. You can try it yourself, but you will have to build Juju
from source, the branch is available here: https://github.com/juju/juju/tree/lxd-provider

Where the current Juju local provider uses your machine as the bootstrap or machine-0 node.
The new LXD provider creates an LXC container for machine-0, ensuring that there are no
system-level dependencies (other than what is needed for LXD and Juju) and more
importantly we ensure we have a clean bootstrap machine, unlike with the current local
provider, where we can completely destroy machine-0 since it is your machine.

Since the LXD provider communicates over HTTPS it gave me the idea. What if we use Juju to control
a remote LXD installation on some arbitrary host?

After running LXD so successfully locally, I really wanted to try and have Juju manage a remote LXD installation.
Essentially turning that remote host in to a custom mini-cloud. So here are the high level steps I took.

First, there was some setup of the remote host. I had a server running on my local network that I could play with.

    * Installed LXD and enabled HTTPS, lxc config set core.https_address [::]:8443
    * Verified the installation with the lxc client (which will also generate the certs)
    * Copied the key and cert from ~/.config/lxc
    * Setup a DHCP server to assign routable addresses for lxcbr0. (See: https://wiki.debian.org/LXC/SimpleBridge)

On my laptop I had to create a new provider entry for this remote LXD.

    * I created an entry in my environments.yaml, lxd-remote, type: lxd
    * Provided client.key and client.crt lxd-remote environment via environments.yaml
    * Set the remote of lxd-remote to my servers IP.

Then I was able to 'juju bootstrap -e lxd-remote' and things appeared to work. I was able to deploy services. Addresses
were being properly assigned from the DHCP pool (these could be publicly routable addresses if your company is assigned a block).
When I ran in to issues was when I attempted to visit those services. The servers firewall was blocking the ports those services were
listening on, even after I used the 'juju expose' command. Since Juju treats the LXD provider like any other cloud it supports, there
is an expectation that things like firewalling have an API.

So that is where the current LXD provider implementation is lacking. Right now the LXD provider is dumb, it doesn't have any firewall, storage,
or network knowledge. Which makes using it to orchestrate a remote LXD host a bit impractical. Since there could be any number of possible firewalling
choices depending on the host system that is running LXD, it is very difficult to implement the ability to expose services in a generic fashion.
It is likely that later version of the LXD provider will interface with host machines firewall, but will require specific firewall software be used.  
Even with that in place, you will have to do the manual setup of the remote host to make the LXC containers that are being created
routable to the desired clients.

In summary, it is possible with some hacking to have Juju manage a remote LXD, but it is currently not very practical. Once the LXD provider has
settled on a firewalling approach, then the only manual setup from the user would be installing LXD and preparing the LXC network bridge to
reflect the desired configuration.
