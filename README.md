# HordeBehavior

Repository that helps reproduce weird behaviour of `Horde.Registry`.

**Problem**: disappearing values from `Horde.Registry` after spawning more than two nodes.

**Expected behavior**: After adding more nodes, values in the `Horde.Registry` from all nodes will be synced without losing any value.

**Elixir**: 1.13.3  
**horde**: 0.8.7

## Reproduce:

- start first node

```sh
  iex --sname node1@localhost -S mix
```

- start second node

```sh
  iex --sname node2@localhost -S mix
```

- check state of registry on node1 - should be two processes - one per node

```sh
  nodes = [node() | Node.list()]
  Enum.map(nodes, fn node -> Horde.Registry.lookup(Registry.State, node); end)
  [[{#PID<0.276.0>, nil}], [{#PID<19886.268.0>, nil}]]
```

- start third node

```sh
  iex --sname node3@localhost -S mix
```

- check state of registry on node1 - should be three processes but there are only two processes - first and last - the middle one disappearing

```sh
  nodes = [node() | Node.list()]
  Enum.map(nodes, fn node -> Horde.Registry.lookup(Registry.State, node); end)
  [[{#PID<0.276.0>, nil}], [], [{#PID<21155.273.0>, nil}]]
```

## Notes

- I checked google and I found two issues related to it, but reading that threads didn't help me :P
  But maybe I missed sth.

      - https://github.com/derekkraan/horde/issues/116
      - https://elixirforum.com/t/horde-dynamicsupervisor-bypasses-registry/49562

- I thought that processes are adding to `Horde.Registry` too fast, but adding Agents manually by command below, but it didn't helped, issue still occures.

```sh
Agent.start_link(fn -> 553 end, name: {:via,iex(node2@localhost)1> Agent.start_link(fn -> 553 end, name: {:via, Horde.Registry, {Registry.State, node()}})
```
