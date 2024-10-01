module TokenTransfer {
    use 0x1::Account;
    use 0x1::Coin;
    use 0x1::Voting;
    use 0x1::STV;
    use 0x1::ZKProofs;
    use 0x1::CampaignFinance;

    // Struct that represents a transfer of voting tokens and campaign finance contributions
    struct TransferRecord has key {
        sender: address,
        recipient: address,
        voting_token_amount: u64,
        contribution_amount: u64,
        proof: ZKProofs::Proof,
    }

    // Function to transfer voting tokens, ensuring compliance with the STV voting mechanism and zk-proof validation
    public fun transfer_voting_tokens(
        sender: &signer,
        recipient: address,
        voting_token_amount: u64,
        contribution_amount: u64,
        proof: ZKProofs::Proof
    ) {
        // Ensure the sender has enough voting tokens and campaign funds
        assert!(Coin::balance(sender) >= voting_token_amount, 1001, "Insufficient token balance.");
        assert!(CampaignFinance::balance(sender) >= contribution_amount, 1002, "Insufficient campaign funds.");

        // Verify the zk-proof for the transfer
        let valid_proof = ZKProofs::verify(proof);
        assert!(valid_proof, 1003, "Invalid zk-proof.");

        // Transfer the voting tokens and campaign funds
        Coin::transfer(sender, recipient, voting_token_amount);
        CampaignFinance::transfer(sender, recipient, contribution_amount);

        // Create a transfer record for auditing purposes
        let transfer_record = TransferRecord {
            sender: Account::address_of(sender),
            recipient: recipient,
            voting_token_amount: voting_token_amount,
            contribution_amount: contribution_amount,
            proof: proof,
        };

        // Log the transfer for auditing and compliance
        Voting::log_transfer(transfer_record);
    }
}