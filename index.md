---
layout: default
title: Virgo Agent Toolkit
---

## What is an agent?

We think of an agent as a small program responsible for interfacing to some resource on behalf of a user or application. We call the corresponding program (or library) responsible for interfacing to the agent on behalf of the application an 'endpoint'.

<img class="diagram" src="./images/1.dot.png" alt="">

Often this agent is running on a remote host and the endpoint is running locally to the service which is using it.

<img class="diagram" src="./images/2.dot.png" alt="">

## How can I make an agent?

An agent can be this simple:

{% highlight lua %}
local agent = require('virgo').agent
 
# the updates modules adds update-specific behavior
local updates = require('updates')
  
# provides the ability to configure from the filesystem
local file_config = require('file_config')
 
return agent([updates, file_config])
{% endhighlight %}

Here's an agent and endpoint in nodejs:

{% highlight javascript %}
var virgo = require('..');

var agent = virgo.agent;
var endpoint = virgo.endpoint;
var heartbeats = virgo.heartbeats;

endpoint([heartbeats(function(hb) {
  process.stdout.write('received hb\n');
  process.stdout.write(JSON.stringify(hb, 0, 2) + '\n');
})]).run();

agent([heartbeats()]).run();
{% endhighlight %}

## So why is making agents hard?

- Security is hard and very important
- Networks are unreliable
- Remote machines are often behind firewalls or NAT
- Writing binaries for every platform is hard
- Building packages for all operating systems is hard, ditto build infrastructure and installers
- Once agents are installed on remote machines operated by others, keeping those agents up-to-date is hard
- Writing software which uses memory, CPU, and network efficiently is hard (especially with popular dynamic languages)
- Writing perfectly correct and reliable code is hard
- Integrating with crash-capturing services such as Google's Breakpad is a hassle

## Why a project for agents generally?

Once and for all, let's solve the problems everyone encounters whenever they build an agent. Come build your agent with us!

## Virgo Base Agent

The [Virgo base agent](https://github.com/virgo-agent-toolkit/virgo-base-agent) is written in C with an embedded [Luvit](http://luvit.io/) runtime.

- Ease of extension with application-specific behaviors via a common interface
- An extensible, versioned protocol on a redundant, secure connection to at least one controller endpoint
- Packages, build infrastructure, installers, and related goodies for many platforms
- Auto-updating controlled from the endpoint
- Crash capturing and reporting with Google's Breakpad

Many of these features can be discarded. The [virgo-example-agent](https://github.com/virgo-agent-toolkit/virgo-example-agent) shows the absolute smallest Virgo agent.

### Why Luvit?

[Luvit](http://luvit.io/) offers an efficient dynamic language with a [JIT](http://luajit.org/), great [FFI](http://luajit.org/ext_ffi_tutorial.html), a friendly [C API](http://www.lua.org/pil/24.html), and a [familiar high-level developer API](http://nodejs.org/documentation/api/) for [asynchronous programming](http://nikhilm.github.io/uvbook/basics.html).

Writing cross-platform agents which can be easily and clearly introspected by common debugging tools (such as strace, gdb) is best done in C, but the business logic that an application using agents needs on the agent is often best written in a dynamic language. Dynamic languages are usually greedy for RAM or CPU, are difficult to embed transparently in a C program, or have synchronous models which introduce the complexities of multi-threading into agent applications (often all three). Luajit is incredibly performant, Lua is designed with an easy-to-use C API in mind, and Luvit embeds [Libuv](https://github.com/joyent/libuv) so asynchronous Luvit scripts can share a single process with the Libuv event loop.

## Virgo libraries

- [Virgo.js](https://github.com/virgo-agent-toolkit/virgo.js)
- [go-agent-endpoint](https://github.com/virgo-agent-toolkit/go-agent-endpoint)

## Protocol

An open, versioned, easy-to-implement protocol between endpoints and agents enables interoperability. The Virgo protocol consists of messages which are newline-delimited json objects (like [json-rpc](http://json-rpc.org/)).

### More docs

[virgo-agent-toolkit.github.io/docs](http://virgo-agent-toolkit.github.io/docs/)
