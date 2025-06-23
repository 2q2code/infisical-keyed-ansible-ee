# infisical-keyed-ansible-ee
Create a custom Ansible Execution Environment that gets its SSH key securely from your Infisical server at runtime

I know how to write a good readme. I just don't have the required motivation to do so right now. If you run into trouble, shoot me a question and I'll help if I can. The intent behind releasing this is to allow others to have access to what I needed at the time when I wrote it. It keeps the key in the SSH Agent memory only, and it never touches disk. Is it foolproof? No. A determined hacker can always get what they want. It's about making the level of inconvenience sit at a higher level than the motivation/skill/effort-level of your threats. As it happens, I found that on my hardware, Infisical had a bit of a memory problem, so I ended up reworking this to run using VaultWarden instead, which is what I currently use. There are pros and cons. Infisical is definitely faster.

To use the EE once you've created it, run a playbook with it using Ansible Navigator like this:

```bash
ansible-navigator run playbook.yml -i your_inventory_directory_or_file --execution-environment-image your.docker.registry.if.any/ansible-ee:your.tag.here --mode stdout -u root --pae false
```

The EE will then be pulled if needed, and run on any x64 architecture system (I think). It contacts the Infisical server and gets the SSH key it needs to shell into your machines as root (the unsettling idea of this kind of access is what had me make this in the first place - I'm paranoid with good reason - bite me), store it for a second in shared memory (protected), then after SSH Agent loads it, removes it from shared memory, and wipes out any environment variables used to access Infisical to keep the environment safe from any playbook it's used to run.

Anyway, I hope you find this useful.
