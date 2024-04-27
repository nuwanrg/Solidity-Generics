// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.
A library is embedded into the contract if all library functions are internal.
Otherwise the library must be deployed and then linked before the contract is deployed.
*/

library Math{
    function sqrt(uint256 y) internal pure returns (uint256 z){
        if(y>3){
            z=y;
            uint256 x = y / 2 + 1;
            while(x < z){
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0 ) {
                z = 1;
        }
        else {
            z = 0;
        }
    }
}

contract TestMath {
    function testSquareRoot(uint256 x) public pure returns (uint256) {
        return Math.sqrt(x);
    }
}

//2nd library
// Array function to delete element at index and re-organize the array
// so that there are no gaps between the elements.
library Array{
    
    //Removing an Element and Shifting Elements
    function remove(uint256[] storage arr, uint256 index) public{
        require(arr.length > 0, "Cant remove from empty array");
        require(index < arr.length, "Index out of bounds");
        for(uint256 i=index; i<arr.length-1; i++){
            arr[i] = arr[i+1];
        }
        arr.pop();
    }
}

contract TestArray {
    using Array for uint256[];
    uint256[] public arr;

    function testArrayRemove() public {
        for (uint256 i=0; i <5; i++){
            arr.push(i);
        }
        arr.remove(1);

        assert(arr.length ==4);
        assert(arr[0] ==0 );
        assert(arr[1] ==2);
    }
}