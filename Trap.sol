// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IMockResponse {
    function isActive() external view returns (bool);
}

contract Trap is ITrap {
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant discordName = "DISCORD";

    function collect() external view returns (bytes memory) {
        bool active = IMockResponse(RESPONSE_CONTRACT).isActive();
        uint256 version = 1;
        return abi.encode(version, active, discordName);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        (uint256 version, bool active, string memory name) = abi.decode(
            data[0],
            (uint256, bool, string)
        );

        if (version != 1 || !active || bytes(name).length == 0) {
            return (false, bytes(""));
        }

        return (true, abi.encode(name));
    }
}
