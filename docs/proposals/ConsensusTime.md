# Consensus Time

This includes the interface as well as specifications for the conensus time protocol.

## Interface

### Latest Solidity compiler at time of writing
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
```

---

### Interface Definition
```solidity
interface IConsensusTime {
    // ...
}
```

---

### Geographic Positions

- `latitude`
    - 256 bit signed int
    - `latitude * 10_000` or 4 decimal places

- `longitude`
    - 256 bit signed int
    - `longitude * 10_000` or 4 decimal places

```solidity
struct GeographicPositionStruct {
    int256 latitude;
    int256 longitude;
}
```

---

### Time Sources

- `id`
    - the id of the source in an array

- `name`
    - the name of the source

- `location`
    - latitude and longitude pair

```solidity
struct TimeSourceStruct {
    uint256 id;
    string name;
    GeographicPositionStruct location;
}
```

---

### Transmissions

- `sender`
    - address of sender

- `sourceId`
    - id for TimeSource array

- `timestamp`
    - 256 bit unsigned integer
    - milliseconds since the Epoch

- `integrityHash`
    - keccak256 signature of:
        - `sender`
        - `sourceId`
        - `timestamp`

- `signature`
    - secp256k1 signature
        - signer MUST be `sender`
        - messageHash MUST be `integrityHash`

```solidity
struct TransmissionStruct {
    address sender;
    uint256 sourceId;
    uint256 timestamp;
    bytes32 integrityHash;
    bytes signature;
}
```

---

### More to come ...