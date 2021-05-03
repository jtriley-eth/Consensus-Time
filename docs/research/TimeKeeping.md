# Time Keeping

This highlights important things related to keeping time on a computer.

---

## Unix Time

Defined as a system for describing a point in time.
It is the number of seconds that have elapsed since the Unix Epoch, minus leap seconds.

Aliases:
- Epoch Time
- POSIX Time
- Seconds since the Epoch
- UNIX Epoch Time

Unix Epoch = 00:00:00 UTC 1 January, 1970

### Encoding 

Made up of two layers of encoding

**Layer 1** point in time as a scalar real number, representing the number of seconds since Unix Epoch

**Layer 2** encodes that number as a sequence of bits or decimal digits

ISO 8601 - A date and time format, Epoch = `1970-01-01T00:00:00Z`

### Leap Seconds

Leap seconds may be positive or negative,
though no negative leap seconds have ever been declared.

Leap seconds happen about once every 1.5 years.

Unix Time increases continuously into the next day during the leap second,
then the leap second jumps back by 1.

---

## Quartz Oscillators

Defined as a timepiece using an electronic oscillator
regulated by a quartz crystal to keep time.

### Quartz

Quartz is a form of silicon dioxide,
a piezoelectric material that accumulates electrical charge
when subjected to mechanical stress.

It does not change much as tempterature fluctuates.

The oscillation frequency depends on shape, size, electrode position,
and the crystal plane on which the quartz is cut.

Most quartz watches use 32,768 Hz. 
A 15 bit binary digital counter driven by the frequency will overflow once per second.

### Accuracy

Assuming 31 degrees celsius (87.8 degrees fahrenheit),
a quartz clock should gain or lose 15 seconds per 30 days,
or 0.5 seconds per day, on average.

---

## Clock Networks

Note: Clock networks consist of 'Master Clocks' and 'Slave Clocks', per Wikipedia.
For the sake of avoiding social issues relating to master and slave terminology,
Master Clocks will be referred to as Main Clocks and
Slave clocks will be referred to as Secondary Clocks.
This is applicable both to definitions in this document as well as
any future implementations of clock networks in this protocol.
See also: [Git Branch Renaming Master to Main](https://sfconservancy.org/news/2020/jun/23/gitbranchname/)

A clock network is a set of clocks communicating to synchronize.

### Main Clocks

Main clocks receive time via:

- US GPS satellite constellation
- Network Time Protocol Server
- CDMA Cellular Phone Network
- Modem Connection to a Time Source
- Special Upstream Broadcast Network
- Radio Transmittions
    - WWV, Fort Collins, Colorado
    - WWVH, Barking Sands Missile Range, Kekaha, Kauai, Hawaii

### Secondary Clocks

Connect to main clock through either a cable or short-range wireless signal.

Some run independantly with warning light if disconnected from main,
others freeze until connection restored.

### Synchronization

Some main clocks can sync computers via:

- RS-232
- Network Time Protocol
- PPS, Pulse Per Second contact

### Time and Frequency Receivers

Types:

|Abreviation|Description|
|---|---|
|GPSDO|GPS Disciplined Oscillators|
|GPSC|GPS Clocks and Time Sources|
|GPSB|GPS OEM Modules and Board Level Products|
|VBC|WWVB Clocks (wall clocks, wristwatches, etc)|
|VBPMC|WWVB Phase-Modulated Clocks (wall clocks, wristwatches, etc)|
|CDMA|CDMA Disciplined Oscillators|

---

## Network Time Protocol

Defined as a networking protocol for clock synchronization between computer systems over packet-switched, variable-latency data networks.

Intended to synchronize all participating computers within a few milliseconds of UTC.

NTP uses the Intersection Algorithm, a modified Merzullo's Algorithm,
to select accurate time servers and is desinged to mitigate the effects of variable network latency.

Currently Version 4 `NTPv4`

### Clock Strata

NTP uses a heirarchial semi-layered system of time sources. 

- Stratum 0
    - Atomic Clocks
    - Radio Clocks
    - GPS

- Stratum 1
    - Synced within a few microseconds of the attached stratum 0 devices
    - May peer with other Stratum 1 for sanity check and backup

- Stratum 2
    - Syned over network to stratum 1
    - Often queries multiple stratum 1 servers
    - Also may peer with other stratum 2
    
- Stratum 3 ... 15
    - ...

### Timestamps

64 bit timestamps:
    32 bits for seconds
    32 bits for fractional seconds

Timestamp rolls over every 136 years.
NTP uses epoch of 1 January, 1900.
Next roll over is 7 February, 2036.

### Clock Synchronization Algorithm

NTP Client regularly polls one or more NTP servers.

Client must compute its time offset and round-trip delay.

Time offset `theta`, the absolute time between the two clocks, is defined by:

```python
# python3
theta = abs( ((t1 - t0) + (t2 - t3)) / 2 )
```

and the round trip delay `delta`:

```python
# python3
delta = (t3 - t0) - (t2 - t1)
```


where:

`t0` is the client's timestamp of the request packet transmission

`t1` is the server's timestamp of the request packet reception

`t2` is the server's timestamp of the response packet transmission

`t3` is the client's timestamp of the response packet reception.


To derive the expression for the offset, note that for the request packet:

```python
# python3
t0 + theta + (delta / 2) = t1
```

and for the response packet:

```python
# python3
t3 + theta - (delta / 2) = t2
```

Solving for `theta` yields the definition of the time offset.

The values for `theta` and `delta` are passed through filters
and subjected to statistical analysis.

Accurate synchronization is achieved when both the incoming and outgoing routes between client and server have symmetrical nominal delay.
If routes do not have a commin nominal delay,
a systematic bias exists of half the difference between the forward and backward travel times.

### Implementations

- Simple Network Time Protocol (SNTP)
- Windows Time
- OpenNTPD
- Ntimed
- NTPsec
- chrony

### Leap Seconds

On the day of a leap second event, ntpd receives notification from
either a config file, attached reference clock, or remote server.

NTP clock is halted during the event,
time must appear to be strictly increasing,
any provesses that query the system time cause it to increase by a tiny amount,
preserving order of events.

If negative ever comes, it would be deleted with the sequence:
`23:59:58`, `00:00:00`, `23:59:59`

Alternate Implementation:
Leap Smearing consists in introducing the leap second incrementally during a period of 24hrs from noon to noon in UTC. This is used by Google (internally, public NTP servers) and Amazon (AWS).

---

## Blockchain Timekeeping

### Bitcoin

Timestamps are required for the Proof of Work consensus mechanism.

Without a valid timestamp, the network cannot verify whether a particular transaction being mined is trying to revert a previous one. 

Bitcoin uses Unix timestamp for blocks.
Serves as source of variation in block hash,
makes it more difficult to manipulate the chain.

Timestamp is accepted if it is greater than the median timestamp of the previous 11 blocks,
and less than the network-adjusted time + 2 hours.

Network-adjusted time is median of timestamps returned by ALL nodes connected to you.

Block times are only accurate within an hour or two.

When a node connects to another node, it gets a UTC timestamp from it,
stores the ofset from local-node UTC.
Network-Adjusted Time is node-local UTC plus median offset from all connected nodes.

Network time is never adjusted more than 70 minutes from local system time, however.

Bitcoin uses an unsigned int for timestamp, so the 'Year 2038 problem' is delayed another 68 years. 

### Ethereum

`now` is defined as the current time as measured by the miner's CPU.

In order for a mined block to be valid:

...

`block.timestamp <= now + 900`
AND
`block.timestamp >= parent.timestamp`

...

---

## Conclusions

It seems blockchain timestamp accuracy is neglible,
requiring only that it is after the parent timestamp and before an arbitrary amount of time in the future.

Bitcoin allows timestamps a 2 hours future tolerance.

Ethereum allows timestamps a 15 minute future tolerance.

Solutions for centralized systems exist, comprising of a heirarchial system with atomic clocks at the top, with layers made up of peer linked computers,
using a protocol to correct for network latency.

---

## Sources

[Unix Time: Wikipedia](https://en.wikipedia.org/wiki/Unix_time)

[Quartz Clock: Wikipedia](https://en.wikipedia.org/wiki/Quartz_clock#:~:text=Standard%2Dquality%2032%20768%20Hz,%C2%B0F)%20or%20less%20than)

[NIST WWV Time Distribution: NIST.gov](https://www.nist.gov/time-distribution/radio-station-wwv)

[NIST Time and Frequency Receivers: NIST.gov](https://www.nist.gov/time-distribution/radio-station-wwv/manufacturers-time-and-frequency-receivers)

[Network Time Protocol: Wikipedia](https://en.wikipedia.org/wiki/Network_Time_Protocol)

[Bitcoin Block Timestamp: Bitcoin Wiki](https://en.bitcoin.it/wiki/Block_timestamp)

[Ethereum Block Timestamp: Ethereum Wiki](https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md)

[Time-based Blockchain Vulnerabilities: Medium](https://blog.unifiedh.com/on-decentralized-clocks-how-time-became-the-biggest-security-threat-on-blockchain-systems-8a7e13622bb0?gi=5b1a8a9fe551)

[NTP.org](http://www.ntp.org/ntpfaq/NTP-s-algo.htm)

---
