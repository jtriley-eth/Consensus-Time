# Time Keeping Protocol

This outlines a proposal for a decentralized time keeping protocol
for time-sensitive smart contracts requiring high degrees of accuracy.

---

## Requirements

These requirements are in no certain order,
but are all important for the integrity of time-based smart contracts.

- Decentralized
    - Trustless
    - Platform Agnostic
    - Low Computational/Network Requirement

- Economically Incentivized
    - Rewards Honest behavior
    - Profit should outweight network/energy cost

- Precise
    - All devices should be within a few milliseconds
    - Should be self-correcting

---

## Decentralized

The protocol should be trustless, all devices should reach consensus.

The protocol should be platform agnostic.
To maximize accessibility and decentralization,
any device should be able to participate, reach consensus, and earn economic incentives.

Network requirements should be minimal.
Most NTP servers/clients often query one another frequently.
To prevent man-in-the-middle attacks,
packets should also include a digital signature
and an integrity check.
Querying peers too frequently will result in reduced battery
life and higher network data usage.

---

## Econimically Incentivized

Honest behavior on the network should be rewarded over a long period of time.
This is in an effort to make it more profitable to run an honest node over a
dishonest node.

Rewards will only be pursued if the node can assume the financial incentive
outweighs the cost of network data usage as well as energy usage.
This cannot be guaranteed without a clear price denominated in USD,
barring speculation. 
An ICO to gain initial funding should help stimulate the valuation of the token,
thereby creating an initial incentive to run a node.

---

## Precise

Current Blockchains only use timestamps as a primitive layer of security,
primarily relying on the timestamp being greater than the parent timestamp.

The Bitcoin Protocol tolerance is ~2 hours:
```
(median_of_11_last_timestamps) < current_timestamp < (cpu_time + 2 hours)
```

The Ethereum Protocol tolerance is ~15 minutes:
```
parent.timestamp < current_timestamp < cpu_time + 900 seconds
```

This creates time-based security vulnerabilities in smart contracts that
require precise timestamps.

The protocol should keep all devices synchronized within a few milliseconds.

The protocol should also be self-healing at a relatively high freqency.

Quartz oscillators alone are not accurate enough,
as they can gain or lose 0.5 seconds per day,
assuming a tempterature of 41 to 95 degrees fahrenheit.
They also do not account for leap seconds. 

Atomic Clocks seem to be the most reliable timekeeping devices mankind has.
Atomic Clocks can be standalone devices or embeded in GPS satellites.

High precision clocks exist at the highest level of the Network Time Protocol,
an old protocol used to sync devices within milliseconds,
taking into account variable network latency.
These can be referred to as stratum 0 devices.

Stratum 1 devices are often directly connected to the stratum 0 devices,
keeping synchronizaiton within a few microseconds.

Stratum 2 devices query both stratum 1 servers as well as stratum 2 peers.
This is to ensure consensus and precision.

---

## The Protocol

The protocol should consist of a low level, low latency set of instructions
to run on any device on the network.

Each device should be classified as a stratum 2 device if possible,
initially querying stratum 1 servers, then reaching consensus among peers.

### Network State

Each device does not have to be perfectly synchronized with the network 24/7,
rather a network global state representing an accurate timestamp should be
maintained by each device reaching consensus.

### Timestamp

The timestamp should be an unsigned 256 bit integer representing the number of
milliseconds since an epoch. 

If the epoch is set to be 1 January, 1 AD, for example,
this would account for `3.67e67` years to come.

It is notable that this number is far beyond the bounds that languages such as
JavaScript are designed to handle natively.
BigNumber libraries can help with this, however,
and this prevents issues such as the year 2038 problem with the Unix timestamp
being a 32 bit signed integer,
or the Bitcoin protocol's year 2106 problem with their 32 bit unsigned integer.

### Rewards

Similar to many successful blockchain systems,
economic incentives should be in place for two reasons.
First is to ensure that an economic actor will be incentivized to act
honestly rather than dishonestly if they control a significant portion
of the network.
Second is to attract many different economic actors to verifying and maintaining
the network state.

#### Inflationary Model

    An inflationary model would entail new tokens being minted for each time verification,
    this ensures a constant but steady influx of the currency.

    This allows for higher yield for validators at the expense of the token
    becoming inflationary and depreciating in value over a long period of time.

#### Circulation Model

    A circulation model relies on query fees, where any time a smart contact
    or external device queries the network, they pay a small fee for doing so.

    This fee would be distributed to the network validators, however,
    this would mean to be useful, the network could not charge high fees.

    There is also the issue that if new tokens are not minted, only circulated,
    the asset will become deflationary as wallets are lost or burned. 

    Also, as market cap increases on a deflationary asset,
    the transaction fee, denominated in USD,
    will become increasingly infeasible for anyone to query the network.


