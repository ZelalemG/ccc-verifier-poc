// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IVerifyCleanCoin {
    function verifyCleanCoin(
        address _CCC_address,
        address _currentHolder,
        address _token
    ) external view returns (uint256);
}
