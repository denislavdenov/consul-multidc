# Sample repo showing 2 examples: TLS encrypted Vault + TLS and Gossip encrypted multi-datacenter Consul cluster and non-encrypted only multi-dc Consul cluster

In order to swtich from TLS to non-TLS encrypted versions, change the `TLS` variable from `true` to `false` in the `Vagrantfile`

Things it is not recommended to be changed:
1. Server names
2. IP ranges of the servers
3. ENV variables passed to the scripts


# How to do it:

1. Fork and clone
2. `vagrant up`
