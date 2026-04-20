# Project Requirements

## 1. Dynamic NFT

A regular NFT is static — its image and data never change after it's minted. A **dynamic NFT (dNFT)** is one that can change over time based on certain conditions (e.g. user activity, points, or time). The image or data updates to reflect the NFT's current state.

**Requirement:** Mint an NFT that visually or informationally changes as the user interacts with the dApp.

### Token Standard: ERC-721

**ERC-721** is the Ethereum standard for NFTs. Unlike ERC-20 tokens (which are identical and interchangeable), each ERC-721 token is **unique** and has its own ID. This is what makes it an NFT — no two tokens are the same. This project uses ERC-721 as the base for the dynamic NFT.

### Non-Transferable (Soulbound)

Normally, NFTs can be sold or sent to another wallet. This NFT **cannot** — once it's minted to your wallet, it stays there forever and cannot be transferred to anyone else.

This concept is called a **Soulbound Token (SBT)**. The term "soulbound" comes from video games, where an item becomes permanently bound to your character once you pick it up. In the same way, a soulbound NFT is permanently bound to the wallet that received it — it represents *you*, not just something you own.

This makes it ideal for things like identity, reputation, or loyalty — which fits this project perfectly, since the NFT tracks your personal activity and visit history.

**Requirement:** The contract must block all transfers. Once an NFT is minted to a wallet, it cannot be moved.

---

## 2. Metadata & Token URI

**Metadata** is the information attached to an NFT — things like its name, description, image, and any custom attributes (e.g. points, level, visit count). It's usually stored as a JSON file hosted on IPFS (via Pinata in this project).

The **Token URI** is simply the link that points to that JSON file. When a marketplace or app wants to display your NFT, it calls `tokenURI(tokenId)` on the contract, gets the link, fetches the JSON, and renders the NFT.

For a dynamic NFT, the metadata (and therefore the image) changes as the NFT's state changes — the Token URI either points to a different file or the file itself gets updated.

**Requirement:** Each NFT must have metadata hosted on IPFS via Pinata, linked through the contract's `tokenURI` function.

---

## 3. Upgradeable Contract

Smart contracts are normally permanent and cannot be changed once deployed. An **upgradeable contract** uses a proxy pattern (UUPS in this project) that allows the logic of the contract to be updated without changing the contract address or losing existing data.

**Requirement:** The contract must use the UUPS upgradeable pattern (via OpenZeppelin) so that bugs can be fixed and features can be added after deployment.

---

## 4. NFT-Gated Access

The dApp is **gated**, meaning a user cannot access it unless they already own one of the NFTs. When a user connects their wallet, the server checks if they hold an NFT. If they don't, they are blocked from entering.

This is sometimes called **token gating**.

**Requirement:** The server must verify NFT ownership on login/connection. Users without an NFT are denied access.

---

## 5. Unlocking Features Through Visits (Progressive Access)

As a user visits the dApp more times, they unlock access to new features or pages. The server tracks how many times a user has visited and grants additional permissions once a threshold is reached.

The technical term for this is **progressive access** or **role-based access control (RBAC)** tied to on-chain activity. It can also be described as a **loyalty/reputation system** — the more you engage, the more you unlock.

**Requirement:** The server must track visit count per user and unlock additional pages or features once the user crosses a defined visit threshold.
