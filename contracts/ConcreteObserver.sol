// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/IObserver.sol";

contract ConcreteObserver is IObserver {
    // This will keep track of notifications received
    event LogNotificationReceived(uint eventCode, address caller);

    function notify(uint eventCode, address caller) external override {
        // Emit an event for demonstration purposes
        emit LogNotificationReceived(eventCode, caller);
    }
}
