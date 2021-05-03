// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface IConsensusTime {

    struct TransmissionStruct {
        address sender;
        uint256 sourceId;
        uint256 timestamp;
        bytes32 integrityHash;
        bytes signature;
    }

    struct TimeSourceStruct {
        uint256 id;
        string name;
        GeographicPositionStruct location;
    }

    struct GeographicPositionStruct {
        int256 latitude;
        int256 longitude;
    }

    // More to come ...

}