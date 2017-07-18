<h1>Usage of the 'do_api' Command</h1>

- [Overview](#overview)
- [Commands](#commands)
  - [Help](#help)
  - [All Droplets](#all-droplets)
  - [All Floating IPs](#all-floating-ips)
  - [Assign Floating IP](#assign-floating-ip)
  - [Droplet Info](#droplet-info)
  - [Power Off](#power-off)
  - [Power On](#power-on)
  - [Rename](#rename)
  - [Shutdown](#shutdown)
  - [Version](#version)
# Overview

The `do_api` utility has several queries and commands, which follow a fairly uniform pattern.

Commands and queries pertaining to a specific Droplet **require** a Droplet ID to be specified using the syntax `-d 56789012` or `--droplet-id=56789012` for a (hypothetical) Droplet with that ID.

Commands and queries **not** pertaining to a specific Droplet **must not** have a Droplet ID specified; specifying one will fail with an error, e.g.

```
$ do_api all_floating_ips --d 56789012
ERROR: "do_api all_floating_ips" was called with arguments ["-d", "56789012"]
Usage: "do_api all_floating_ips"
```

**NOTE ALSO** that *all* commands (except `help` and `version`) require a `DO_API_TOKEN` environment variable to be set with your 64-hexit DigitalOcean Personal Access Token. This can be accomplished either by exporting the variable before running any commands, as in

```
$ export DO_API_TOKEN=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210
$ do_api all_droplets
... report follows ...
$
```
or by adding it directly on the command line

```
$ DO_API_TOKEN=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210 do_api all_droplets
$ do_api all_droplets
... report follows ...
$
```

# Commands

## Help

Syntax: `do_api help [COMMAND]`

With the optional `[COMMAND]` replaced by the name of a command, shows a help summary for that individual command. Without any specified `[COMMAND]`, displays a basic list of all available commands similar to:

```
$ do_api help
Commands:
  do_api all_droplets                                               # Summarise all Droplets owned by the user
  do_api all_floating_ips                                           # Summarise all Floating IPs owned by the user
  do_api assign_floating_ip IP_ADDRESS -d, --droplet-id=DROPLET-ID  # Assign a Floating IP to a Droplet
  do_api help [COMMAND]                                             # Describe available commands or one specific command
  do_api info -d, --droplet-id=DROPLET-ID                           # Report information about a Droplet with a specific ID
  do_api power_off -d, --droplet-id=DROPLET-ID                      # Forcibly power off an existing Droplet with a specific ID
  do_api power_on -d, --droplet-id=DROPLET-ID                       # Power on an existing Droplet with a specific ID
  do_api rename NEW_NAME -d, --droplet-id=DROPLET-ID                # Rename an existing Droplet with a specific ID
  do_api shutdown -d, --droplet-id=DROPLET-ID                       # Gracefully shut down existing Droplet with a specific ID
  do_api version                                                    # Display version information for utility

$
```

## All Droplets

Syntax: `do_api all_droplets`

Produces a report with selected details of each Droplet owned by the DigitalOcean user corresponding to the `DO_API_TOKEN` environment variable.

The report is formatted similarly to the following:

```
$ do_api all_droplets
+-------------+----------------------+----------------------+
| ID          | 56789012             | 56789023             |
| Name        | amazon               | nile                 |
| Status      | active               | active               |
| Created At  | 2017-06-21T08:20:42Z | 2017-06-22T10:07:34Z |
| Size        | 512mb                | 512mb                |
| Public IP   | 128.255.210.199      | 128.199.173.42       |
| Region Name | Singapore 4          | Singapore 4          |
+-------------+----------------------+----------------------+
$
```

Each Droplet owned by the current user is summarised in a separate column, with the detail headings in the leftmost column. The columns are ordered in the same order that information on each Droplet is returned by the relevant API call.

## All Floating IPs

Syntax: `do_api all_floating_ips`

Produces a report with selected details of each Droplet owned by the DigitalOcean user corresponding to the `DO_API_TOKEN` environment variable.

The [DigitalOcean API documentation](https://developers.digitalocean.com/documentation/v2/#floating-ips) describes *Floating IPs* as objects that

> represent a publicly-accessible static IP addresses that can be mapped to one of your Droplets. They can be used to create highly available setups or other configurations requiring movable addresses.

The report is formatted similarly to the following:

```
$ do_api all_floating_ips
+---------------------+----------------+
| Floating IP Address | 199.99.127.224 |
| Region Name         | Singapore 4    |
| Droplet ID          | 56789023       |
| Droplet Name        | nile           |
| Droplet IP Address  | 128.199.173.42 |
+---------------------+----------------+
```

## Assign Floating IP

Syntax: `do_api assign_floating_ip IP_ADDRESS -d DROPLET_ID`

This assigns the Floating IP `IP_ADDRESS` to the Droplet whose ID number is represented by `DROPLET_ID`. **Note** that the Droplet ID **must** be of a Droplet owned by the current user that **is not** the Droplet currently pointed to by that Floating IP.

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api assign_floating_ip 199.99.127.224 -d 56789012
+---------------+----------------------+
| ID            | 261277452            |
| Status        | in-progress          |
| Type          | assign_ip            |
| Started At    | 2017-07-16T18:08:17Z |
| Resource ID   | 2335955404           |
| Resource Type | floating_ip          |
+---------------+----------------------+
$ sleep 3
$ do_api all_floating_ips
+---------------------+-----------------+
| Floating IP Address | 199.99.127.224  |
| Region Name         | Singapore 4     |
| Droplet ID          | 56789012        |
| Droplet Name        | amazon          |
| Droplet IP Address  | 128.255.210.199 |
+---------------------+-----------------+
$
```

## Droplet Info

Syntax: `do_api info -d DROPLET_ID`

This reports hilights of the details of a Droplet as reported by the [*Retrieve an Existing Droplet by ID](https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-droplet-by-id) API call. The details reported are identical to those from the [`all_droplets`](#all-droplets) command above.

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api info -d 56789012
+-------------+----------------------+
| ID          | 56789012             |
| Name        | amazon               |
| Status      | active               |
| Created At  | 2017-06-21T08:20:42Z |
| Size        | 512mb                |
| Public IP   | 128.255.210.199      |
| Region Name | Singapore 4          |
+-------------+----------------------+
$
```

## Power Off

Syntax: `do_api power_off -d DROPLET_ID`

Commands the DigitalOcean API to perform a **hard shutdown** on a Droplet, analogously to cutting the power to a server. It should ordinarily be used **only** when a graceful [`shutdown`](#shutdown) command fails to change the Droplet status from `active` to `off` within a reasonably-generous timeout (e.g., 30-60 seconds for a 512 MB Droplet). Powering off an active server contained within a Droplet can, as the [API documentation](https://developers.digitalocean.com/documentation/v2/#power-off-a-droplet) warns, "lead to complications".

The command will fail if the Droplet is not powered on (or if the Droplet ID is invalid, or if the `$DO_API_TOKEN` environment variable is not validly set).

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api power_off -d 56789012
+---------------+----------------------+
| ID            | 234567890            |
| Status        | in-progress          |
| Type          | power_off            |
| Started At    | 2017-07-15T14:48:22Z |
| Resource ID   | 56789012             |
| Resource Type | droplet              |
+---------------+----------------------+
$
```

## Power On

Syntax: `do_api power_on -d DROPLET_ID`

Commands the DigitalOcena API to power up a currently-powered-off Droplet.

The command will fail if the Droplet is already powered on (or if the Droplet ID is invalid, or if the `$DO_API_TOKEN` environment variable is not validly set).

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api power_on -d 56789012
+---------------+----------------------+
| ID            | 234568012            |
| Status        | in-progress          |
| Type          | power_on             |
| Started At    | 2017-07-15T14:59:42Z |
| Resource ID   | 56789012             |
| Resource Type | droplet              |
+---------------+----------------------+
$
```

## Rename

Syntax: `do_api rename NEW_NAME -d DROPLET_ID`

Commands the DigitalOcean API to rename a Droplet. This has no effect on the operation of the Droplet (e.g., the hostname is unaffected); it merely changes the name shown for the Droplet in the DigitalOcean Control Panel.

The command will fail if the Droplet ID is invalid, or if the `$DO_API_TOKEN` environment variable is not set. It *will not* fail if the Droplet's name already matches that specified for `NEW_NAME`.

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api rename mississippi -d 56789012
+---------------+----------------------+
| ID            | 259452028            |
| Status        | in-progress          |
| Type          | rename               |
| Started At    | 2017-07-12T15:28:22Z |
| Resource ID   | 56789012             |
| Resource Type | droplet              |
+---------------+----------------------+
$ sleep 5
$ do_api info -d 56789012
+-------------+----------------------+
| ID          | 56789012             |
| Name        | mississippi          |
| Status      | active               |
| Created At  | 2017-06-21T08:20:42Z |
| Size        | 512mb                |
| Public IP   | 128.255.210.199      |
| Region Name | Singapore 4          |
+-------------+----------------------+
$
```

## Shutdown

Syntax: `do_api shutdown -d DROPLET_ID`

Commands the DigitalOcean API to gracefully shut down a Droplet. This is analogous to entering the `shutdown -h` command at the Droplet's console. When successful, and *after a reasonable time interval,* this will result in the [#Droplet Info](#droplet-info) for that Droplet showing a `Status` of `off` rather than `active`.

The command will fail if the Droplet ID is invalid, or if the `$DO_API_TOKEN` environment variable is not set.

A hypothetical example of usage and report formatting would be similar to the following:

```
$ do_api shutdown -d 56789012
+---------------+----------------------+
| ID            | 260515342            |
| Status        | in-progress          |
| Type          | shutdown             |
| Started At    | 2017-07-14T17:57:47Z |
| Resource ID   | 56789012             |
| Resource Type | droplet              |
+---------------+----------------------+
$ sleep 60
$ do_api info -d 56789012
+-------------+----------------------+
| ID          | 56789012             |
| Name        | mississippi          |
| Status      | off                  |
| Created At  | 2017-06-21T08:20:42Z |
| Size        | 512mb                |
| Public IP   | 128.255.210.199      |
| Region Name | Singapore 4          |
+-------------+----------------------+
$
```

## Version

Syntax: `do_api version`

Displays the current version identifier for this utility. Does not in any way access the DigitalOcean API; therefore, no DigitalOcean PAT is required to be set in the `$DO_API_TOKEN` environment variable.

An example of usage and output would be similar to the following:

```
$ do_api version
Version 0.1.0
$
```
