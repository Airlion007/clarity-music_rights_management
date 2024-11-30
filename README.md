# Music Rights and Royalty Distribution Smart Contract

## Contract Overview

The **Music Rights and Royalty Distribution Contract** is a smart contract implemented using Clarity 6.0. This contract allows for the **registration, management, and transfer** of music rights and royalty data on the blockchain. It also facilitates secure distribution of royalties and enables ownership transfers for registered music rights.

This contract is designed to:
- Enable creators and rights holders to register their music rights and assign royalties.
- Allow ownership of music rights to be transferred securely.
- Ensure only authorized parties (such as the contract owner) can register and manage rights.
- Offer transparency and security in royalty data and ownership.

---

## Table of Contents

1. [Contract Features](#contract-features)
2. [How It Works](#how-it-works)
3. [Functions](#functions)
   - [Public Functions](#public-functions)
   - [Read-Only Functions](#read-only-functions)
4. [Usage](#usage)
   - [Deployment](#deployment)
   - [Interacting with the Contract](#interacting-with-the-contract)
5. [Errors](#errors)
6. [Contract Initialization](#contract-initialization)
7. [License](#license)

---

## Contract Features

### Music Right Registration
- The contract allows the **contract owner** to register new music rights, associating each right with royalty data. A unique **non-fungible token (NFT)** is minted for each music right upon registration.
- Supports both **single** and **multiple rights** registration.

### Ownership Transfer
- Rights owners can transfer ownership of their music rights to other principals, providing an easy way to manage transfers of rights.

### Royalty Data Management
- Each music right has associated **royalty data** which can be updated by the owner.

### Revocation of Rights
- The contract owner can revoke rights, removing ownership and the associated royalty data.

### Transparency and Access
- Anyone can check the ownership and royalty data of a music right, providing transparency.

---

## How It Works

The contract keeps track of the following core components:
- **Music Rights**: Each music right is represented as a unique non-fungible token (NFT) linked to royalty data.
- **Royalty Data**: Metadata about royalty distribution is stored for each music right.
- **Ownership**: Tracks the owner of each music right, allowing transfers of ownership.

It utilizes the following:
- **Principal-based Access Control**: Only authorized principals (e.g., contract owner) can register, transfer, or revoke rights.
- **Mapping Structures**: Used to store royalty data and ownership for efficient retrieval and updates.

---

## Functions

### Public Functions

- `register-right`: Registers a new music right and associates it with royalty data. This can only be performed by the contract owner.

- `transfer-right`: Transfers ownership of a music right to a new principal. The current owner must approve the transfer.

- `update-royalty-data`: Updates the royalty data associated with a music right. This can only be done by the current owner of the right.

- `revoke-right`: Revokes a registered music right, removing ownership and associated data. Only the contract owner can revoke rights.

- `register-multiple-rights`: Allows the contract owner to register multiple music rights at once.

- `is-caller-owner`: Checks if the caller is the contract owner.

- `get-last-registered-right-id`: Retrieves the ID of the last registered music right.

- `is-right-registered?`: Checks whether a specific music right has been registered.

### Read-Only Functions

- `get-royalty-data`: Fetches the royalty data associated with a specific music right.

- `get-owner`: Fetches the current owner of a specific music right.

- `right-exists`: Checks if a specific music right exists.

- `get-total-rights`: Returns the total number of rights ever registered in the system.

- `count-registered-rights`: Returns the total count of registered rights.

- `get-all-registered-rights`: Fetches the IDs of all registered music rights.

---

## Usage

### Deployment

1. Deploy the contract to the Clarity 6.0 blockchain using an appropriate blockchain tool.
2. Ensure the contract owner has sufficient permissions to interact with the contract.

### Interacting with the Contract

- To register a music right:
  ```clarity
  (register-right "Royalty data for the music right")
  ```

- To transfer ownership of a music right:
  ```clarity
  (transfer-right <right-id> <new-owner>)
  ```

- To update royalty data:
  ```clarity
  (update-royalty-data <right-id> "Updated royalty data")
  ```

- To revoke a music right:
  ```clarity
  (revoke-right <right-id>)
  ```

- To check if a right is registered:
  ```clarity
  (is-right-registered? <right-id>)
  ```

---

## Errors

The contract defines the following error codes:
- `err-owner-only`: Raised if an operation can only be performed by the contract owner.
- `err-unauthorized`: Raised if an unauthorized principal attempts an operation.
- `err-invalid-royalty-data`: Raised if royalty data is invalid.
- `err-right-already-registered`: Raised if a music right is already registered.
- `err-right-not-found`: Raised if a music right is not found.
- `err-invalid-new-owner`: Raised if the provided new owner is invalid.

---

## Contract Initialization

Upon deployment, the contract initializes with the following setup:
- **last-right-id**: Tracks the ID of the last registered music right (initialized to `u0`).

---

## License

This contract is provided under the [MIT License](LICENSE).
``