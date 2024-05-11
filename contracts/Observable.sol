// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/IObserver.sol";

contract Observable {
    IObserver[] private observers;

    // Function to add an observer
    function addObserver(IObserver observer) public {
        observers.push(observer);
    }

    // Function to notify all observers about an event
    function notifyObservers(uint eventCode) public {
        for (uint i = 0; i < observers.length; i++) {
            observers[i].notify(eventCode, msg.sender);
        }
    }
}
