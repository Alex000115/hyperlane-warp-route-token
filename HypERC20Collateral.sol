// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IMailbox {
    function dispatch(uint32 destinationDomain, bytes32 recipientAddress, bytes calldata messageBody) external payable returns (bytes32);
}

/**
 * @title HypERC20Collateral
 * @dev Locks a local ERC-20 token to dispatch a transfer message across chains via Hyperlane Mailbox.
 */
contract HypERC20Collateral is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable wrappedToken;
    IMailbox public immutable mailbox;

    event SentTransfer(uint32 indexed destinationDomain, address indexed sender, uint256 amount);

    constructor(address _token, address _mailbox) Ownable(msg.sender) {
        wrappedToken = IERC20(_token);
        mailbox = IMailbox(_mailbox);
    }

    /**
     * @notice Initiates an interchain transfer of tokens.
     * @param destinationDomain Destination chain's Hyperlane domain identifier.
     * @param recipient Target user wallet on destination chain.
     * @param amount Token quantity to bridge.
     */
    function transferRemote(
        uint32 destinationDomain,
        bytes32 recipient,
        uint256 amount
    ) external payable {
        // Securely pull tokens into this vault contract
        wrappedToken.safeTransferFrom(msg.sender, address(this), amount);

        // Encode token transfer structural details as the message body payload
        bytes memory messagePayload = abi.encode(recipient, amount);

        // Dispatch interchain transaction payload via Hyperlane core mailbox infrastructure
        mailbox.dispatch{value: msg.value}(
            destinationDomain,
            recipient,
            messagePayload
        );

        emit SentTransfer(destinationDomain, msg.sender, amount);
    }
}
