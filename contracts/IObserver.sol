// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IObserver {
    function notify(uint eventCode, address caller) external;
}
