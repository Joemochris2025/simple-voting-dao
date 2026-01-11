Overview

The Simple Voting DAO provides a basic governance mechanism suitable for:

Community decision-making

Project governance experiments

Educational and learning purposes

DAO prototypes on Stacks

The contract enforces one vote per address per proposal and uses block height to determine voting deadlines.

Features

Admin-controlled proposal creation

YES / NO voting mechanism

One-vote-per-user enforcement

Block-height–based voting window

Transparent, on-chain vote tracking

Read-only functions for querying results

Contract Components
Main Data Structures

proposals – stores proposal metadata and vote counts

votes – tracks voters to prevent double voting

dao-admin – principal authorized to create proposals

Public Functions
Function	Description
create-proposal	Creates a new proposal (admin only)
vote	Cast a YES or NO vote on a proposal
get-proposal	Retrieve proposal details
voting-ended	Check if a proposal’s voting period has ended
Example Usage
Create a Proposal
(contract-call? .simple-voting-dao create-proposal u1 "Increase Budget" u100)

Vote on a Proposal
(contract-call? .simple-voting-dao vote u1 true)

Get Proposal Details
(contract-call? .simple-voting-dao get-proposal u1)
Project Structure

simple-voting-dao.clar     # Clarity smart contract
README.md                 # Documentation
tests/                    # (Optional) Clarinet tests

Testing

Recommended testing scenarios:

Admin-only proposal creation

Voting before and after deadline

Preventing double voting

Accurate YES / NO vote counts

Run tests with Clarinet:

clarinet test
Access Control

Only the DAO admin can create proposals

Any principal can vote once per proposal

Votes are rejected after the voting deadline

License

This project is licensed under the MIT License, allowing free use, modification, and distribution.

Contributing

Contributions are welcome.
Please open an issue or submit a pull request to suggest improvements, bug fixes, or feature enhancements.
